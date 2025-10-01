# 🔥 Firebase Deployment Guide

Complete guide to deploy your Mahadhika Logistik website to Firebase Hosting.

---

## 📋 Prerequisites

- Node.js 18+ installed
- Firebase account ([signup here](https://firebase.google.com))
- Firebase CLI installed
- Project built and tested locally

---

## 🚀 Quick Deploy (First Time)

### Step 1: Install Firebase CLI

```bash
npm install -g firebase-tools
```

### Step 2: Login to Firebase

```bash
firebase login
```

This will open a browser window to authenticate.

### Step 3: Create Firebase Project

**Option A: Via Firebase Console (Recommended)**

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Project name: `mahadhika-logistik` (or your choice)
4. Disable Google Analytics (optional)
5. Click "Create project"
6. Copy your **Project ID**

**Option B: Via CLI**

```bash
firebase projects:create mahadhika-logistik
```

### Step 4: Initialize Firebase in Your Project

```bash
cd /Users/erianshorinurhadi/Documents/Mahadhika/mahadhika-web

# Initialize Firebase
firebase init hosting
```

**When prompted, choose:**

```
? What do you want to use as your public directory? dist
? Configure as a single-page app (rewrite all urls to /index.html)? Yes
? Set up automatic builds and deploys with GitHub? No
? File dist/index.html already exists. Overwrite? No
```

### Step 5: Update Firebase Project ID

Edit `.firebaserc` and replace `your-firebase-project-id` with your actual Firebase Project ID:

```json
{
  "projects": {
    "default": "your-actual-project-id"
  }
}
```

### Step 6: Build Your Project

```bash
npm run build
```

This creates the `dist/` folder with production-ready files.

### Step 7: Deploy to Firebase

```bash
firebase deploy
```

Your site will be live at: `https://your-project-id.web.app`

---

## 🔄 Subsequent Deployments

After the first setup, deploying is simple:

```bash
# Build
npm run build

# Deploy
firebase deploy
```

Or use the npm script:

```bash
npm run deploy:firebase
```

---

## 🌐 Custom Domain Setup

### Step 1: Add Domain in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Hosting** → **Add custom domain**
4. Enter your domain (e.g., `mahadhikalogistik.com`)

### Step 2: Verify Domain Ownership

Firebase will provide a TXT record. Add it to your domain's DNS settings.

### Step 3: Update DNS Records

Add these records in your domain registrar:

**For root domain (mahadhikalogistik.com):**
```
Type: A
Name: @
Value: (provided by Firebase - usually multiple IPs)
```

**For www subdomain:**
```
Type: CNAME
Name: www
Value: your-project-id.web.app
```

### Step 4: Wait for SSL Certificate

Firebase automatically provisions a free SSL certificate (can take up to 24 hours).

---

## ⚙️ Environment Variables

Firebase Hosting doesn't support runtime environment variables. Your `.env` variables are **built into the app** during `npm run build`.

### For Production Environment Variables:

**Option 1: Build with production .env**

```bash
# Create .env.production
cp .env .env.production

# Edit .env.production with production values
# Then build
npm run build
```

**Option 2: Use Firebase Functions (for sensitive data)**

If you need server-side environment variables:

1. Enable Firebase Functions
2. Store secrets in Firebase Functions config
3. Create API endpoints in Functions
4. Call from your Vue app

---

## 🔒 Security Best Practices

### 1. Protect Environment Variables

```bash
# Never commit .env files
git rm .env --cached
git commit -m "Remove .env from tracking"
```

### 2. Use Firebase Security Rules

If using Firebase Realtime Database or Firestore:

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read: if true;
      allow write: if false;
    }
  }
}
```

### 3. Enable Firebase App Check (Optional)

Protects your backend resources from abuse:

```bash
firebase apps:sdkconfig web --app-id=your-app-id
```

---

## 📊 Multiple Environments

Deploy to different Firebase projects for staging/production:

### Setup Multiple Environments

```bash
# Add staging project
firebase use --add

# Select staging
firebase use staging
firebase deploy

