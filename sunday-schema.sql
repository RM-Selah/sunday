-- ═══════════════════════════════════════════════════════════════
-- SUNDAY — Database Schema for Supabase (Postgres)
-- Run this in your Supabase SQL Editor to set up the backend
-- ═══════════════════════════════════════════════════════════════

-- Churches (multi-tenant support)
CREATE TABLE IF NOT EXISTS churches (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT UNIQUE,
  timezone TEXT DEFAULT 'Pacific/Auckland',
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- People — the heart of the contact database
CREATE TABLE IF NOT EXISTS people (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  church_id UUID REFERENCES churches(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  phone TEXT,                       -- E.164 format for WhatsApp (+64211234567)
  email TEXT,
  photo_url TEXT,
  roles TEXT[] DEFAULT '{}',        -- ['WL','Keys','FLV'] etc
  tier INTEGER DEFAULT 3,           -- 1=leader, 2=experienced, 3=developing
  notes TEXT,
  whatsapp_opted_in BOOLEAN DEFAULT false,
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_people_church ON people(church_id);
CREATE INDEX idx_people_phone ON people(phone);

-- Services — recurring (Sunday AM) and one-off (Easter Friday)
CREATE TABLE IF NOT EXISTS services (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  church_id UUID REFERENCES churches(id) ON DELETE CASCADE,
  slug TEXT NOT NULL,               -- 'sun-am', 'easter-friday'
  name TEXT NOT NULL,
  day TEXT,                         -- 'Sunday', 'Friday' etc
  time TEXT,                        -- '9:30am'
  date DATE,                        -- for one-off events
  recurring BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_services_church ON services(church_id);

-- Songs — the worship library
CREATE TABLE IF NOT EXISTS songs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  church_id UUID REFERENCES churches(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  artist TEXT,
  category TEXT DEFAULT 'current', -- praise, worship, homegrown, classic, current
  key TEXT,                        -- 'G', 'Bb', etc
  bpm INTEGER,
  tempo TEXT,                      -- 'fast', 'mid', 'slow'
  notes TEXT,
  last_used DATE,
  times_used INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_songs_church ON songs(church_id);

-- Availability — who's free when
CREATE TABLE IF NOT EXISTS availability (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  person_id UUID REFERENCES people(id) ON DELETE CASCADE,
  church_id UUID REFERENCES churches(id) ON DELETE CASCADE,
  month TEXT NOT NULL,              -- 'April 2026'
  available_weeks INTEGER[] DEFAULT '{1,2,3,4,5}',
  unavailable_events TEXT[],       -- ['easter-friday']
  notes TEXT,
  source TEXT DEFAULT 'manual',    -- 'manual', 'whatsapp', 'sunday-ai'
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX idx_avail_person_month ON availability(person_id, month);
CREATE INDEX idx_avail_church_month ON availability(church_id, month);

-- Roster assignments — who plays what, when
CREATE TABLE IF NOT EXISTS roster_assignments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  church_id UUID REFERENCES churches(id) ON DELETE CASCADE,
  service_id UUID REFERENCES services(id) ON DELETE CASCADE,
  person_id UUID REFERENCES people(id) ON DELETE CASCADE,
  month TEXT NOT NULL,              -- 'April 2026'
  week TEXT NOT NULL,               -- '1', '2', or 'evt-easter-friday'
  role TEXT NOT NULL,               -- 'WL', 'KEYS1', 'DRUMS' etc
  confirmed BOOLEAN DEFAULT false,
  confirmed_via TEXT,               -- 'whatsapp', 'app', null
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX idx_roster_unique ON roster_assignments(church_id, service_id, month, week, role);
CREATE INDEX idx_roster_person ON roster_assignments(person_id, month);

-- Set lists — saved worship sets
CREATE TABLE IF NOT EXISTS set_lists (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  church_id UUID REFERENCES churches(id) ON DELETE CASCADE,
  service_id UUID REFERENCES services(id),
  name TEXT,
  month TEXT,
  week TEXT,
  songs JSONB DEFAULT '[]',        -- ordered array of { song_id, title, key, notes }
  ministry_songs JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_sets_church ON set_lists(church_id);

-- WhatsApp conversations — message history for two-way chat
CREATE TABLE IF NOT EXISTS whatsapp_messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  church_id UUID REFERENCES churches(id) ON DELETE CASCADE,
  person_id UUID REFERENCES people(id) ON DELETE SET NULL,
  phone TEXT NOT NULL,
  direction TEXT NOT NULL,          -- 'inbound' or 'outbound'
  body TEXT NOT NULL,
  media_url TEXT,
  twilio_sid TEXT,
  intent TEXT,                      -- parsed by Sunday: 'confirm', 'decline', 'question', etc
  processed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_wa_church ON whatsapp_messages(church_id);
CREATE INDEX idx_wa_phone ON whatsapp_messages(phone);

-- Notifications log — what's been sent, what's pending
CREATE TABLE IF NOT EXISTS notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  church_id UUID REFERENCES churches(id) ON DELETE CASCADE,
  person_id UUID REFERENCES people(id) ON DELETE CASCADE,
  type TEXT NOT NULL,               -- 'roster_confirmation', 'availability_check', 'set_list_share', 'reminder'
  channel TEXT DEFAULT 'whatsapp',  -- 'whatsapp', 'email', 'sms'
  status TEXT DEFAULT 'pending',    -- 'pending', 'sent', 'delivered', 'read', 'failed'
  content TEXT,
  scheduled_for TIMESTAMPTZ,
  sent_at TIMESTAMPTZ,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_notif_church ON notifications(church_id);
CREATE INDEX idx_notif_status ON notifications(status);

-- ═══════════════════════════════════════════════════════════════
-- Row Level Security — each church only sees their own data
-- ═══════════════════════════════════════════════════════════════
ALTER TABLE churches ENABLE ROW LEVEL SECURITY;
ALTER TABLE people ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE songs ENABLE ROW LEVEL SECURITY;
ALTER TABLE availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE roster_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE set_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE whatsapp_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Policies: authenticated users can access their church's data
-- (You'll set church_id via auth.jwt() claims or a junction table)
-- For now, permissive policies for development:
CREATE POLICY "Allow all for authenticated" ON churches FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON people FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON services FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON songs FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON availability FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON roster_assignments FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON set_lists FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON whatsapp_messages FOR ALL USING (true);
CREATE POLICY "Allow all for authenticated" ON notifications FOR ALL USING (true);

-- ═══════════════════════════════════════════════════════════════
-- Helper functions
-- ═══════════════════════════════════════════════════════════════

-- Get person load for a month (how many times rostered)
CREATE OR REPLACE FUNCTION get_person_load(p_church_id UUID, p_month TEXT)
RETURNS TABLE(person_id UUID, person_name TEXT, load_count BIGINT) AS $$
  SELECT ra.person_id, p.name, COUNT(*) as load_count
  FROM roster_assignments ra
  JOIN people p ON p.id = ra.person_id
  WHERE ra.church_id = p_church_id AND ra.month = p_month
  GROUP BY ra.person_id, p.name
  ORDER BY load_count DESC;
$$ LANGUAGE sql;

-- Auto-update updated_at timestamps
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER people_updated BEFORE UPDATE ON people FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER roster_updated BEFORE UPDATE ON roster_assignments FOR EACH ROW EXECUTE FUNCTION update_timestamp();
CREATE TRIGGER sets_updated BEFORE UPDATE ON set_lists FOR EACH ROW EXECUTE FUNCTION update_timestamp();
