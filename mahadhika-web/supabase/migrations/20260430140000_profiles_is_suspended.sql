-- Mahadhika: suspend user (dashboard access + RLS helpers)

ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS is_suspended boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN public.profiles.is_suspended IS 'When true: no dashboard/session policy access; enforced in is_admin/dashboard_* helpers + client auth.';

-- ---------------------------------------------------------------------------
-- Helpers: suspended users lose dashboard privileges (same as revoked role)
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
    FROM public.profiles AS p
    WHERE p.id = auth.uid()
      AND p.role = 'admin'
      AND COALESCE(p.is_suspended, false) = false
  );
$$;

CREATE OR REPLACE FUNCTION public.dashboard_has_access()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.profiles AS p
    WHERE p.id = auth.uid()
      AND p.role = ANY (ARRAY['admin'::text, 'viewer'::text, 'operator'::text])
      AND COALESCE(p.is_suspended, false) = false
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
    FROM public.profiles AS p
    WHERE p.id = auth.uid()
      AND p.role = ANY (ARRAY['admin'::text, 'operator'::text])
      AND COALESCE(p.is_suspended, false) = false
  );
$$;

-- ---------------------------------------------------------------------------
-- Only active admins may change is_suspended; cannot self-suspend while active
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.profiles_guard_is_suspended_changes()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_caller uuid := auth.uid();
BEGIN
  IF OLD.is_suspended IS NOT DISTINCT FROM NEW.is_suspended THEN
    RETURN NEW;
  END IF;

  IF NOT (SELECT public.is_admin()) THEN
    RAISE EXCEPTION 'Hanya admin aktif yang dapat mengubah status penangguhan akun.'
      USING ERRCODE = '42501';
  END IF;

  IF v_caller = NEW.id AND COALESCE(NEW.is_suspended, false) = true
     AND COALESCE(OLD.is_suspended, false) = false THEN
    RAISE EXCEPTION 'Tidak dapat menangguhkan akun Anda sendiri.'
      USING ERRCODE = '42501';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS profiles_is_suspended_guard ON public.profiles;
CREATE TRIGGER profiles_is_suspended_guard
  BEFORE UPDATE OF is_suspended ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.profiles_guard_is_suspended_changes();

-- ---------------------------------------------------------------------------
-- Admin listing includes suspension flag
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.admin_list_profiles()
RETURNS TABLE (
  id uuid,
  full_name text,
  role text,
  email text,
  is_suspended boolean,
  created_at timestamptz,
  updated_at timestamptz
)
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT p.id, p.full_name, p.role, u.email::text, p.is_suspended, p.created_at, p.updated_at
  FROM public.profiles AS p
  INNER JOIN auth.users AS u ON u.id = p.id
  WHERE (SELECT public.is_admin());
$$;
