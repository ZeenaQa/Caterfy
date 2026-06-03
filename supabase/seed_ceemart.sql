-- ============================================================
-- Ceemart Seed
-- Run this in your Supabase SQL editor (once).
-- ============================================================

DO $$
DECLARE
  v_vendor_id  uuid := gen_random_uuid();
  v_store_id   uuid := gen_random_uuid();

  -- Sub-category IDs
  sc_produce   uuid := gen_random_uuid();
  sc_dairy     uuid := gen_random_uuid();
  sc_beverages uuid := gen_random_uuid();
  sc_snacks    uuid := gen_random_uuid();
  sc_bakery    uuid := gen_random_uuid();
  sc_household uuid := gen_random_uuid();
  sc_meat      uuid := gen_random_uuid();
  sc_frozen    uuid := gen_random_uuid();

BEGIN

  -- â”€â”€ 1. Auth user + Vendor â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  -- vendors.id is a FK to auth.users(id), so we must create the auth row first.
  -- The handle_new_user trigger fires on auth.users INSERT and auto-creates
  -- the public.vendors row using raw_user_meta_data fields â€” so we supply all
  -- required columns there and skip the manual vendors insert entirely.
  IF NOT EXISTS (SELECT 1 FROM auth.users WHERE email = 'ceemart@caterfy.com') THEN
    INSERT INTO auth.users (
      id, instance_id, aud, role,
      email, encrypted_password,
      email_confirmed_at, confirmation_sent_at,
      created_at, updated_at,
      raw_user_meta_data,
      is_sso_user, deleted_at
    ) VALUES (
      v_vendor_id,
      '00000000-0000-0000-0000-000000000000',
      'authenticated',
      'authenticated',
      'ceemart@caterfy.com',
      crypt('CeemartSystem2025!', gen_salt('bf')),
      now(), now(),
      now(), now(),
      jsonb_build_object(
        'role',          'vendor',
        'name',          'Ceemart',
        'business_type', 'grocery',
        'business_name', 'Ceemart',
        'store_type',    'regular'
      ),
      false, null
    );
    -- Trigger has already inserted into public.vendors; just grab the ID.
    SELECT id INTO v_vendor_id FROM auth.users WHERE email = 'ceemart@caterfy.com';
  ELSE
    SELECT id INTO v_vendor_id FROM auth.users WHERE email = 'ceemart@caterfy.com';
  END IF;

  -- â”€â”€ 2. Store â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  IF NOT EXISTS (SELECT 1 FROM public.stores WHERE category = 'ceemart') THEN
    INSERT INTO public.stores (
      id, vendor_id, name, name_ar, category,
      is_open, latitude, longitude, store_area
    ) VALUES (
      v_store_id, v_vendor_id,
      'Ceemart', 'Ø³ÙŠÙ…Ø§Ø±Øª',
      'ceemart',
      true,
      31.9539, 35.9106,
      'Amman'
    );
  ELSE
    SELECT id INTO v_store_id FROM public.stores WHERE category = 'ceemart';
  END IF;

  -- â”€â”€ 3. Sub-categories â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  INSERT INTO public.sub_categories (id, store_id, name, name_ar)
  VALUES
    (sc_produce,   v_store_id, 'Fresh Produce',  'Ø§Ù„Ø®Ø¶Ø§Ø± ÙˆØ§Ù„ÙÙˆØ§ÙƒÙ‡'),
    (sc_dairy,     v_store_id, 'Dairy & Eggs',   'Ø£Ù„Ø¨Ø§Ù† ÙˆØ¨ÙŠØ¶'),
    (sc_beverages, v_store_id, 'Beverages',      'Ù…Ø´Ø±ÙˆØ¨Ø§Øª'),
    (sc_snacks,    v_store_id, 'Snacks',         'ÙˆØ¬Ø¨Ø§Øª Ø®ÙÙŠÙØ©'),
    (sc_bakery,    v_store_id, 'Bakery',         'Ù…Ø®Ø¨ÙˆØ²Ø§Øª'),
    (sc_household, v_store_id, 'Household',      'Ù…Ù†Ø²Ù„'),
    (sc_meat,      v_store_id, 'Meat & Poultry', 'Ù„Ø­ÙˆÙ… ÙˆØ¯ÙˆØ§Ø¬Ù†'),
    (sc_frozen,    v_store_id, 'Frozen',         'Ù…Ø¬Ù…Ø¯Ø§Øª')
  ON CONFLICT DO NOTHING;

  -- â”€â”€ 4. Products â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  -- image base for brevity
  -- all photos from Unsplash, cropped 400x400

  -- Fresh Produce
  INSERT INTO public.products (id, store_id, sub_category_id, name, description, price, image_url)
  VALUES
    (gen_random_uuid(), v_store_id, sc_produce, 'Bananas',         '1 kg · Fresh',           0.450, 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_produce, 'Red Apples',      '1 kg · Imported',        1.200, 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_produce, 'Cherry Tomatoes', '500 g · Local',          0.750, 'https://images.unsplash.com/photo-1546470427-0d9a9c03e921?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_produce, 'Cucumber',        '1 pc · Fresh',           0.250, 'https://images.unsplash.com/photo-1568584711075-3d021a7c3ca3?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_produce, 'Baby Spinach',    '200 g · Washed & ready', 0.950, 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_produce, 'Avocado',         '1 pc · Ripe',            0.800, 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400&h=400&fit=crop&auto=format&q=80');

  -- Dairy & Eggs
  INSERT INTO public.products (id, store_id, sub_category_id, name, description, price, image_url)
  VALUES
    (gen_random_uuid(), v_store_id, sc_dairy, 'Full Fat Milk',   '1 L · Pasteurised',  0.750, 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_dairy, 'Greek Yogurt',    '400 g · Creamy',     1.150, 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_dairy, 'Free Range Eggs', '12 pcs · Brown',     1.800, 'https://images.unsplash.com/photo-1582169505937-b9992bd01695?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_dairy, 'White Cheese',    '250 g · Salty',      1.500, 'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_dairy, 'Labneh',          '500 g · Thick',      1.200, 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_dairy, 'Butter',          '200 g · Unsalted',   1.350, 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400&h=400&fit=crop&auto=format&q=80');

  -- Beverages
  INSERT INTO public.products (id, store_id, sub_category_id, name, description, price, image_url)
  VALUES
    (gen_random_uuid(), v_store_id, sc_beverages, 'Pepsi',          '1.5 L · Cola',               0.650, 'https://images.unsplash.com/photo-1629203432106-773f939b38fa?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_beverages, 'Mineral Water',  '1.5 L · Still',              0.200, 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_beverages, 'Orange Juice',   '1 L · 100% natural',         1.200, 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_beverages, 'Red Bull',       '250 ml · Energy drink',      1.500, 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_beverages, '7UP',            '1.5 L · Lemon & lime',       0.650, 'https://images.unsplash.com/photo-1625772299848-391b6a87d7b3?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_beverages, 'Iced Green Tea', '500 ml · Lightly sweetened', 0.900, 'https://images.unsplash.com/photo-1556679908-578b0705e64f?w=400&h=400&fit=crop&auto=format&q=80');

  -- Snacks
  INSERT INTO public.products (id, store_id, sub_category_id, name, description, price, image_url)
  VALUES
    (gen_random_uuid(), v_store_id, sc_snacks, 'Lays Classic',   '40 g · Salted chips',   0.500, 'https://images.unsplash.com/photo-1566478221975-7f1b68c2e1b4?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_snacks, 'KitKat',         '45 g · Milk chocolate', 0.600, 'https://images.unsplash.com/photo-1549007994-55a9f50d4936?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_snacks, 'Mixed Nuts',     '200 g · Roasted',       2.500, 'https://images.unsplash.com/photo-1511688878353-3a1ebf5cc19e?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_snacks, 'Oreo Cookies',   '154 g · Original',      1.200, 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_snacks, 'Pringles',       '165 g · Original',      1.800, 'https://images.unsplash.com/photo-1590779033100-c7a40c0b5d24?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_snacks, 'Haribo Gummies', '200 g · Assorted',      1.100, 'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=400&h=400&fit=crop&auto=format&q=80');

  -- Bakery
  INSERT INTO public.products (id, store_id, sub_category_id, name, description, price, image_url)
  VALUES
    (gen_random_uuid(), v_store_id, sc_bakery, 'White Bread',       '600 g · Sliced', 0.350, 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_bakery, 'Whole Wheat Bread', '500 g · Sliced', 0.550, 'https://images.unsplash.com/photo-1549931319-a545dcf3bc7c?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_bakery, 'Butter Croissant',  '1 pc · Flaky',   0.500, 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_bakery, 'Pita Bread',        '8 pcs · Fresh',  0.400, 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_bakery, 'Sesame Bagel',      '1 pc · Soft',    0.450, 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=400&fit=crop&auto=format&q=80');

  -- Household
  INSERT INTO public.products (id, store_id, sub_category_id, name, description, price, image_url)
  VALUES
    (gen_random_uuid(), v_store_id, sc_household, 'Dish Soap',         '500 ml · Lemon scent',    1.200, 'https://images.unsplash.com/photo-1563453392212-326f5e854473?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_household, 'Shampoo',           '400 ml · All hair types', 2.800, 'https://images.unsplash.com/photo-1585232350638-563b01f8c521?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_household, 'Toilet Paper',      '4 rolls · 3-ply',         1.500, 'https://images.unsplash.com/photo-1604357209702-a66f4c4cce9c?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_household, 'Hand Sanitiser',    '250 ml · 70% alcohol',    1.000, 'https://images.unsplash.com/photo-1584483720412-ce931f4aefa8?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_household, 'Laundry Detergent', '1 kg · Powder',           2.200, 'https://images.unsplash.com/photo-1626806787461-102c1bfad5f6?w=400&h=400&fit=crop&auto=format&q=80');

  -- Meat & Poultry
  INSERT INTO public.products (id, store_id, sub_category_id, name, description, price, image_url)
  VALUES
    (gen_random_uuid(), v_store_id, sc_meat, 'Chicken Breast', '500 g · Boneless', 2.500, 'https://images.unsplash.com/photo-1604503468506-a8da13d11dce?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_meat, 'Ground Beef',    '500 g · Fresh',    3.500, 'https://images.unsplash.com/photo-1602470520998-f4a52199a3d6?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_meat, 'Chicken Thighs', '1 kg · Bone-in',   3.200, 'https://images.unsplash.com/photo-1569090518928-5e30bd09b80e?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_meat, 'Beef Sausage',   '300 g · Smoked',   2.200, 'https://images.unsplash.com/photo-1627308595171-d1b5d67129c4?w=400&h=400&fit=crop&auto=format&q=80');

  -- Frozen
  INSERT INTO public.products (id, store_id, sub_category_id, name, description, price, image_url)
  VALUES
    (gen_random_uuid(), v_store_id, sc_frozen, 'Frozen Fries',  '1 kg · Crinkle cut',  1.800, 'https://images.unsplash.com/photo-1573080496219-bb964701c394?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_frozen, 'Frozen Peas',   '500 g · Garden peas', 0.950, 'https://images.unsplash.com/photo-1614565703753-7d9d2a2a8d70?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_frozen, 'Ice Cream Tub', '500 ml · Vanilla',    2.000, 'https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?w=400&h=400&fit=crop&auto=format&q=80'),
    (gen_random_uuid(), v_store_id, sc_frozen, 'Frozen Pizza',  '400 g · Margherita',  2.500, 'https://images.unsplash.com/photo-1565299624596-054ba01be1b0?w=400&h=400&fit=crop&auto=format&q=80');

END $$;

