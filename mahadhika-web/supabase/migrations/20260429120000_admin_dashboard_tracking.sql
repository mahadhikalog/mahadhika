-- Mahadhika: profiles, shipments, shipment_events + RLS + public RPC get_public_tracking

-- ---------------------------------------------------------------------------
-- profiles (must exist before is_admin(); Postgres validates SQL function bodies)
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
  full_name text,
  role text NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'admin')),
  created_at timestamptz NOT NULL DEFAULT timezone('utc'::text, now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE INDEX IF NOT EXISTS profiles_role_idx ON public.profiles (role);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- ---------------------------------------------------------------------------
-- Helper: admin check (SECURITY DEFINER avoids RLS recursion on profiles)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.is_admin()
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
      AND role = 'admin'
  );
$$;

REVOKE ALL ON FUNCTION public.is_admin() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;

DROP POLICY IF EXISTS "profiles_select_own_or_admin" ON public.profiles;
CREATE POLICY "profiles_select_own_or_admin"
  ON public.profiles
  FOR SELECT
  TO authenticated
  USING (id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS "profiles_update_own_or_admin" ON public.profiles;
CREATE POLICY "profiles_update_own_or_admin"
  ON public.profiles
  FOR UPDATE
  TO authenticated
  USING (id = auth.uid() OR public.is_admin())
  WITH CHECK (id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS "profiles_admin_insert" ON public.profiles;
CREATE POLICY "profiles_admin_insert"
  ON public.profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (public.is_admin());

-- ---------------------------------------------------------------------------
-- shipments
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.shipments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tracking_number text NOT NULL,
  current_status text NOT NULL DEFAULT 'registered',
  recipient_city text,
  estimated_delivery_date date,
  internal_notes text,
  created_at timestamptz NOT NULL DEFAULT timezone('utc'::text, now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc'::text, now()),
  CONSTRAINT shipments_tracking_number_unique UNIQUE (tracking_number)
);

CREATE INDEX IF NOT EXISTS shipments_tracking_number_idx ON public.shipments (tracking_number);

ALTER TABLE public.shipments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "shipments_admin_all" ON public.shipments;
CREATE POLICY "shipments_admin_all"
  ON public.shipments
  FOR ALL
  TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- ---------------------------------------------------------------------------
-- shipment_events
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.shipment_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  shipment_id uuid NOT NULL REFERENCES public.shipments (id) ON DELETE CASCADE,
  status_label text NOT NULL,
  location text,
  occurred_at timestamptz NOT NULL DEFAULT timezone('utc'::text, now()),
  created_at timestamptz NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE INDEX IF NOT EXISTS shipment_events_shipment_id_idx ON public.shipment_events (shipment_id);
CREATE INDEX IF NOT EXISTS shipment_events_occurred_at_idx ON public.shipment_events (occurred_at DESC);

ALTER TABLE public.shipment_events ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "shipment_events_admin_all" ON public.shipment_events;
CREATE POLICY "shipment_events_admin_all"
  ON public.shipment_events
  FOR ALL
  TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- ---------------------------------------------------------------------------
-- Public read-safe tracking (no direct table SELECT for anon)
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.get_public_tracking(p_tracking_number text)
RETURNS jsonb
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_normalized text;
  v_shipment public.shipments%ROWTYPE;
  v_events jsonb;
BEGIN
  IF p_tracking_number IS NULL THEN
    RETURN NULL;
  END IF;

  v_normalized := trim(p_tracking_number);
  IF v_normalized = '' THEN
    RETURN NULL;
  END IF;

  SELECT *
  INTO v_shipment
  FROM public.shipments s
  WHERE s.tracking_number = v_normalized
  LIMIT 1;

  IF NOT FOUND THEN
    RETURN NULL;
  END IF;

  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'status_label', e.status_label,
        'location', e.location,
        'occurred_at', e.occurred_at
      )
      ORDER BY e.occurred_at DESC, e.created_at DESC
    ),
    '[]'::jsonb
  )
  INTO v_events
  FROM public.shipment_events e
  WHERE e.shipment_id = v_shipment.id;

  RETURN jsonb_build_object(
    'tracking_number', v_shipment.tracking_number,
    'current_status', v_shipment.current_status,
    'recipient_city', v_shipment.recipient_city,
    'estimated_delivery_date', v_shipment.estimated_delivery_date,
    'events', v_events
  );
END;
$$;

REVOKE ALL ON FUNCTION public.get_public_tracking(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.get_public_tracking(text) TO anon, authenticated;

-- ---------------------------------------------------------------------------
-- Auto-create profile row for new auth users
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.profiles (id, role)
  VALUES (NEW.id, 'user')
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();
