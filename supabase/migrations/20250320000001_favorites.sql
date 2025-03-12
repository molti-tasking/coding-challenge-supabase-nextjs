create table public.favourite_products (
  id uuid primary key default extensions.uuid_generate_v4(),

  updated_at              timestamp with time zone,
  created_at              timestamp with time zone,
  created_by              uuid references auth.users on delete set null,
  updated_by              uuid references auth.users on delete set null,

  product_id uuid not null references public.products(id) on delete cascade,
  account_id uuid not null references basejump.accounts(id) on delete cascade,

  unique (product_id, account_id)
);

 
alter table public.favourite_products enable row level security;

create policy "Enable all only for account owners"
on public.favourite_products
as permissive 
for all 
to authenticated
using (basejump.has_role_on_account(account_id));

create trigger public_set_favourite_products_timestamp before insert
or
update on public.favourite_products for each row
execute procedure basejump.trigger_set_timestamps ();

create trigger public_set_favourite_products_user_tracking before insert
or
update on public.favourite_products for each row
execute procedure basejump.trigger_set_user_tracking ();

