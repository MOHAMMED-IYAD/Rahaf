-- Rahaf Birthday: private memories table + private photo bucket.
-- Run the COMPLETE script once in Supabase -> SQL Editor -> New query.

create table if not exists public.memories (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 80),
  memory_date date not null,
  description text not null default '' check (char_length(description) <= 500),
  image_path text,
  created_at timestamptz not null default now()
);

alter table public.memories enable row level security;
grant usage on schema public to authenticated;
grant select, insert, update, delete on public.memories to authenticated;

drop policy if exists "Owner can read own memories" on public.memories;
drop policy if exists "Owner can add own memories" on public.memories;
drop policy if exists "Owner can update own memories" on public.memories;
drop policy if exists "Owner can delete own memories" on public.memories;
create policy "Owner can read own memories" on public.memories
  for select to authenticated using (auth.uid() = owner_id);
create policy "Owner can add own memories" on public.memories
  for insert to authenticated with check (auth.uid() = owner_id);
create policy "Owner can update own memories" on public.memories
  for update to authenticated using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy "Owner can delete own memories" on public.memories
  for delete to authenticated using (auth.uid() = owner_id);

-- Ensure the private Storage bucket exists. This is safe to run repeatedly.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('rahaf-memories', 'rahaf-memories', false, 5242880, array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update set public = false, file_size_limit = 5242880;

drop policy if exists "Owner can read own memory photos" on storage.objects;
drop policy if exists "Owner can upload own memory photos" on storage.objects;
drop policy if exists "Owner can update own memory photos" on storage.objects;
drop policy if exists "Owner can delete own memory photos" on storage.objects;
create policy "Owner can read own memory photos" on storage.objects
  for select to authenticated using (
    bucket_id = 'rahaf-memories' and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "Owner can upload own memory photos" on storage.objects
  for insert to authenticated with check (
    bucket_id = 'rahaf-memories' and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "Owner can update own memory photos" on storage.objects
  for update to authenticated using (
    bucket_id = 'rahaf-memories' and (storage.foldername(name))[1] = auth.uid()::text
  ) with check (
    bucket_id = 'rahaf-memories' and (storage.foldername(name))[1] = auth.uid()::text
  );
create policy "Owner can delete own memory photos" on storage.objects
  for delete to authenticated using (
    bucket_id = 'rahaf-memories' and (storage.foldername(name))[1] = auth.uid()::text
  );
