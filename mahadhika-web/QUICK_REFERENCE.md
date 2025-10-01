# ⚡ Quick Reference Card

## 🚀 Get Started in 3 Steps

### 1️⃣ Install
```bash
cd mahadhika-web
npm install
```

### 2️⃣ Configure Supabase
Create `.env` file:
```bash
VITE_SUPABASE_URL=https://xxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=xxxxx
```

### 3️⃣ Run
```bash
npm run dev
```

Open: **http://localhost:5173**

---

## 📁 File Locations

| What | Where |
|------|-------|
| **Pages** | `src/pages/*.vue` |
| **Components** | `src/components/*.vue` |
| **Styles** | `src/styles/main.css` |
| **Logo** | `public/logo.png` |
| **Database** | `supabase/schema.sql` |
| **Docs** | `docs/*.md` |

---

## 🎨 Update Content

### Homepage
Edit: `src/pages/HomePage.vue`
- Hero text
- Services list
- Values
- Sectors

### About Page
Edit: `src/pages/AboutPage.vue`
- Vision/Mission
- Team members
- Company values

### Services
Edit: `src/pages/ServicesPage.vue`
- Service details
- Industry sectors

### Contact
Edit: `src/pages/ContactPage.vue`
- Contact info
- Office hours

---

## 🎨 Change Colors

Edit: `tailwind.config.js`

```javascript
colors: {
  primary: {
    950: '#0a2847',  // Navy blue
  },
  accent: {
    950: '#c41e3a',  // Red
  }
}
```

---

## 🗄️ Database Setup

### Create Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. New Project → Singapore region
3. SQL Editor → Paste from `supabase/schema.sql`
4. Run query

### Get Credentials
Settings → API
- Copy URL
- Copy anon/public key

---

## 📝 Common Commands

```bash
# Development
npm run dev              # Start dev server

# Production
npm run build            # Build for production
npm run preview          # Preview build

# Deploy
vercel                   # Deploy to Vercel
netlify deploy --prod    # Deploy to Netlify
```

---

## 🔍 Project Stats

- **Pages**: 5 (Home, About, Services, Roadmap, Contact)
- **Components**: 7 reusable components
- **Lines of Code**: ~2,000+
- **Documentation**: 4 comprehensive guides
- **Ready to Deploy**: ✅ Yes!

---

## 📞 Quick Help

### Issue: Port in use
```bash
lsof -ti:5173 | xargs kill
npm run dev
```

### Issue: Supabase not working
1. Check `.env` exists
2. Verify credentials
3. Restart dev server

### Issue: Build fails
```bash
rm -rf node_modules
npm install
npm run build
```

---

## 🚀 Deploy Checklist

- [ ] `npm install` completed
- [ ] Supabase project created
- [ ] Database schema applied
- [ ] `.env` configured
- [ ] Test contact form works
- [ ] All pages load correctly
- [ ] Mobile responsive checked
- [ ] `npm run build` successful
- [ ] Deploy to Vercel/Netlify
- [ ] Custom domain configured (optional)

---

## 📚 Full Documentation

- **[SETUP.md](./SETUP.md)** - Complete setup guide
- **[docs/QUICK_START.md](./docs/QUICK_START.md)** - Quick start
- **[docs/PRD.md](./docs/PRD.md)** - Product requirements
- **[docs/SUPABASE_SETUP.md](./docs/SUPABASE_SETUP.md)** - Database guide
- **[docs/DEPLOYMENT.md](./docs/DEPLOYMENT.md)** - Deploy guide

---

## 🎯 Support

Need help? Check:
1. Documentation in `docs/` folder
2. Component code for examples
3. Browser console for errors
4. Supabase dashboard logs

---

**Made with ❤️ for Mahadhika Logistik Indonesia**

