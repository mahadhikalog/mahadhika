-- Mahadhika: extend profiles.role (viewer, operator, admin), RBAC helpers, shipment policies

-- ---------------------------------------------------------------------------
-- Relax CHECK constraint on profiles.role (must drop before rewriting values)
-- ---------------------------------------------------------------------------
ALTER TABLE public.profiles
  DROP CONSTRAINT IF EXISTS profiles_role_check;

-- ---------------------------------------------------------------------------
-- Data migration: legacy 'user' → 'viewer'
-- ---------------------------------------------------------------------------
UPDATE public.profiles
SET role = 'viewer'
WHERE role = 'user';

ALTER TABLE public.profiles
  ADD CONSTRAINT profiles_role_check
    CHECK (
      role = ANY (
        ARRAY['admin'::text, 'viewer'::text, 'operator'::text]
      )
    );

ALTER TABLE public.profiles
  ALTER COLUMN role SET DEFAULT 'viewer';

-- ---------------------------------------------------------------------------
-- Default for new signup rows via trigger (match PRD wording)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, role)
  VALUES (NEW.id, 'viewer')
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

-- ---------------------------------------------------------------------------
-- RBAC helpers (SECURITY DEFINER; avoid RLS recursion on profiles where needed)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.dashboard_has_access()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE id = auth.uid()
      AND role = ANY (ARRAY['admin'::text, 'viewer'::text, 'operator'::text])
  );
$$;

CREATE OR REPLACE FUNCTION public.dashboard_can_manage_shipments()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles
    WHERE id = auth.uid()
      AND role = ANY (ARRAY['admin'::text, 'operator'::text])
  );
$$;

REVOKE ALL ON FUNCTION public.dashboard_has_access() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.dashboard_has_access() TO authenticated;

REVOKE ALL ON FUNCTION public.dashboard_can_manage_shipments() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.dashboard_can_manage_shipments() TO authenticated;

-- is_admin() unchanged semantics (role = 'admin'); keep GRANT as before

-- ---------------------------------------------------------------------------
-- shipments: viewer SELECT only; operator + admin INSERT/UPDATE/DELETE
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS "shipments_admin_all" ON public.shipments;

CREATE POLICY "shipments_dashboard_select"
  ON public.shipments
  FOR SELECT
  TO authenticated
  USING (public.dashboard_has_access());

CREATE POLICY "shipments_dashboard_insert"
  ON public.shipments
  FOR INSERT
  TO authenticated
  WITH CHECK (public.dashboard_can_manage_shipments());

CREATE POLICY "shipments_dashboard_update"
  ON public.shipments
  FOR UPDATE
  TO authenticated
  USING (public.dashboard_can_manage_shipments())
  WITH CHECK (public.dashboard_can_manage_shipments());

CREATE POLICY "shipments_dashboard_delete"
  ON public.shipments
  FOR DELETE
  TO authenticated
  USING (public.dashboard_can_manage_shipments());

-- ---------------------------------------------------------------------------
-- shipment_events: same RBAC split
-- ---------------------------------------------------------------------------
DROP POLICY IF EXISTS "shipment_events_admin_all" ON public.shipment_events;

CREATE POLICY "shipment_events_dashboard_select"
  ON public.shipment_events
  FOR SELECT
  TO authenticated
  USING (public.dashboard_has_access());

CREATE POLICY "shipment_events_dashboard_insert"
  ON public.shipment_events
  FOR INSERT
  TO authenticated
  WITH CHECK (public.dashboard_can_manage_shipments());

CREATE POLICY "shipment_events_dashboard_update"
  ON public.shipment_events
  FOR UPDATE
  TO authenticated
  USING (public.dashboard_can_manage_shipments())
  WITH CHECK (public.dashboard_can_manage_shipments());

CREATE POLICY "shipment_events_dashboard_delete"
  ON public.shipment_events
  FOR DELETE
  TO authenticated
  USING (public.dashboard_can_manage_shipments());

-- ---------------------------------------------------------------------------
-- Admin-only listing: profiles + auth email (definer bypasses profiles RLS)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.admin_list_profiles()
RETURNS TABLE (
  id uuid,
  full_name text,
  role text,
  email text,
  created_at timestamptz,
  updated_at timestamptz
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT p.id, p.full_name, p.role, u.email::text, p.created_at, p.updated_at
  FROM public.profiles AS p
  INNER JOIN auth.users AS u ON u.id = p.id
  WHERE (SELECT public.is_admin());
$$;

REVOKE ALL ON FUNCTION public.admin_list_profiles() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.admin_list_profiles() TO authenticated;
