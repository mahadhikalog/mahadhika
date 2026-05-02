-- Kota asal wajib; nilai standar Jakarta

UPDATE public.shipments
SET origin_city = 'Jakarta'
WHERE origin_city IS NULL
   OR btrim(origin_city) = '';

ALTER TABLE public.shipments
  ALTER COLUMN origin_city SET DEFAULT 'Jakarta';

ALTER TABLE public.shipments
  ALTER COLUMN origin_city SET NOT NULL;

COMMENT ON COLUMN public.shipments.origin_city IS 'Kota asal pengiriman (wajib; bawaan Jakarta).';
