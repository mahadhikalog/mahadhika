-- Mahadhika Logistik Indonesia Database Schema
-- Created: 2025-10-01

-- =====================================================
-- CONTACTS TABLE
-- Stores contact form submissions
-- =====================================================

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

-- RLS Policies for contacts table
DROP POLICY IF EXISTS "Allow public to insert contacts" ON contacts;
CREATE POLICY "Allow public to insert contacts" ON contacts
  FOR INSERT TO anon
  WITH CHECK (true);

DROP POLICY IF EXISTS "Allow authenticated to read contacts" ON contacts;
CREATE POLICY "Allow authenticated to read contacts" ON contacts
  FOR SELECT TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Allow authenticated to update contacts" ON contacts;
CREATE POLICY "Allow authenticated to update contacts" ON contacts
  FOR UPDATE TO authenticated
  USING (true)
  WITH CHECK (true);

-- =====================================================
-- SERVICES TABLE (Optional - for dynamic content)
-- Stores service information
-- =====================================================

CREATE TABLE IF NOT EXISTS services (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  icon TEXT,
  features JSONB DEFAULT '[]'::jsonb,
  order_num INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true
);

-- Create index
CREATE INDEX IF NOT EXISTS services_active_order_idx ON services(active, order_num);

-- Enable Row Level Security
ALTER TABLE services ENABLE ROW LEVEL SECURITY;

-- RLS Policies for services table
DROP POLICY IF EXISTS "Allow public to read active services" ON services;
CREATE POLICY "Allow public to read active services" ON services
  FOR SELECT TO anon
  USING (active = true);

DROP POLICY IF EXISTS "Allow authenticated to manage services" ON services;
CREATE POLICY "Allow authenticated to manage services" ON services
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);

-- =====================================================
-- TEAM MEMBERS TABLE (Optional - for dynamic content)
-- Stores team member information
-- =====================================================

CREATE TABLE IF NOT EXISTS team_members (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  name TEXT NOT NULL,
  position TEXT NOT NULL,
  role TEXT,
  photo_url TEXT,
  order_num INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true
);

-- Create index
CREATE INDEX IF NOT EXISTS team_members_active_order_idx ON team_members(active, order_num);

-- Enable Row Level Security
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;

-- RLS Policies for team_members table
DROP POLICY IF EXISTS "Allow public to read active team members" ON team_members;
CREATE POLICY "Allow public to read active team members" ON team_members
  FOR SELECT TO anon
  USING (active = true);

DROP POLICY IF EXISTS "Allow authenticated to manage team members" ON team_members;
CREATE POLICY "Allow authenticated to manage team members" ON team_members
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);

-- =====================================================
-- SECTORS TABLE (Optional - for dynamic content)
-- Stores industry sector information
-- =====================================================

CREATE TABLE IF NOT EXISTS sectors (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  icon TEXT,
  order_num INTEGER DEFAULT 0,
  active BOOLEAN DEFAULT true
);

-- Create index
CREATE INDEX IF NOT EXISTS sectors_active_order_idx ON sectors(active, order_num);

-- Enable Row Level Security
ALTER TABLE sectors ENABLE ROW LEVEL SECURITY;

-- RLS Policies for sectors table
DROP POLICY IF EXISTS "Allow public to read active sectors" ON sectors;
CREATE POLICY "Allow public to read active sectors" ON sectors
  FOR SELECT TO anon
  USING (active = true);

DROP POLICY IF EXISTS "Allow authenticated to manage sectors" ON sectors;
CREATE POLICY "Allow authenticated to manage sectors" ON sectors
  FOR ALL TO authenticated
  USING (true)
  WITH CHECK (true);

-- =====================================================
-- FUNCTIONS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = timezone('utc'::text, now());
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
DROP TRIGGER IF EXISTS update_services_updated_at ON services;
CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_team_members_updated_at ON team_members;
CREATE TRIGGER update_team_members_updated_at BEFORE UPDATE ON team_members
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_sectors_updated_at ON sectors;
CREATE TRIGGER update_sectors_updated_at BEFORE UPDATE ON sectors
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- SEED DATA (Optional)
-- =====================================================

-- Insert default team members
-- INSERT INTO team_members (name, position, role, order_num) VALUES
--   ('M. Faza Alrasyid', 'Direktur Eksekusi & Kemitraan', 'Direktur Eksekusi & Kemitraan', 1),
--   ('Tareq Busnia', 'Direktur Utama', 'Strategi & Inovasi Bisnis', 2),
--   ('Eri Anshori Nurhadi', 'Komisaris', 'Digitalisasi & Teknologi', 3),
--   ('Sos Hendra', 'Komisaris Utama', 'Relasi Eksekutif & Strategis', 4);

