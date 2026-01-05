# SQL Scripts

This directory contains SQL scripts for database maintenance and backfill operations.

## Scripts

### `backfill_receipt_items_item_name.sql`

**Purpose:** Backfills `item_name` values in the `receipt_items` table.

**When to use:**
- If you have existing `receipt_items` rows with NULL or empty `item_name` values
- After verifying that the simulate-purchase flow now writes `item_name` correctly
- To clean up any edge cases from old data

**What it does:**
1. Checks for NULL or empty `item_name` values
2. If a legacy `name` column exists, copies it to `item_name` where needed
3. Sets NULL values to 'Unknown Item' as fallback
4. Sets empty strings to 'Unknown Item' as fallback
5. Provides verification queries

**How to run:**

1. **Go to Supabase Dashboard:**
   - Visit: https://app.supabase.com
   - Select your project

2. **Open SQL Editor:**
   - Click **SQL Editor** in the left sidebar
   - Click **New Query**

3. **Run the Script:**
   - Open: `infra/sql/backfill_receipt_items_item_name.sql`
   - Copy the entire contents
   - Paste into the SQL Editor
   - Click **Run** (or press Ctrl+Enter)

4. **Review the Output:**
   - Check the NOTICE messages for results
   - Review the verification queries to confirm counts

**Important Notes:**

- **Schema:** The `receipt_items` table only has `item_name` (no `name` column). This is the correct schema.
- **Simulate Purchase:** The simulate-purchase endpoint (`apps/web/app/api/demo/simulate-purchase/route.ts`) now correctly writes `item_name` from `item.name`.
- **Old Receipts:** If you have old demo receipts with "Unknown Item", they should be regenerated using the demo store's simulate-purchase feature.
- **NULL Values:** The `item_name` column is defined as `NOT NULL`, so NULL values should not exist. This script handles them as a safety measure.

**Expected Behavior:**

- All `receipt_items` should have non-empty `item_name` values
- Items with "Unknown Item" should be rare (only old data or edge cases)
- New receipts created via simulate-purchase will have proper `item_name` values

**Troubleshooting:**

If you see many items with "Unknown Item":
1. These are likely old demo receipts created before the fix
2. Regenerate them using the demo store: https://proofpay-web.vercel.app/demo-store
3. The simulate-purchase endpoint now writes `item_name` correctly

