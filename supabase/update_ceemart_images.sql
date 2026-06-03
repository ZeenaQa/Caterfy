-- ============================================================
-- Fix Ceemart product image URLs
-- All images from Unsplash (permanent CDN links, no expiry).
-- Run in Supabase SQL Editor.
-- ============================================================

DO $$
DECLARE
  v_store_id uuid;
BEGIN
  SELECT id INTO v_store_id FROM public.stores WHERE category = 'ceemart' LIMIT 1;
  IF v_store_id IS NULL THEN
    RAISE EXCEPTION 'Ceemart store not found';
  END IF;

  -- ── Fresh Produce ─────────────────────────────────────────────────────────
  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Bananas';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Red Apples';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Cherry Tomatoes';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Cucumber';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Baby Spinach';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Avocado';

  -- ── Dairy & Eggs ──────────────────────────────────────────────────────────
  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Full Fat Milk';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Greek Yogurt';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1506976785307-8732e854ad03?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Free Range Eggs';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'White Cheese';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1574940387361-0c8370a8b6c0?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Labneh';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Butter';

  -- ── Beverages ─────────────────────────────────────────────────────────────
  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1553456558-aff63285bdd1?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Pepsi';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1564419320461-6870880221ad?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Mineral Water';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Orange Juice';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1551269901-5c5e14c25df7?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Red Bull';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1625772299848-391b6a87d7b3?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = '7UP';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1556679908-578b0705e64f?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Iced Green Tea';

  -- ── Snacks ────────────────────────────────────────────────────────────────
  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Lays Classic';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1606312619070-d48b4c652a52?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'KitKat';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Mixed Nuts';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Oreo Cookies';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Pringles';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Haribo Gummies';

  -- ── Bakery ────────────────────────────────────────────────────────────────
  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'White Bread';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1565181884831-6c8602c70285?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Whole Wheat Bread';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Butter Croissant';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Pita Bread';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1646157016422-501b42d4da89?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Sesame Bagel';

  -- ── Household ─────────────────────────────────────────────────────────────
  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Dish Soap';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1608248597279-f99d160bfcbc?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Shampoo';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Toilet Paper';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1584744982491-665216d95f8b?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Hand Sanitiser';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1604335399105-a0c585fd81a1?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Laundry Detergent';

  -- ── Meat & Poultry ────────────────────────────────────────────────────────
  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1604503468506-a8da13d11dce?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Chicken Breast';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Ground Beef';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1598103442097-8b74394b95c2?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Chicken Thighs';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Beef Sausage';

  -- ── Frozen ────────────────────────────────────────────────────────────────
  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1573080496219-bb964701c394?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Frozen Fries';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1517006493545-45ef56e6e7fb?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Frozen Peas';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1560008581-09826d1de69e?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Ice Cream Tub';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1565299624596-054ba01be1b0?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Frozen Pizza';

END $$;
