# Quick Start Guide

Get the Mahadhika Logistik website up and running in minutes!

## 📋 Prerequisites

- **Node.js** 18 or higher ([Download](https://nodejs.org))
- **npm** (comes with Node.js)
- **Supabase account** ([Sign up](https://supabase.com))
- **Code editor** (VS Code recommended)

## 🚀 Step-by-Step Setup

### 1. Install Dependencies

```bash
cd mahadhika-web
npm install
```

This will install all required packages including:
- Vue 3
- Vue Router
- Pinia
- TailwindCSS
- Supabase client

### 2. Setup Supabase

#### A. Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Create new project
3. Choose **Southeast Asia (Singapore)** region
4. Wait for project to be ready (~2 minutes)

#### B. Run Database Schema

1. Go to **SQL Editor** in Supabase Dashboard
2. Copy content from `supabase/schema.sql`
3. Click "Run"

#### C. Get API Credentials

1. Go to **Settings** → **API**
2. Copy:
   - Project URL
   - anon/public key

### 3. Configure Environment

Create `.env` file in project root:

```bash
VITE_SUPABASE_URL=your_project_url_here
VITE_SUPABASE_ANON_KEY=your_anon_key_here
```

> **Note:** Replace with your actual Supabase credentials from step 2C

### 4. Add Logo

Copy your logo to the public folder:

```bash
cp "../LOGO MLI PNG.png" public/logo.png
```

Or manually copy `LOGO MLI PNG.png` to `mahadhika-web/public/logo.png`

### 5. Run Development Server

```bash
npm run dev
```

Open your browser to: **http://localhost:5173**

## 🎨 What You'll See

The website includes:

- ✅ **Homepage** - Hero section with company intro
- ✅ **About Page** - Vision, mission, team, values
- ✅ **Services Page** - Service offerings & industries
- ✅ **Roadmap Page** - Company growth timeline
- ✅ **Contact Page** - Contact form with Supabase integration

## 🧪 Test Contact Form

1. Navigate to **Contact** page (http://localhost:5173/kontak)
2. Fill out the form
3. Click "Kirim Pesan"
4. Check Supabase Dashboard → **Table Editor** → **contacts**
5. Your submission should appear there

## 📝 Customization

### Update Content

All content is in the page components:
- `src/pages/HomePage.vue`
- `src/pages/AboutPage.vue`
- `src/pages/ServicesPage.vue`
- `src/pages/RoadmapPage.vue`
- `src/pages/ContactPage.vue`

### Update Colors

Colors are defined in `tailwind.config.js`:

```javascript
colors: {
  primary: { /* Navy blue shades */ },
  accent: { /* Red shades */ }
}
```

### Add New Pages

1. Create new file in `src/pages/`
2. Add route in `src/router/index.js`
3. Add link in `src/components/AppHeader.vue`

## 🌐 Deploy to Production

### Quick Deploy with Vercel

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Or one-click deploy: Import from GitHub
```

See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed instructions.

## 📚 Project Structure

```
mahadhika-web/
├── public/              # Static files
│   └── logo.png        # Company logo
├── src/
│   ├── assets/         # Images, fonts
│   ├── components/     # Reusable components
│   │   ├── AppHeader.vue
│   │   ├── AppFooter.vue
│   │   ├── ServiceCard.vue
│   │   ├── ValueCard.vue
│   │   ├── TeamCard.vue
│   │   ├── SectorCard.vue
│   │   └── ContactForm.vue
│   ├── pages/          # Page components
│   │   ├── HomePage.vue
│   │   ├── AboutPage.vue
│   │   ├── ServicesPage.vue
│   │   ├── RoadmapPage.vue
│   │   └── ContactPage.vue
│   ├── router/         # Vue Router config
│   ├── lib/           # Supabase client
│   ├── styles/        # Global styles
│   ├── App.vue        # Root component
│   └── main.js        # Entry point
├── docs/              # Documentation
├── supabase/          # Database schema
└── package.json
```

## 🔧 Common Commands

```bash
# Development
npm run dev          # Start dev server

# Production
npm run build        # Build for production
npm run preview      # Preview production build

# Deployment
vercel              # Deploy to Vercel
netlify deploy      # Deploy to Netlify
```

## ❓ Troubleshooting

### Port Already in Use

```bash
# Kill process on port 5173
lsof -ti:5173 | xargs kill

# Or run on different port
npm run dev -- --port 3000
```

### Supabase Connection Error

1. Check `.env` file exists
2. Verify credentials are correct
3. Restart dev server: `Ctrl+C` then `npm run dev`

### Form Not Submitting

1. Check browser console for errors
2. Verify Supabase RLS policies are set
3. Check network tab in DevTools

### Build Errors

```bash
# Clear cache
rm -rf node_modules package-lock.json
npm install

# Try building again
npm run build
```

## 📖 Documentation

- [PRD.md](./PRD.md) - Product Requirements
- [SUPABASE_SETUP.md](./SUPABASE_SETUP.md) - Detailed Supabase guide
- [DEPLOYMENT.md](./DEPLOYMENT.md) - Deployment instructions

## 🆘 Get Help

- Check documentation in `docs/` folder
- Review component code for examples
- Open GitHub issue for bugs
- Contact development team

## ✅ Checklist

Before going live:

- [ ] Supabase project created and configured
- [ ] Database schema applied
- [ ] Environment variables set
- [ ] Logo added to public folder
- [ ] Contact form tested
- [ ] All pages reviewed
- [ ] Responsive design checked
- [ ] SEO meta tags added
- [ ] Production build tested
- [ ] Domain configured
- [ ] SSL certificate active

## 🎉 You're Done!

Your Mahadhika Logistik website is ready! 

Next steps:
1. Customize content to match your needs
2. Add your own images
3. Deploy to production
4. Share with the world!

---

**Happy coding! 🚀**

