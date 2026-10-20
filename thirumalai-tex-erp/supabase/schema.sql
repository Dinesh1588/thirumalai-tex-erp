-- Run in the SQL editor of a NEW dedicated Thirumalai Tex Supabase project.
-- Phase 1: single-company, approved-admin-only access.
create table if not exists public.admin_users (user_id uuid primary key references auth.users(id) on delete cascade);
create table if not exists public.company_settings (id integer primary key default 1 check(id=1),name text not null default 'Thirumalai Tex',contact text default 'Vadivel',phone text default '9944383980, 9597142980',address text default 'Tiruppur, Tamil Nadu',gstin text default '');
create table if not exists public.invoices (id uuid primary key default gen_random_uuid(),invoice_number text unique not null,type text not null check(type in('sale','purchase')),invoice_date date not null,party_name text not null,party_address text default '',party_phone text default '',category text default '',notes text default '',subtotal numeric(14,2) not null check(subtotal>=0),tax_rate numeric(6,2) not null default 0 check(tax_rate between 0 and 100),discount numeric(14,2) not null default 0 check(discount>=0),total numeric(14,2) not null check(total>=0),payment_status text not null default 'Unpaid' check(payment_status in('Paid','Unpaid','Partial')),created_by uuid not null references auth.users(id),created_at timestamptz not null default now());
create table if not exists public.invoice_items(id uuid primary key default gen_random_uuid(),invoice_id uuid not null references public.invoices(id) on delete cascade,position integer not null,description text not null,quantity numeric(14,3) not null check(quantity>0),unit text not null default 'PCS',rate numeric(14,2) not null check(rate>=0),amount numeric(14,2) not null check(amount>=0));
create table if not exists public.transactions(id uuid primary key default gen_random_uuid(),kind text not null check(kind in('credit','debit')),amount numeric(14,2) not null check(amount>0),description text not null,date date not null,method text not null default 'Cash',created_by uuid not null references auth.users(id),created_at timestamptz not null default now());
create table if not exists public.employees(id uuid primary key default gen_random_uuid(),name text not null,phone text default '',designation text default '',salary numeric(14,2) not null default 0 check(salary>=0),created_by uuid not null references auth.users(id),created_at timestamptz not null default now());
insert into public.company_settings(id) values(1) on conflict(id) do nothing;
-- RLS enabled on EVERY exposed table.
alter table public.admin_users enable row level security;
alter table public.company_settings enable row level security;
alter table public.invoices enable row level security;
alter table public.invoice_items enable row level security;
alter table public.transactions enable row level security;
alter table public.employees enable row level security;
-- Admin roster is managed only from SQL editor / trusted backend, not from the app.
create policy "admins can read own membership" on public.admin_users for select to authenticated using(user_id=(select auth.uid()));
create policy "admins can read company" on public.company_settings for select to authenticated using(exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admins can edit company" on public.company_settings for update to authenticated using(exists(select 1 from public.admin_users where user_id=(select auth.uid()))) with check(exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admins can read invoices" on public.invoices for select to authenticated using(exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admins can create invoices" on public.invoices for insert to authenticated with check(created_by=(select auth.uid()) and exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admins can delete invoices" on public.invoices for delete to authenticated using(created_by=(select auth.uid()) and exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admins can read invoice items" on public.invoice_items for select to authenticated using(exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admins can create invoice items" on public.invoice_items for insert to authenticated with check(exists(select 1 from public.invoices where id=invoice_id and created_by=(select auth.uid())));
create policy "admins can read transactions" on public.transactions for select to authenticated using(exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admins can add transactions" on public.transactions for insert to authenticated with check(created_by=(select auth.uid()) and exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admins can read employees" on public.employees for select to authenticated using(exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admins can add employees" on public.employees for insert to authenticated with check(created_by=(select auth.uid()) and exists(select 1 from public.admin_users where user_id=(select auth.uid())));
create policy "admins can remove employees" on public.employees for delete to authenticated using(exists(select 1 from public.admin_users where user_id=(select auth.uid())));
-- After creating a staff member in Authentication > Users, approve them:
-- insert into public.admin_users(user_id) values ('PASTE-USER-UUID-HERE');
