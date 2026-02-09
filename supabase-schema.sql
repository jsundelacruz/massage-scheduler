-- Run this SQL in your Supabase Dashboard: SQL Editor > New Query
-- https://supabase.com/dashboard/project/_/sql

-- 1. Create admin_sessions table (stores dates the admin selects)
create table if not exists admin_sessions (
  id uuid primary key default gen_random_uuid(),
  session_name text not null default 'Massage Session',
  min_hours int not null default 7,
  dates jsonb not null default '[]',
  created_at timestamptz default now()
);

-- 2. Create resident_responses table (stores each person's availability)
create table if not exists resident_responses (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references admin_sessions(id) on delete cascade,
  name text not null,
  preferred int not null,
  backup jsonb,
  availability jsonb not null default '[]',
  created_at timestamptz default now()
);

-- 3. Enable Row Level Security (RLS)
alter table admin_sessions enable row level security;
alter table resident_responses enable row level security;

-- 4. Allow anyone to read and insert (public form - no auth needed)
-- Sessions: anyone can create and read
create policy "Allow public read admin_sessions"
  on admin_sessions for select using (true);

create policy "Allow public insert admin_sessions"
  on admin_sessions for insert with check (true);

create policy "Allow public delete admin_sessions"
  on admin_sessions for delete using (true);

-- Responses: anyone can create and read (for their session)
create policy "Allow public read resident_responses"
  on resident_responses for select using (true);

create policy "Allow public insert resident_responses"
  on resident_responses for insert with check (true);

create policy "Allow public update resident_responses"
  on resident_responses for update using (true);

-- If you already have the tables, run just this to add update support:
-- create policy "Allow public update resident_responses" on resident_responses for update using (true);

-- Optional: Create index for faster lookups by session_id
create index if not exists idx_resident_responses_session_id 
  on resident_responses(session_id);
