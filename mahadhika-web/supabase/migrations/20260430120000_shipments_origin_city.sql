-- Tambah kota asal kiriman; selaras dengan recipient_city

ALTER TABLE public.shipments
  ADD COLUMN IF NOT EXISTS origin_city text;

COMMENT ON COLUMN public.shipments.origin_city IS 'Kota atau lokasi asal pengiriman (opsional).';

-- Sertakan origin_city di payload publik Cek Resi
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
    'origin_city', v_shipment.origin_city,
    'recipient_city', v_shipment.recipient_city,
    'estimated_delivery_date', v_shipment.estimated_delivery_date,
    'events', v_events
  );
END;
$$;
