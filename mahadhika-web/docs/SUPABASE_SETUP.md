# Supabase Setup Guide

## 1. Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign in or create an account
3. Click "New Project"
4. Fill in project details:
   - **Name**: mahadhika-logistik
   - **Database Password**: Choose a strong password
   - **Region**: Southeast Asia (Singapore) - recommended for Indonesia
   - **Pricing Plan**: Free tier is sufficient to start

## 2. Database Setup

### Create Tables

Go to SQL Editor in Supabase Dashboard and run the following SQL:

```sql
-- Create contacts table
CREATE TABLE contacts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  nama TEXT NOT NULL,
  email TEXT NOT NULL,
  telepon TEXT,
  perusahaan TEXT,
  pesan TEXT NOT NULL,
  status TEXT DEFAULT 'new' CHECK (status IN ('new', 'contacted', 'closed'))
);

-- Create index for faster queries
CREATE INDEX contacts_created_at_idx ON contacts(created_at DESC);
CREATE INDEX contacts_status_idx ON contacts(status);

-- Enable Row Level Security (RLS)
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- Create policy to allow public inserts (for contact form)
CREATE POLICY "Allow public to insert contacts" ON contacts
  FOR INSERT TO anon
  WITH CHECK (true);

-- Create policy to allow authenticated users to read all contacts (for admin dashboard)
CREATE POLICY "Allow authenticated to read contacts" ON contacts
  FOR SELECT TO authenticated
  USING (true);
```

### Optional: Create services table (for dynamic content)

```sql
CREATE TABLE services (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  icon TEXT,
  order_num INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true
);

ALTER TABLE services ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public to read active services" ON services
  FOR SELECT TO anon
  USING (active = true);

CREATE POLICY "Allow authenticated to manage services" ON services
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);
```

### Optional: Create team_members table

```sql
CREATE TABLE team_members (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  name TEXT NOT NULL,
  position TEXT NOT NULL,
  role TEXT,
  photo_url TEXT,
  order_num INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true
);

ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public to read active team members" ON team_members
  FOR SELECT TO anon
  USING (active = true);

CREATE POLICY "Allow authenticated to manage team members" ON team_members
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);
```

## 3. Get API Credentials

1. Go to **Project Settings** > **API**
2. Copy the following:
   - **Project URL**: This is your `VITE_SUPABASE_URL`
   - **anon/public key**: This is your `VITE_SUPABASE_ANON_KEY`

## 4. Configure Environment Variables

1. In your project root, create a `.env` file:

```bash
VITE_SUPABASE_URL=your_project_url_here
VITE_SUPABASE_ANON_KEY=your_anon_key_here
```

2. Replace the values with your actual Supabase credentials

## 5. Email Notifications (Optional)

To receive email notifications when someone submits the contact form:

### Option 1: Using Supabase Database Webhooks

1. Go to **Database** > **Webhooks**
2. Create a new webhook for the `contacts` table
3. Set it to trigger on INSERT
4. Configure your email service endpoint

### Option 2: Using Supabase Edge Functions

Create an Edge Function to send emails:

```typescript
// supabase/functions/send-contact-email/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  const { record } = await req.json()
  
  // Send email using your preferred email service
  // Example: SendGrid, Resend, etc.
  
  return new Response(
    JSON.stringify({ success: true }),
    { headers: { "Content-Type": "application/json" } }
  )
})
```

## 6. Storage Setup (Optional)

If you need to store images (team photos, etc.):

1. Go to **Storage** in Supabase Dashboard
2. Create a new bucket named `public-assets`
3. Set the bucket to **Public**
4. Create policies:

```sql
-- Allow public to read files
CREATE POLICY "Allow public to read files" ON storage.objects
  FOR SELECT TO public
  USING (bucket_id = 'public-assets');

-- Allow authenticated to upload files
CREATE POLICY "Allow authenticated to upload files" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'public-assets');
```

## 7. Testing

Test your Supabase connection:

1. Start your dev server: `npm run dev`
2. Navigate to the Contact page
3. Submit a test form
4. Check the `contacts` table in Supabase Dashboard

## 8. Security Best Practices

- ✅ Keep your `.env` file private (already in `.gitignore`)
- ✅ Never commit API keys to version control
- ✅ Use Row Level Security (RLS) for all tables
- ✅ Implement rate limiting for public endpoints
- ✅ Validate input on both client and server side

## 9. Monitoring

Monitor your Supabase usage:

1. Go to **Settings** > **Usage**
2. Check:
   - Database size
   - API requests
   - Storage usage
   - Bandwidth

Free tier limits:
- 500 MB database
- 1 GB file storage
- 2 GB bandwidth
- 50,000 monthly active users

## Troubleshooting

### Connection Issues

If you can't connect to Supabase:

1. Check your `.env` file has correct values
2. Restart your dev server
3. Check Supabase project status

### Form Submission Errors

If form submission fails:

1. Check browser console for errors
2. Verify RLS policies are set correctly
3. Check Supabase logs in Dashboard

### CORS Errors

Add your domain to allowed origins in Supabase:

1. Go to **Settings** > **API**
2. Add your domain to **Additional URLs**

## Next Steps

- [ ] Set up email notifications
- [ ] Create admin dashboard (future feature)
- [ ] Implement analytics
- [ ] Add more tables as needed

