-- Fix only the products with missing or wrong images.
-- Run in Supabase SQL Editor.

DO $$
DECLARE
  v_store_id uuid;
BEGIN
  SELECT id INTO v_store_id FROM public.stores WHERE category = 'ceemart' LIMIT 1;
  IF v_store_id IS NULL THEN RAISE EXCEPTION 'Ceemart store not found'; END IF;

  -- Labneh (white soft cheese / strained yogurt)
  UPDATE public.products SET image_url =
    'https://images.unsplash.com/photo-1559598467-f8b76c8155d0?w=400&h=400&fit=crop&auto=format&q=80'
  WHERE store_id = v_store_id AND name = 'Labneh';

  -- Iced Green Tea
  UPDATE public.products SET image_url =
    'https://images.unsplash.com/photo-1627916680913-7d7e65279a1e?w=400&h=400&fit=crop&auto=format&q=80'
  WHERE store_id = v_store_id AND name = 'Iced Green Tea';

  -- Whole Wheat Bread
  UPDATE public.products SET image_url =
    'https://images.unsplash.com/photo-1549931319-a545dcf3bc7c?w=400&h=400&fit=crop&auto=format&q=80'
  WHERE store_id = v_store_id AND name = 'Whole Wheat Bread';

  -- Sesame Bagel
  UPDATE public.products SET image_url =
    'https://images.unsplash.com/photo-1585325701165-8e50f7b2de73?w=400&h=400&fit=crop&auto=format&q=80'
  WHERE store_id = v_store_id AND name = 'Sesame Bagel';

  -- Chicken Breast (raw)
  UPDATE public.products SET image_url =
    'https://images.unsplash.com/photo-1587593810167-a84920ea0781?w=400&h=400&fit=crop&auto=format&q=80'
  WHERE store_id = v_store_id AND name = 'Chicken Breast';

  -- Chicken Thighs (raw)
  UPDATE public.products SET image_url =
    'https://images.unsplash.com/photo-1594149929911-78975a43d4f5?w=400&h=400&fit=crop&auto=format&q=80'
  WHERE store_id = v_store_id AND name = 'Chicken Thighs';

  -- Frozen Fries
  UPDATE public.products SET image_url =
    'https://images.unsplash.com/photo-1541592106381-b31e9677c0e5?w=400&h=400&fit=crop&auto=format&q=80'
  WHERE store_id = v_store_id AND name = 'Frozen Fries';

  -- Frozen Peas
  UPDATE public.products SET image_url =
    'https://images.unsplash.com/photo-1542838686-937b45ce3c12?w=400&h=400&fit=crop&auto=format&q=80'
  WHERE store_id = v_store_id AND name = 'Frozen Peas';

  -- Frozen Pizza
  UPDATE public.products SET image_url =
    'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=400&fit=crop&auto=format&q=80'
  WHERE store_id = v_store_id AND name = 'Frozen Pizza';

  -- Beef Sausage (fix wrong image)
  UPDATE public.products SET image_url =
    'https://images.unsplash.com/photo-1558030006-450675393462?w=400&h=400&fit=crop&auto=format&q=80'
  WHERE store_id = v_store_id AND name = 'Beef Sausage';

END $$;
