# Deployment Guide

## Prerequisites

- Node.js 18+ installed
- npm or yarn
- Git
- Supabase account with configured project
- Vercel/Netlify account (for hosting)

## Environment Setup

### 1. Local Development

```bash
# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Add your Supabase credentials to .env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key

# Run development server
npm run dev
```

### 2. Build for Production

```bash
# Build the project
npm run build

# Preview production build locally
npm run preview
```

## Deployment Options

### Option 1: Vercel (Recommended)

#### A. Using Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Login to Vercel
vercel login

# Deploy
vercel

# Deploy to production
vercel --prod
```

#### B. Using Vercel Dashboard

1. Go to [vercel.com](https://vercel.com)
2. Click "Add New Project"
3. Import your Git repository
4. Configure:
   - **Framework Preset**: Vite
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
5. Add Environment Variables:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
6. Click "Deploy"

#### Custom Domain Setup (Vercel)

1. Go to your project settings
2. Navigate to "Domains"
3. Add your custom domain
4. Update DNS records as instructed

### Option 2: Netlify

#### A. Using Netlify CLI

```bash
# Install Netlify CLI
npm i -g netlify-cli

# Login to Netlify
netlify login

# Initialize
netlify init

# Deploy
netlify deploy

# Deploy to production
netlify deploy --prod
```

#### B. Using Netlify Dashboard

1. Go to [netlify.com](https://netlify.com)
2. Click "Add new site" > "Import an existing project"
3. Connect your Git repository
4. Configure:
   - **Build command**: `npm run build`
   - **Publish directory**: `dist`
5. Add Environment Variables:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
6. Click "Deploy site"

#### Custom Domain Setup (Netlify)

1. Go to Site settings > Domain management
2. Add custom domain
3. Update DNS records

### Option 3: GitHub Pages

```bash
# Install gh-pages
npm i -D gh-pages

# Add to package.json scripts:
# "deploy": "npm run build && gh-pages -d dist"

# Deploy
npm run deploy
```

Update `vite.config.js`:
```javascript
export default defineConfig({
  base: '/your-repo-name/',
  // ... rest of config
})
```

## Environment Variables

Set these environment variables in your hosting platform:

```bash
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

## Post-Deployment Checklist

### 1. DNS Configuration

- [ ] Update A/CNAME records to point to hosting
- [ ] Enable HTTPS/SSL
- [ ] Wait for DNS propagation (can take up to 48 hours)

### 2. SEO Setup

- [ ] Submit sitemap to Google Search Console
- [ ] Verify domain ownership
- [ ] Add robots.txt
- [ ] Configure meta tags
- [ ] Add Google Analytics (optional)

### 3. Performance Optimization

- [ ] Enable CDN
- [ ] Configure caching headers
- [ ] Optimize images (WebP format)
- [ ] Enable compression (Gzip/Brotli)

### 4. Security

- [ ] Enable HTTPS redirect
- [ ] Configure security headers
- [ ] Set up CORS if needed
- [ ] Enable rate limiting (Supabase)

### 5. Monitoring

- [ ] Set up error tracking (Sentry, LogRocket)
- [ ] Configure uptime monitoring
- [ ] Set up analytics
- [ ] Monitor Supabase usage

## Custom Domain Configuration

### 1. DNS Records (Example for Vercel)

Add these DNS records in your domain registrar:

```
Type  Name  Value
A     @     76.76.21.21
CNAME www   cname.vercel-dns.com
```

### 2. SSL Certificate

- Automatic with Vercel/Netlify
- Certificate auto-renews via Let's Encrypt

## CI/CD Setup (Optional)

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

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
          
      - name: Deploy to Vercel
        run: vercel --prod --token=${{ secrets.VERCEL_TOKEN }}
```

## Troubleshooting

### Build Errors

```bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install

# Check Node version
node -v  # Should be 18+
```

### Environment Variables Not Working

- Ensure variables start with `VITE_`
- Restart dev server after changing .env
- Check environment variables are set in hosting platform

### 404 Errors on Refresh

For SPA routing, add redirect rules:

**Vercel** (`vercel.json`):
```json
{
  "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }]
}
```

**Netlify** (`netlify.toml`):
```toml
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### Performance Issues

- Enable CDN
- Optimize images
- Lazy load components
- Use code splitting

## Maintenance

### Regular Updates

```bash
# Update dependencies
npm update

# Check for security vulnerabilities
npm audit

# Fix vulnerabilities
npm audit fix
```

### Backup

- Database: Supabase auto-backups (check settings)
- Code: Git version control
- Assets: Store in Supabase Storage with backups

### Monitoring Checklist

- [ ] Check website uptime weekly
- [ ] Monitor Supabase usage monthly
- [ ] Review analytics monthly
- [ ] Update dependencies monthly
- [ ] Security audit quarterly

## Support

For issues:
1. Check GitHub Issues
2. Review documentation
3. Contact development team
4. Check hosting platform status

## Rollback Procedure

If deployment fails:

**Vercel:**
1. Go to Deployments
2. Find previous working deployment
3. Click "Promote to Production"

**Netlify:**
1. Go to Deploys
2. Find previous working deploy
3. Click "Publish deploy"

## Next Steps

- [ ] Set up custom domain
- [ ] Configure email forwarding
- [ ] Set up Google Analytics
- [ ] Add sitemap.xml
- [ ] Configure social media meta tags
- [ ] Set up contact form notifications

