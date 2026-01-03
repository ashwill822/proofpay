# Vercel Build Error - Fix Guide

## What I Fixed

1. ✅ Added Node.js version requirement to `package.json`
2. ✅ Updated `vercel.json` with function timeout settings

## Common Vercel Build Issues & Solutions

### Issue 1: Build Command
**In Vercel Project Settings:**
- Go to **Settings** → **General**
- **Build Command**: Leave **empty** (or set to `npm run build`)
- **Output Directory**: Leave **empty**
- **Install Command**: `npm install` (default)

### Issue 2: Root Directory
**Make sure it's set correctly:**
- **Root Directory**: `apps/api` (not just `api` or root)

### Issue 3: Node.js Version
**In Vercel Project Settings:**
- Go to **Settings** → **General**
- **Node.js Version**: Set to `18.x` or `20.x`

### Issue 4: Framework Preset
- Should be set to **"Other"** (not Next.js, not Node.js)

## Next Steps

1. **Commit the fixes I made:**
   ```bash
   git add apps/api/package.json apps/api/vercel.json
   git commit -m "Fix Vercel deployment configuration"
   git push
   ```

2. **In Vercel Dashboard:**
   - Go to your project
   - Click **Settings** → **General**
   - Verify:
     - Root Directory: `apps/api`
     - Framework Preset: `Other`
     - Build Command: (empty)
     - Output Directory: (empty)
     - Node.js Version: `18.x` or `20.x`

3. **Redeploy:**
   - Go to **Deployments** tab
   - Find the failed deployment
   - Click the three dots (⋯)
   - Click **Redeploy**

## If Still Failing

**Please share the FULL error message** from Vercel. Look for:
- Red error text
- Stack traces
- Any "Error:" or "Failed:" messages

The error usually appears after the dependency installation completes.

