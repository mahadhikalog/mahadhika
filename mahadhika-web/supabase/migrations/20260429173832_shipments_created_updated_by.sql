-- Mahadhika: tambah kolom created_by dan updated_by di shipments dan shipment_events

-- ---------------------------------------------------------------------------
-- shipments: tambah created_by dan updated_by (FK ke profiles)
-- ---------------------------------------------------------------------------
ALTER TABLE public.shipments
  ADD COLUMN IF NOT EXISTS created_by uuid REFERENCES public.profiles (id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS updated_by uuid REFERENCES public.profiles (id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS shipments_created_by_idx ON public.shipments (created_by);
CREATE INDEX IF NOT EXISTS shipments_updated_by_idx ON public.shipments (updated_by);

-- ---------------------------------------------------------------------------
-- shipment_events: tambah created_by (events bersifat immutable, tidak ada updated_by)
-- ---------------------------------------------------------------------------
ALTER TABLE public.shipment_events
  ADD COLUMN IF NOT EXISTS created_by uuid REFERENCES public.profiles (id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS shipment_events_created_by_idx ON public.shipment_events (created_by);
