-- ============================================================
-- Update Ceemart: better descriptions + fix frozen images
-- Run in Supabase SQL Editor.
-- ============================================================

DO $$
DECLARE v_store_id uuid;
BEGIN
  SELECT id INTO v_store_id FROM public.stores WHERE category = 'ceemart' LIMIT 1;
  IF v_store_id IS NULL THEN RAISE EXCEPTION 'Ceemart store not found'; END IF;

  -- ── Fresh Produce ─────────────────────────────────────────────────────────
  UPDATE public.products SET description = 'Sweet and energy-packed — great for smoothies, cereal, or snacking on the go'
    WHERE store_id = v_store_id AND name = 'Bananas';
  UPDATE public.products SET description = 'Crisp, naturally sweet and refreshing — perfect for snacking or baking'
    WHERE store_id = v_store_id AND name = 'Red Apples';
  UPDATE public.products SET description = 'Bite-sized and bursting with flavour — toss in salads or roast with olive oil'
    WHERE store_id = v_store_id AND name = 'Cherry Tomatoes';
  UPDATE public.products SET description = 'Cool, hydrating and crunchy — ideal for salads, dips, or snacking'
    WHERE store_id = v_store_id AND name = 'Cucumber';
  UPDATE public.products SET description = 'Tender young leaves, washed and ready — packed with iron and vitamins'
    WHERE store_id = v_store_id AND name = 'Baby Spinach';
  UPDATE public.products SET description = 'Creamy, rich and heart-healthy — perfect on toast, in salads or guacamole'
    WHERE store_id = v_store_id AND name = 'Avocado';

  -- ── Dairy & Eggs ──────────────────────────────────────────────────────────
  UPDATE public.products SET description = 'Rich, creamy whole milk — great for coffee, cooking or drinking cold'
    WHERE store_id = v_store_id AND name = 'Full Fat Milk';
  UPDATE public.products SET description = 'Thick, tangy and high in protein — delicious with fruit, honey or granola'
    WHERE store_id = v_store_id AND name = 'Greek Yogurt';
  UPDATE public.products SET description = 'Laid by free-range hens — firm golden yolks and superior taste'
    WHERE store_id = v_store_id AND name = 'Free Range Eggs';
  UPDATE public.products SET description = 'Firm and pleasantly salty — slice for sandwiches or crumble over salads'
    WHERE store_id = v_store_id AND name = 'White Cheese';
  UPDATE public.products SET description = 'Silky smooth strained yogurt — serve with olive oil, za''atar and flatbread'
    WHERE store_id = v_store_id AND name = 'Labneh';
  UPDATE public.products SET description = 'Pure, smooth and richly flavoured — ideal for baking, cooking or spreading'
    WHERE store_id = v_store_id AND name = 'Butter';

  -- ── Beverages ─────────────────────────────────────────────────────────────
  UPDATE public.products SET description = 'The iconic cola refresher — best served ice cold over plenty of ice'
    WHERE store_id = v_store_id AND name = 'Pepsi';
  UPDATE public.products SET description = 'Pure still mineral water — crisp, clean and refreshing every single sip'
    WHERE store_id = v_store_id AND name = 'Mineral Water';
  UPDATE public.products SET description = 'Cold-pressed 100% orange juice — bursting with vitamin C, no added sugar'
    WHERE store_id = v_store_id AND name = 'Orange Juice';
  UPDATE public.products SET description = 'The original energy boost — sharpen your focus and power through the day'
    WHERE store_id = v_store_id AND name = 'Red Bull';
  UPDATE public.products SET description = 'Crisp lemon and lime carbonation — light, refreshing and caffeine-free'
    WHERE store_id = v_store_id AND name = '7UP';
  UPDATE public.products SET description = 'Delicately brewed green tea, chilled to perfection — light and antioxidant-rich'
    WHERE store_id = v_store_id AND name = 'Iced Green Tea';

  -- ── Snacks ────────────────────────────────────────────────────────────────
  UPDATE public.products SET description = 'Thin, golden and perfectly salted potato crisps — the ultimate classic snack'
    WHERE store_id = v_store_id AND name = 'Lays Classic';
  UPDATE public.products SET description = 'Crispy wafer fingers wrapped in smooth milk chocolate — break time sorted'
    WHERE store_id = v_store_id AND name = 'KitKat';
  UPDATE public.products SET description = 'Roasted almonds, cashews and walnuts — a wholesome, protein-rich snack'
    WHERE store_id = v_store_id AND name = 'Mixed Nuts';
  UPDATE public.products SET description = 'The world''s favourite cream-filled sandwich cookie — twist, lick and dunk'
    WHERE store_id = v_store_id AND name = 'Oreo Cookies';
  UPDATE public.products SET description = 'Stackable saddle-shaped crisps in the iconic tube — once you pop, you can''t stop'
    WHERE store_id = v_store_id AND name = 'Pringles';
  UPDATE public.products SET description = 'Chewy, colourful and irresistibly fun — the gummy bear classic everyone loves'
    WHERE store_id = v_store_id AND name = 'Haribo Gummies';

  -- ── Bakery ────────────────────────────────────────────────────────────────
  UPDATE public.products SET description = 'Soft, fluffy white loaf sliced fresh daily — the go-to for any sandwich'
    WHERE store_id = v_store_id AND name = 'White Bread';
  UPDATE public.products SET description = 'Hearty, nutty whole wheat — a wholesome everyday choice packed with fibre'
    WHERE store_id = v_store_id AND name = 'Whole Wheat Bread';
  UPDATE public.products SET description = 'Flaky, golden layers of buttery pastry — best enjoyed warm straight from the bag'
    WHERE store_id = v_store_id AND name = 'Butter Croissant';
  UPDATE public.products SET description = 'Soft and pillowy flatbread — perfect for wrapping, dipping or toasting'
    WHERE store_id = v_store_id AND name = 'Pita Bread';
  UPDATE public.products SET description = 'Chewy, golden bagel topped with toasted sesame seeds — toast and top as you like'
    WHERE store_id = v_store_id AND name = 'Sesame Bagel';

  -- ── Household ─────────────────────────────────────────────────────────────
  UPDATE public.products SET description = 'Powerful lemon-scented formula that cuts through grease — leaves dishes spotless'
    WHERE store_id = v_store_id AND name = 'Dish Soap';
  UPDATE public.products SET description = 'Gentle daily shampoo that cleanses and nourishes all hair types from root to tip'
    WHERE store_id = v_store_id AND name = 'Shampoo';
  UPDATE public.products SET description = 'Ultra-soft 3-ply rolls for everyday comfort — strong, absorbent and gentle'
    WHERE store_id = v_store_id AND name = 'Toilet Paper';
  UPDATE public.products SET description = 'Fast-drying 70% alcohol gel — kills 99.9% of germs without water'
    WHERE store_id = v_store_id AND name = 'Hand Sanitiser';
  UPDATE public.products SET description = 'Deep-clean powder formula that lifts tough stains while protecting colours'
    WHERE store_id = v_store_id AND name = 'Laundry Detergent';

  -- ── Meat & Poultry ────────────────────────────────────────────────────────
  UPDATE public.products SET description = 'Lean, boneless fillets — the versatile protein for grills, stir-fries and more'
    WHERE store_id = v_store_id AND name = 'Chicken Breast';
  UPDATE public.products SET description = 'Freshly minced premium beef — ideal for burgers, kofta or rich pasta sauces'
    WHERE store_id = v_store_id AND name = 'Ground Beef';
  UPDATE public.products SET description = 'Juicy bone-in thighs with deep flavour — best grilled, roasted or slow-cooked'
    WHERE store_id = v_store_id AND name = 'Chicken Thighs';
  UPDATE public.products SET description = 'Smoky, seasoned beef sausages — sizzle in a pan or toss straight on the grill'
    WHERE store_id = v_store_id AND name = 'Beef Sausage';

  -- ── Frozen ────────────────────────────────────────────────────────────────
  UPDATE public.products SET description = 'Golden crinkle-cut fries — bake or air-fry for a crispy side in under 20 mins'
    WHERE store_id = v_store_id AND name = 'Frozen Fries';
  UPDATE public.products SET description = 'Flash-frozen at peak freshness to lock in natural sweetness — ready in 3 minutes'
    WHERE store_id = v_store_id AND name = 'Frozen Peas';
  UPDATE public.products SET description = 'Smooth, velvety vanilla ice cream made with real cream — a timeless family favourite'
    WHERE store_id = v_store_id AND name = 'Ice Cream Tub';
  UPDATE public.products SET description = 'Stone-baked Margherita with rich tomato sauce and melted mozzarella — ready in 12 mins'
    WHERE store_id = v_store_id AND name = 'Frozen Pizza';

  -- ── Fix frozen images ─────────────────────────────────────────────────────
  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1576777647209-e8733d7b851d?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Frozen Fries';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Frozen Peas';

  UPDATE public.products SET image_url = 'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=400&h=400&fit=crop&auto=format&q=80'
    WHERE store_id = v_store_id AND name = 'Frozen Pizza';

END $$;
