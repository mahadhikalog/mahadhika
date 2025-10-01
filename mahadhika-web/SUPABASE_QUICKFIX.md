# 🔧 Quick Fix: Contact Form Error

## Error Message
```
Could not find the table 'public.contacts' in the schema cache
```

## ❌ Problem
The `contacts` table hasn't been created in your Supabase database yet.

## ✅ Solution (5 minutes)

### Step 1: Open Supabase Dashboard

1. Go to [https://supabase.com](https://supabase.com)
2. Sign in with your account: `contact@mahadhika.com`
3. Select your project

### Step 2: Open SQL Editor

1. In the left sidebar, click **"SQL Editor"**
2. Click **"New query"** button

### Step 3: Copy the SQL

Open this file: `supabase/create-contacts-table.sql`

Or copy this SQL:

```sql
-- Create contacts table
CREATE TABLE IF NOT EXISTS contacts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  nama TEXT NOT NULL,
  email TEXT NOT NULL,
  telepon TEXT,
  perusahaan TEXT,
  pesan TEXT NOT NULL,
  status TEXT DEFAULT 'new' CHECK (status IN ('new', 'contacted', 'closed'))
);

-- Create indexes
CREATE INDEX IF NOT EXISTS contacts_created_at_idx ON contacts(created_at DESC);
CREATE INDEX IF NOT EXISTS contacts_status_idx ON contacts(status);
CREATE INDEX IF NOT EXISTS contacts_email_idx ON contacts(email);

-- Enable Row Level Security
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- Allow public to insert contacts (for contact form)
DROP POLICY IF EXISTS "Allow public to insert contacts" ON contacts;
CREATE POLICY "Allow public to insert contacts" ON contacts
  FOR INSERT TO anon
  WITH CHECK (true);

-- Allow authenticated users to read contacts
DROP POLICY IF EXISTS "Allow authenticated to read contacts" ON contacts;
CREATE POLICY "Allow authenticated to read contacts" ON contacts
  FOR SELECT TO authenticated
  USING (true);

-- Allow authenticated users to update contacts
DROP POLICY IF EXISTS "Allow authenticated to update contacts" ON contacts;
CREATE POLICY "Allow authenticated to update contacts" ON contacts
  FOR UPDATE TO authenticated
  USING (true)
  WITH CHECK (true);
```

### Step 4: Run the SQL

1. Paste the SQL into the query editor
2. Click **"Run"** button (or press Ctrl+Enter / Cmd+Enter)
3. Wait for success message: ✅ "Success. No rows returned"

### Step 5: Verify Table Was Created

1. In Supabase sidebar, click **"Table Editor"**
2. You should see **"contacts"** table in the list
3. Click on it to see the columns:
   - id
   - created_at
   - nama
   - email
   - telepon
   - perusahaan
   - pesan
   - status

### Step 6: Test the Contact Form

1. Go back to your website: [http://localhost:5173/kontak](http://localhost:5173/kontak)
2. Fill out the form
3. Click "Kirim Pesan"
4. You should see success message! ✅

### Step 7: Verify Data in Supabase

1. Go back to Supabase **Table Editor** → **contacts**
2. You should see your test submission!

---

## 🎉 Done!

Your contact form is now working!

---

## 🔍 What This Did

This SQL:
- ✅ Created the `contacts` table
- ✅ Set up proper column types
- ✅ Added indexes for performance
- ✅ Enabled Row Level Security (RLS)
- ✅ Created policies to:
  - Allow anyone to submit contact form (public insert)
  - Allow authenticated users to read/update submissions (admin access)

---

## 📝 Next Steps

After fixing:
1. Test the contact form multiple times
2. Check Supabase Table Editor to see submissions
3. Deploy to Firebase when ready

---

## 🆘 Still Having Issues?

### Error: "permission denied"
- Make sure RLS policies were created
- Check the SQL ran without errors

### Error: "relation does not exist"
- The SQL didn't run properly
- Try running it again
- Check for any error messages in SQL Editor

### Form still not working after creating table
1. Refresh your browser (Ctrl+Shift+R / Cmd+Shift+R)
2. Check browser console for errors (F12)
3. Verify `.env` has correct Supabase credentials:
   ```
   VITE_SUPABASE_URL=https://your-project.supabase.co
   VITE_SUPABASE_ANON_KEY=your-key
   ```

---

**Need more help?** Check `docs/SUPABASE_SETUP.md` for detailed documentation.

