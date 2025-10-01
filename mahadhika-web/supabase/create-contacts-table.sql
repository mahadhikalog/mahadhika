-- Quick fix: Create contacts table for contact form
-- Run this in Supabase SQL Editor

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

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS contacts_created_at_idx ON contacts(created_at DESC);
CREATE INDEX IF NOT EXISTS contacts_status_idx ON contacts(status);
CREATE INDEX IF NOT EXISTS contacts_email_idx ON contacts(email);

-- Enable Row Level Security
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- Allow anyone to insert contacts (for the public contact form)
DROP POLICY IF EXISTS "Allow public to insert contacts" ON contacts;
CREATE POLICY "Allow public to insert contacts" ON contacts
  FOR INSERT TO anon
  WITH CHECK (true);

-- Allow authenticated users to read contacts (for admin dashboard in future)
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

