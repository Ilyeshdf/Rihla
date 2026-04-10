-- RIHLA BACKEND SCHEMA: PROJECT MEDITERRANEAN HORIZON
-- SUPABASE POSTGRESQL SPECIFICATION

-- 1. EXTENSIONS & TYPES
create extension if not exists "uuid-ossp";

-- Enum for Marketplace Seller Classifications
create type buyer_tier as enum ('individual', 'group', 'company');

-- 2. USER PROFILES
-- Links to auth.users for security
create table public.profiles (
  id uuid references auth.users on delete cascade primary key,
  username text unique not null,
  wilaya text not null,
  avatar_url text,
  xp integer default 0,
  current_level text default 'Beginner',
  first_discoveries text[] default '{}',
  updated_at timestamp with time zone default timezone('utc'::text, now()),
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 3. JOURNEYS (Safety & Tracking)
create table public.journeys (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  place_name text not null,
  wilaya text not null,
  start_time timestamp with time zone not null,
  end_time timestamp with time zone,
  distance_km double precision default 0,
  elevation_gain double precision default 0,
  difficulty text,
  photos text[] default '{}',
  is_verified boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 4. SOCIAL FEED (Explorers Community)
create table public.posts (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references public.profiles(id) on delete cascade not null,
  journey_id uuid references public.journeys(id) on delete set null,
  photo_url text not null,
  caption text,
  tags text[] default '{}',
  achievement_badge text,
  likes_count integer default 0,
  comments_count integer default 0,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Store likes separately to prevent racing conditions
create table public.post_likes (
  post_id uuid references public.posts(id) on delete cascade,
  user_id uuid references public.profiles(id) on delete cascade,
  primary key (post_id, user_id)
);

-- 5. ACHIEVEMENTS SYSTEM
create table public.achievements (
  id text primary key, -- e.g. 'exp_1'
  name text not null,
  ar_name text not null,
  description text,
  criteria_type text, -- 'distance', 'discoveries', 'xp'
  criteria_value integer,
  icon_path text
);

create table public.user_achievements (
  user_id uuid references public.profiles(id) on delete cascade,
  achievement_id text references public.achievements(id) on delete cascade,
  unlocked_at timestamp with time zone default timezone('utc'::text, now()),
  primary key (user_id, achievement_id)
);

-- 6. MARKETPLACE (Store)
create table public.marketplace_items (
  id uuid default uuid_generate_v4() primary key,
  seller_id uuid references public.profiles(id) on delete cascade not null,
  name text not null,
  price_da integer not null,
  image_url text not null,
  seller_tier buyer_tier not null default 'individual',
  description text,
  rating double precision default 0,
  is_available boolean default true,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- 7. SECURITY & RLS POLICIES

-- Enable RLS
alter table public.profiles enable row level security;
alter table public.journeys enable row level security;
alter table public.posts enable row level security;
alter table public.post_likes enable row level security;
alter table public.marketplace_items enable row level security;

-- Profiles: Public can read, only owner can update
create policy "Public profiles are viewable by everyone." on profiles for select using (true);
create policy "Users can update own profile." on profiles for update using (auth.uid() = id);

-- Journeys: Owner only access for private tracking, public can view verified ones
create policy "Users can view own journeys." on journeys for select using (auth.uid() = user_id);
create policy "Users can manage own journeys." on journeys for all using (auth.uid() = user_id);

-- Posts: Public viewable, owner manage
create policy "Posts are viewable by everyone." on posts for select using (true);
create policy "Authorized users can create posts." on posts for insert with check (auth.uid() = user_id);
create policy "Users can delete own posts." on posts for delete using (auth.uid() = user_id);

-- Marketplace: Public can see, owner manages
create policy "Items are viewable by everyone." on marketplace_items for select using (true);
create policy "Sellers can manage items." on marketplace_items for all using (auth.uid() = seller_id);

-- 8. AUTOMATION (Functions & Triggers)

-- Handle New User Signups
create function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username, wilaya)
  values (new.id, new.raw_user_meta_data->>'username', new.raw_user_meta_data->>'wilaya');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Atomic Likes Counter
create function public.handle_post_like()
returns trigger as $$
begin
  if (TG_OP = 'INSERT') then
    update public.posts set likes_count = likes_count + 1 where id = new.post_id;
  elsif (TG_OP = 'DELETE') then
    update public.posts set likes_count = likes_count - 1 where id = old.post_id;
  end if;
  return null;
end;
$$ language plpgsql;

create trigger post_liked
  after insert or delete on public.post_likes
  for each row execute procedure public.handle_post_like();
