# 🚀 Mahadhika Logistik Indonesia - Setup Instructions

Welcome! This guide will help you set up the Mahadhika Logistik company profile website.

## 📦 What's Included

This is a complete, production-ready company profile website featuring:

- ✅ Modern, responsive design
- ✅ Vue.js 3 with Composition API (script setup)
- ✅ Supabase backend integration
- ✅ Contact form with database storage
- ✅ Beautiful UI with TailwindCSS
- ✅ SEO-friendly structure
- ✅ Mobile-first responsive design

## 🎯 Quick Start (5 Minutes)

### Step 1: Install Dependencies

```bash
npm install
```

### Step 2: Setup Supabase

1. Create account at [supabase.com](https://supabase.com)
2. Create new project (choose Singapore region)
3. Go to SQL Editor and run the schema from `supabase/schema.sql`
4. Get your credentials from Settings → API

### Step 3: Configure Environment

Create `.env` file:

```bash
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key-here
```

### Step 4: Run Development Server

```bash
npm run dev
```

Open http://localhost:5173 🎉

## 📖 Detailed Documentation

For more detailed guides, check:

- **[QUICK_START.md](./docs/QUICK_START.md)** - Step-by-step setup guide
- **[PRD.md](./docs/PRD.md)** - Complete product requirements
- **[SUPABASE_SETUP.md](./docs/SUPABASE_SETUP.md)** - Supabase configuration
- **[DEPLOYMENT.md](./docs/DEPLOYMENT.md)** - Deploy to production

## 🗂️ Project Structure

```
mahadhika-web/
├── public/                 # Static assets
│   └── logo.png           # Company logo
│
├── src/
│   ├── components/        # Reusable Vue components
│   │   ├── AppHeader.vue
│   │   ├── AppFooter.vue
│   │   ├── ServiceCard.vue
│   │   ├── ValueCard.vue
│   │   ├── TeamCard.vue
│   │   ├── SectorCard.vue
│   │   └── ContactForm.vue
│   │
│   ├── pages/            # Page components
│   │   ├── HomePage.vue
│   │   ├── AboutPage.vue
│   │   ├── ServicesPage.vue
│   │   ├── RoadmapPage.vue
│   │   └── ContactPage.vue
│   │
│   ├── router/           # Vue Router
│   │   └── index.js
│   │
│   ├── lib/             # Libraries & utilities
│   │   └── supabase.js
│   │
│   ├── styles/          # Global styles
│   │   └── main.css
│   │
│   ├── App.vue          # Root component
│   └── main.js          # App entry point
│
├── docs/                # Documentation
│   ├── PRD.md
│   ├── QUICK_START.md
│   ├── SUPABASE_SETUP.md
│   └── DEPLOYMENT.md
│
├── supabase/           # Database
│   └── schema.sql
│
├── package.json
├── vite.config.js
├── tailwind.config.js
└── README.md
```

## 🎨 Customization

### Content

All content is hardcoded in page components and follows the information from `reference.md`. To update:

1. Edit page components in `src/pages/`
2. Update data arrays in `<script setup>` sections
3. Modify JSX/template as needed

### Styling

Colors are based on your logo (Navy Blue & Red):

- **Primary (Navy)**: `primary-950` → #0a2847
- **Accent (Red)**: `accent-950` → #c41e3a

Update in `tailwind.config.js` if needed.

### Logo

Logo is located at `public/logo.png`. Replace with your own if needed.

## 🔧 Available Commands

```bash
# Development
npm run dev          # Start dev server (http://localhost:5173)

# Production
npm run build        # Build for production (output: dist/)
npm run preview      # Preview production build

# Deployment
vercel              # Deploy to Vercel (after installing vercel CLI)
netlify deploy      # Deploy to Netlify (after installing netlify CLI)
```

## 🌐 Pages Overview

### 1. Homepage (`/`)
- Hero section with tagline
- About summary
- Services showcase
- Company values
- Industry sectors
- CTA sections

### 2. About Page (`/tentang`)
- Company profile
- Vision & Mission
- Company values
- Team founders
- Our advantages

### 3. Services Page (`/layanan`)
- 4 main services detail
- Industry sectors served
- Features & benefits

### 4. Roadmap Page (`/roadmap`)
- Company growth timeline
- 4 phases (Year 0-1, 1-3, 3-5, 5+)
- Vision statement

### 5. Contact Page (`/kontak`)
- Contact information
- Contact form (Supabase-integrated)
- Google Maps location
- Office hours

## 🗄️ Database Schema

The contact form uses Supabase with this schema:

```sql
contacts (
  id: UUID,
  created_at: TIMESTAMP,
  nama: TEXT,
  email: TEXT,
  telepon: TEXT,
  perusahaan: TEXT,
  pesan: TEXT,
  status: TEXT
)
```

All submissions are stored in Supabase for you to manage.

## 📱 Features

- ✅ Fully responsive (mobile, tablet, desktop)
- ✅ Modern UI/UX design
- ✅ Fast performance (Vite + Vue 3)
- ✅ SEO optimized
- ✅ Form validation
- ✅ Loading states
- ✅ Error handling
- ✅ Smooth animations
- ✅ Accessible (WCAG compliant)

## 🚀 Deployment

### Quick Deploy to Vercel (Recommended)

1. Push code to GitHub
2. Go to [vercel.com](https://vercel.com)
3. Import repository
4. Add environment variables
5. Deploy!

See [DEPLOYMENT.md](./docs/DEPLOYMENT.md) for detailed instructions.

## 🔐 Environment Variables

Required environment variables:

```bash
VITE_SUPABASE_URL=        # Your Supabase project URL
VITE_SUPABASE_ANON_KEY=   # Your Supabase anon/public key
```

> ⚠️ Never commit `.env` to Git! It's already in `.gitignore`

## 📋 Coding Standards

Following your preferences:

- **Functions**: `camelCase`
- **Variables**: `snake_case`
- **Components**: `PascalCase`
- **Database columns**: `snake_case`

## ✅ Pre-Launch Checklist

Before going live:

- [ ] Install dependencies (`npm install`)
- [ ] Create Supabase project
- [ ] Run database schema
- [ ] Configure `.env` file
- [ ] Test contact form
- [ ] Review all pages
- [ ] Check mobile responsiveness
- [ ] Test on different browsers
- [ ] Add custom domain (optional)
- [ ] Enable SSL/HTTPS
- [ ] Submit to search engines

## 🐛 Troubleshooting

### "Module not found" errors
```bash
rm -rf node_modules package-lock.json
npm install
```

### Supabase connection issues
1. Check `.env` file exists
2. Verify credentials are correct
3. Restart dev server

### Build errors
```bash
npm run build -- --debug
```

### Contact form not working
1. Check browser console
2. Verify Supabase RLS policies
3. Check network tab in DevTools

## 📞 Support

For issues or questions:
1. Check documentation in `docs/` folder
2. Review component code
3. Check Supabase logs
4. Contact development team

## 🎉 You're All Set!

Your website is ready to launch. Enjoy building with Vue + Supabase! 

---

**Made with ❤️ for Mahadhika Logistik Indonesia**

