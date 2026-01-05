-- Backfill Script: Populate item_name in receipt_items
-- 
-- Purpose: Ensure all receipt_items rows have proper item_name values
-- 
-- Notes:
-- - The item_name column is defined as NOT NULL, so NULL values should not exist
-- - This script handles edge cases: NULL values, empty strings
-- - If a legacy 'name' column exists, it will be copied to item_name
-- - Old demo receipts with missing item_name should be regenerated via simulate-purchase
--
-- Confirmed: The simulate-purchase flow now writes item_name correctly (see apps/web/app/api/demo/simulate-purchase/route.ts)

-- Step 1: Check for NULL or empty item_name values
-- Run this first to see what needs to be fixed
SELECT 
  COUNT(*) as total_items,
  COUNT(CASE WHEN item_name IS NULL THEN 1 END) as null_count,
  COUNT(CASE WHEN item_name = '' THEN 1 END) as empty_count,
  COUNT(CASE WHEN item_name = 'Unknown Item' THEN 1 END) as unknown_count
FROM receipt_items;

-- Step 2: Check if legacy 'name' column exists (optional - only if someone added it)
-- This checks if a 'name' column exists in receipt_items table
-- If it does exist, we can copy it to item_name
DO $$
BEGIN
  -- Check if 'name' column exists
  IF EXISTS (
    SELECT 1 
    FROM information_schema.columns 
    WHERE table_name = 'receipt_items' 
    AND column_name = 'name'
  ) THEN
    RAISE NOTICE 'Legacy "name" column found. Copying name -> item_name where item_name is NULL or empty.';
    
    -- Copy name -> item_name where item_name is NULL or empty
    UPDATE receipt_items
    SET item_name = name
    WHERE (item_name IS NULL OR item_name = '')
      AND name IS NOT NULL 
      AND name != '';
      
    RAISE NOTICE 'Copied % rows from name to item_name.', ROW_COUNT;
  ELSE
    RAISE NOTICE 'No legacy "name" column found. This is expected - the schema only has item_name.';
  END IF;
END $$;

-- Step 3: Handle NULL values (should not exist due to NOT NULL constraint, but safe to run)
-- Set NULL values to 'Unknown Item' as fallback
UPDATE receipt_items
SET item_name = 'Unknown Item'
WHERE item_name IS NULL;

-- Step 4: Handle empty strings
-- Set empty strings to 'Unknown Item' as fallback
UPDATE receipt_items
SET item_name = 'Unknown Item'
WHERE item_name = '';

-- Step 5: Verify the update
-- Run this to confirm all items now have non-empty item_name
SELECT 
  COUNT(*) as total_items,
  COUNT(CASE WHEN item_name IS NULL THEN 1 END) as null_count,
  COUNT(CASE WHEN item_name = '' THEN 1 END) as empty_count,
  COUNT(CASE WHEN item_name = 'Unknown Item' THEN 1 END) as unknown_count,
  COUNT(CASE WHEN item_name IS NOT NULL AND item_name != '' AND item_name != 'Unknown Item' THEN 1 END) as valid_count
FROM receipt_items;

-- Success message
DO $$
DECLARE
  valid_count INTEGER;
  unknown_count INTEGER;
BEGIN
  SELECT 
    COUNT(CASE WHEN item_name IS NOT NULL AND item_name != '' AND item_name != 'Unknown Item' THEN 1 END),
    COUNT(CASE WHEN item_name = 'Unknown Item' THEN 1 END)
  INTO valid_count, unknown_count
  FROM receipt_items;
  
  RAISE NOTICE 'Backfill completed.';
  RAISE NOTICE 'Valid item_name values: %', valid_count;
  RAISE NOTICE 'Items with "Unknown Item" fallback: %', unknown_count;
  
  IF unknown_count > 0 THEN
    RAISE NOTICE '';
    RAISE NOTICE '⚠️  WARNING: % items still have "Unknown Item" as item_name.', unknown_count;
    RAISE NOTICE 'These items likely need to be regenerated via the demo store simulate-purchase flow.';
    RAISE NOTICE 'The simulate-purchase endpoint now correctly writes item_name (see apps/web/app/api/demo/simulate-purchase/route.ts).';
  END IF;
END $$;