# Select production
firebase use production
firebase deploy
```

### Create Aliases in .firebaserc

```json
{
  "projects": {
    "default": "mahadhika-logistik",
    "staging": "mahadhika-logistik-staging",
    "production": "mahadhika-logistik-prod"
  }
}
```

---

## 🎯 Deployment Scripts

Add these to your `package.json`:

```json
{
  "scripts": {
    "build": "vite build",
    "deploy:firebase": "npm run build && firebase deploy",
    "deploy:staging": "firebase use staging && npm run deploy:firebase",
    "deploy:prod": "firebase use production && npm run deploy:firebase"
  }
}
```

Usage:

```bash
npm run deploy:firebase    # Deploy to default
npm run deploy:staging     # Deploy to staging
npm run deploy:prod        # Deploy to production
```

---

## 📈 Analytics & Monitoring

### Enable Google Analytics

1. Go to Firebase Console
2. Project Settings → Integrations
3. Enable Google Analytics
4. Follow setup wizard

### View Hosting Metrics

1. Firebase Console → Hosting
2. View:
   - Request count
   - Bandwidth usage
   - Response times

---

## 🐛 Troubleshooting

### Error: "Firebase project not found"

```bash
# Check current project
firebase projects:list

# Set correct project
firebase use your-project-id
```

### Error: "Permission denied"

```bash
# Re-authenticate
firebase logout
firebase login
```

### Build Errors

```bash
# Clear cache
rm -rf dist node_modules
npm install
npm run build
```

### 404 on Refresh

Make sure `firebase.json` has the rewrite rule:

```json
{
  "hosting": {
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

### Deployment is Slow

Firebase compresses and optimizes files. First deploy is slower.

```bash
# Skip certain files if needed
firebase deploy --only hosting --except functions
```

---

## 🔄 Rollback to Previous Version

### Via Firebase Console

1. Go to Hosting → Release history
2. Click on previous version
3. Click "Rollback"

### Via CLI

```bash
# List releases
firebase hosting:channel:list

# Rollback (not directly supported, but you can redeploy)
# Check out previous git commit and deploy
git checkout HEAD~1
npm run build
firebase deploy
```

---

## 💰 Pricing

Firebase Hosting **Free Tier**:
- 10 GB storage
- 360 MB/day transfer
- Free SSL certificate
- Custom domain support

**Paid (Blaze Plan)**:
- $0.026/GB storage
- $0.15/GB transfer
- No daily limits

Most company profile websites stay within free tier limits.

---

## 📊 Performance Optimization

### 1. Enable Compression

Already configured in `firebase.json`:

```json
{
  "hosting": {
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

### 2. CDN is Automatic

Firebase Hosting uses Google's global CDN automatically.

### 3. Image Optimization

```bash
# Install image optimizer
npm install -D vite-plugin-imagemin

# Add to vite.config.js
import viteImagemin from 'vite-plugin-imagemin'

export default defineConfig({
  plugins: [
    vue(),
    viteImagemin({
      gifsicle: { optimizationLevel: 3 },
      mozjpeg: { quality: 80 },
      pngquant: { quality: [0.8, 0.9] },
      svgo: { plugins: [{ removeViewBox: false }] }
    })
  ]
})
```

---

## 🎯 CI/CD with GitHub Actions

Automate deployment on every push:

Create `.github/workflows/firebase-deploy.yml`:

```yaml
name: Deploy to Firebase Hosting

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build
        run: npm run build
        env:
          VITE_SUPABASE_URL: ${{ secrets.VITE_SUPABASE_URL }}
          VITE_SUPABASE_ANON_KEY: ${{ secrets.VITE_SUPABASE_ANON_KEY }}
          
      - name: Deploy to Firebase
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: ${{ secrets.GITHUB_TOKEN }}
          firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
          channelId: live
          projectId: your-project-id
```

---

## ✅ Pre-Deployment Checklist

- [ ] `.env` configured with production values
- [ ] `npm run build` successful
- [ ] All pages tested locally
- [ ] Firebase project created
- [ ] Firebase CLI installed
- [ ] Logged into Firebase CLI
- [ ] `.firebaserc` has correct project ID
- [ ] `firebase.json` configured
- [ ] Custom domain ready (optional)
- [ ] Analytics setup (optional)

---

## 📞 Support

### Firebase Resources

- [Firebase Hosting Docs](https://firebase.google.com/docs/hosting)
- [Firebase Console](https://console.firebase.google.com)
- [Firebase Status](https://status.firebase.google.com)
- [Community Forum](https://firebase.google.com/support)

### Common Commands

```bash
# Check Firebase CLI version
firebase --version

# List projects
firebase projects:list

# Check current project
firebase use

# View hosting details
firebase hosting:channel:list

# Open hosting in browser
firebase open hosting

# View logs
firebase hosting:channel:list --json
```

---

## 🎉 You're Ready!

Your Firebase deployment is configured and ready to go!

**Quick deploy command:**

```bash
npm run build && firebase deploy
```

Your site will be live at: `https://YOUR-PROJECT-ID.web.app`

---

**Happy deploying! 🚀**

