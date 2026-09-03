-- Run manually in the Supabase SQL editor or via the Supabase CLI.
-- This project has no automated migration runner; this file documents the change.
alter table actividades add column if not exists imagen_url text;
