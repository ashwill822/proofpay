# How to Check Vercel API Logs

## Step 1: Access Vercel Dashboard

1. **Go to Vercel Dashboard:**
   - Visit: https://vercel.com
   - Sign in with your account

2. **Find Your API Project:**
   - Look for your API project (likely named something like `proofpay-api` or `aussieadrenaline-api`)
   - Click on the project name to open it

## Step 2: Open Logs

1. **Navigate to Logs Tab:**
   - In your project dashboard, click on the **"Logs"** tab (usually in the top navigation bar)
   - Or look for "Functions" → "Logs" in the sidebar

2. **Filter by Function:**
   - You should see a list of functions/deployments
   - Look for the most recent deployment (should have a timestamp)
   - Or look for function logs from your API routes

## Step 3: Search for the Specific Log

1. **Use Search/Filter:**
   - Look for a search box or filter in the logs view
   - Type: `🔍 Fetched receipt items` (or just `Fetched receipt items`)
   - This will filter the logs to show only matching entries

2. **Or Scroll Through Recent Logs:**
   - If there's no search, scroll through the recent logs
   - Look for log entries with timestamps from when you last accessed the QR link
   - Find the log line that contains: `🔍 Fetched receipt items:`

## Step 4: Read the Log Details

The log entry will look something like this:

```json
{
  "level": 30,
  "time": 1767417278849,
  "msg": "🔍 Fetched receipt items:",
  "itemCount": 2,
  "firstItem": { ... },
  "hasItemName": true/false,
  "itemNameValue": "Item Name Here" or "MISSING",
  "allKeys": ["id", "receipt_id", "item_name", "item_price", "quantity", ...]
}
```

**What to Look For:**
- `itemCount`: Number of items fetched (should be > 0)
- `hasItemName`: `true` means `item_name` exists, `false` means it's missing
- `itemNameValue`: The actual value of `item_name` (or "MISSING" if not present)
- `allKeys`: Array of all field names present in the item (check if `item_name` is in this list)

## Alternative: Check via Vercel CLI

If you have Vercel CLI installed, you can also check logs from terminal:

1. **Install Vercel CLI** (if not already installed):
   ```bash
   npm i -g vercel
   ```

2. **Login to Vercel:**
   ```bash
   vercel login
   ```

3. **Link your project:**
   ```bash
   cd apps/api
   vercel link
   ```

4. **View logs:**
   ```bash
   vercel logs
   ```
   
   Or for real-time logs:
   ```bash
   vercel logs --follow
   ```

5. **Filter logs:**
   - Use `grep` or pipe to filter:
   ```bash
   vercel logs | grep "Fetched receipt items"
   ```

## Step 5: Trigger a New Request (If Needed)

If you don't see recent logs:

1. **Open the QR link again:**
   - Go to your receipt with the QR code
   - Scan or click the QR link
   - This will trigger a new API request

2. **Wait a few seconds:**
   - Vercel logs may take a few seconds to appear

3. **Refresh the logs view:**
   - Click refresh or reload the logs page
   - Look for the new log entry

## What the Logs Tell You

- **If `hasItemName: true` and `itemNameValue` has a value:**
  - The database query is working correctly
  - The issue might be in how the data is being sent to the frontend

- **If `hasItemName: false` or `itemNameValue: "MISSING"`:**
  - The `item_name` field is NOT in the database result
  - This means either:
    - The items in the database don't have `item_name` values (they're NULL)
    - There's a database query issue

- **If `item_name` is NOT in `allKeys`:**
  - The field is completely missing from the database response
  - This confirms the database doesn't have `item_name` for these items

