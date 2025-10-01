# 🔥 Firebase Deployment - Quick Start

Get your website live on Firebase Hosting in 10 minutes!

---

## ✅ Prerequisites Checklist

- [x] `.env` file configured (already done!)
- [ ] Firebase account created
- [ ] Firebase CLI installed
- [ ] Project built successfully

---

## 🚀 Step-by-Step Deployment

### Step 1: Install Firebase CLI (2 minutes)

```bash
npm install -g firebase-tools
```

Verify installation:
```bash
firebase --version
```

### Step 2: Login to Firebase (1 minute)

```bash
firebase login
```

This opens your browser to authenticate with Google.

### Step 3: Create Firebase Project (2 minutes)

**Option A: Via Web Console (Easier)**

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **"Add project"**
3. Name: `mahadhika-logistik`
4. Disable Analytics (or enable if you want)
5. Click **"Create project"**
6. **Copy your Project ID** (shown in project settings)

**Option B: Via CLI**

```bash
firebase projects:create mahadhika-logistik
```

### Step 4: Update Firebase Project ID (1 minute)

Edit `.firebaserc` file and replace `your-firebase-project-id`:

```json
{
  "projects": {
    "default": "mahadhika-logistik"
  }
}
```

### Step 5: Build Your Project (1 minute)

```bash
npm run build
```

You should see: `✓ built in XXXms`

### Step 6: Deploy! (3 minutes)

```bash
firebase deploy
```

Wait for deployment to complete. You'll see:

```
✔  Deploy complete!

Hosting URL: https://mahadhika-logistik.web.app
```

**🎉 Your site is now LIVE!**

---

## 🔄 Future Deployments

After the first setup, deploying is super easy:

```bash
npm run deploy:firebase
```

This command:
1. Builds your project (`npm run build`)
2. Deploys to Firebase (`firebase deploy`)

---

## 🌐 Custom Domain (Optional)

### Add Your Own Domain

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. **Hosting** → **Add custom domain**
4. Enter domain: `mahadhikalogistik.com`
5. Follow DNS setup instructions
6. Firebase provides free SSL certificate!

Example DNS setup:
```
Type: A
Name: @
Value: 151.101.1.195 (and other IPs provided by Firebase)

Type: CNAME  
Name: www
Value: mahadhika-logistik.web.app
```

SSL certificate is automatic (takes ~24 hours).

---

## 📊 What You Get with Firebase

- ✅ **Free SSL certificate** (HTTPS)
- ✅ **Global CDN** (fast worldwide)
- ✅ **99.95% uptime SLA**
- ✅ **Automatic compression**
- ✅ **DDoS protection**
- ✅ **Free tier** (10GB storage + 360MB/day transfer)
- ✅ **Rollback support**
- ✅ **Preview channels** for testing

---

## 🛠️ Useful Commands

```bash
# Deploy to Firebase
npm run deploy:firebase

# Deploy only hosting (faster)
npm run deploy:hosting

# Check which project you're using
firebase use

# List all your Firebase projects
firebase projects:list

# Open Firebase console
firebase open

# View deployment history
firebase hosting:channel:list

# Test locally before deploying
npm run preview
```

---

## 🔍 Verify Deployment

After deploying, check:

1. **Visit your URL**: `https://YOUR-PROJECT-ID.web.app`
2. **Test all pages**:
   - Homepage (/)
   - About (/tentang)
   - Services (/layanan)
   - Roadmap (/roadmap)
   - Contact (/kontak)
3. **Test contact form**: Submit a message
4. **Check mobile**: Test on phone
5. **Check Supabase**: Verify form submissions appear

---

## ⚠️ Common Issues & Solutions

### Issue: "Firebase project not found"

```bash
# Check current project
firebase use

# Set correct project
firebase use mahadhika-logistik
```

### Issue: "Permission denied"

```bash
firebase logout
firebase login
```

### Issue: "404 on page refresh"

✅ Already fixed in `firebase.json` with rewrite rules!

### Issue: ".env variables not working"

Make sure they start with `VITE_` prefix:
```bash
VITE_SUPABASE_URL=...
VITE_SUPABASE_ANON_KEY=...
```

✅ Already fixed for you!

---

## 🔐 Security Checklist

- [x] `.env` file in `.gitignore` (already done!)
- [x] Firebase rewrite rules for SPA (already done!)
- [x] HTTPS enabled automatically
- [ ] Review Firebase security rules if using Firestore
- [ ] Enable Firebase App Check (optional, advanced)

---

## 💰 Pricing

**Free Tier (Spark Plan):**
- 10 GB storage
- 360 MB/day bandwidth
- Free SSL certificate
- Custom domains

**Your website will likely stay in free tier!** 🎉

If you need more:
- **Blaze Plan** (Pay as you go)
- Only pay for what you use above free tier
- ~$1-5/month for most company websites

---

## 📈 Next Steps

After deployment:

1. **Add to Google Search Console**
   - Verify ownership
   - Submit sitemap
   - Monitor search performance

2. **Setup Google Analytics** (optional)
   - Firebase Console → Analytics
   - Get insights on visitors

3. **Monitor Performance**
   - Firebase Console → Hosting
   - View bandwidth & requests

4. **Setup Preview Channels** (optional)
   - Test changes before going live
   - `firebase hosting:channel:deploy preview`

---

## 📞 Support

- **Detailed Guide**: See `docs/FIREBASE_DEPLOYMENT.md`
- **Firebase Docs**: [firebase.google.com/docs/hosting](https://firebase.google.com/docs/hosting)
- **Firebase Status**: [status.firebase.google.com](https://status.firebase.google.com)

---

## ✅ Quick Deployment Checklist

- [ ] Firebase CLI installed (`npm install -g firebase-tools`)
- [ ] Logged into Firebase (`firebase login`)
- [ ] Firebase project created
- [ ] Updated `.firebaserc` with project ID
- [ ] Built project (`npm run build`)
- [ ] Deployed (`firebase deploy`)
- [ ] Tested live site
- [ ] Custom domain setup (optional)

---

## 🎯 Summary

**Your Firebase deployment is ready!**

**Quick deploy command:**
```bash
npm run deploy:firebase
```

**Your site will be at:**
```
https://YOUR-PROJECT-ID.web.app
```

**Time to deploy:** ~10 minutes first time, ~2 minutes after that

---

**Happy deploying! 🚀**

For detailed documentation, see: `docs/FIREBASE_DEPLOYMENT.md`

