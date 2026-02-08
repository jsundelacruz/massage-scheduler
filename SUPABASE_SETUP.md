# Supabase Setup for Massage Scheduler

This guide walks you through setting up Supabase so your Massage Scheduler app can save dates and collect availability from multiple people.

## Step 1: Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in (free account)
2. Click **New Project**
3. Choose a name, password, and region
4. Wait for the project to finish provisioning (~2 min)

## Step 2: Create the Database Tables

1. In your Supabase project, go to **SQL Editor** (left sidebar)
2. Click **New Query**
3. Open the file `supabase-schema.sql` in this folder
4. Copy its entire contents and paste into the SQL Editor
5. Click **Run** (or press Cmd/Ctrl + Enter)
6. You should see "Success. No rows returned"

## Step 3: Get Your API Keys

1. Go to **Project Settings** (gear icon in left sidebar)
2. Click **API** in the settings menu
3. Copy these two values:
   - **Project URL** (e.g. `https://xxxxx.supabase.co`)
   - **anon public** key (under "Project API keys")

## Step 4: Add Keys to Your App

1. Open `index.html` in a text editor
2. Search for `SUPABASE_URL` to find the config section:
   ```javascript
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```
3. Replace with your actual values:
   ```javascript
   const SUPABASE_URL = 'https://your-project-id.supabase.co';
   const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
   ```
4. Save the file

## Step 5: Deploy to Netlify

1. Push your code to GitHub (or connect your Git provider)
2. Log in to [netlify.com](https://netlify.com)
3. Click **Add new site** → **Import an existing project**
4. Connect your repo and select the **Massage Scheduler** folder
5. Build settings:
   - **Build command:** (leave empty)
   - **Publish directory:** `.` (or the folder containing `index.html`)
6. Deploy!

## How It Works

- **Admin** creates a session → dates are saved to Supabase
- **Admin** gets a unique link like `https://yoursite.netlify.app/?view=resident&session=abc-123`
- **Residents** open that link → they see the calendar with admin's dates
- **Residents** submit availability → saved to Supabase (linked to that session)
- **Admin** opens the schedule tab → fetches all responses and generates the schedule

Each session has its own link, so you can run multiple massage events without data mixing.

## Already set up? Add delete support

If you ran the schema before the delete feature was added, run this in the SQL Editor to allow deleting events:

```sql
create policy "Allow public delete admin_sessions" on admin_sessions for delete using (true);
```

## Troubleshooting

**"Supabase not configured"** – Make sure you replaced the placeholder values in `index.html` with your real URL and anon key.

**"Session not found"** – The resident link might be wrong. Have the admin copy the link again from the green success message after submitting dates.

**Responses not showing** – Check the Supabase dashboard → Table Editor → `resident_responses` to see if data is being saved.
