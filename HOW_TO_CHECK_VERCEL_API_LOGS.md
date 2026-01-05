# How to Check Vercel API Logs

## Step 1: Go to Vercel Dashboard

1. **Open Vercel Dashboard:**
   - Go to: https://vercel.com/dashboard
   - Sign in to your account

2. **Select Your Project:**
   - Find and click on your API project (likely named something like `proofpay-api` or `aussieadrenaline-api`)

## Step 2: Navigate to Logs

1. **Click on "Logs" tab:**
   - In the project dashboard, look for the **"Logs"** tab in the top navigation
   - Or go directly to: `https://vercel.com/[your-team]/[your-project]/logs`

2. **Select the API Function:**
   - You should see a list of functions/deployments
   - Look for your API function (e.g., `api/app.js` or similar)

## Step 3: Filter Logs

1. **Filter by Function:**
   - Use the filter dropdown to select your API function
   - Or search for specific log messages like `[VERIFY]` or `[RECEIPT-SHARE]`

2. **Filter by Time:**
   - Select the time range (e.g., "Last hour", "Last 24 hours")
   - Or use custom date range

## Step 4: Look for Debug Messages

Search for these log messages:
- `🔍 [VERIFY]` - Debug messages about item fetching
- `✅ [VERIFY]` - Success messages
- `⚠️ [VERIFY]` - Warning messages about missing item_name
- `❌ [VERIFY]` - Error messages
- `[RECEIPT-SHARE]` - Messages from receipt-shares.js

## Step 5: Check Real-Time Logs

1. **Open Real-Time Logs:**
   - Click on a specific deployment
   - Look for "Real-time Logs" or "Function Logs"
   - This shows logs as they happen

2. **Test the QR Link:**
   - Open the QR receipt link in a new tab
   - Watch the logs update in real-time
   - Look for the `🔍 [VERIFY]` messages showing what data is being fetched

## Alternative: Check via Vercel CLI

If you have Vercel CLI installed:

```bash
# Install Vercel CLI (if not installed)
npm i -g vercel

# Login
vercel login

# View logs
vercel logs [your-project-name] --follow
```

## What to Look For

When testing the QR receipt link, you should see logs like:

```
🔍 [VERIFY] Fetching receipt_items directly from DB
✅ [VERIFY] Receipt items fetched from DB
  - item_count: 2
  - first_item_keys: id, receipt_id, item_name, item_price, quantity, ...
  - first_item_has_item_name: true
  - first_item_name: "Training Backpack"
```

If you see:
- `first_item_has_item_name: false` - The database query is not returning item_name
- `first_item_name: MISSING` - item_name is not in the response
- `⚠️ [VERIFY] Item missing item_name` - An item is missing item_name after mapping

## Quick Access URL

Your Vercel logs URL should be something like:
```
https://vercel.com/[your-team]/[your-project]/logs
```

Or for a specific deployment:
```
https://vercel.com/[your-team]/[your-project]/[deployment-id]/logs
```

