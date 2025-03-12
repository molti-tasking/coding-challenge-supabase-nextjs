create table IF NOT EXISTS public.products (
    id                          uuid unique NOT NULL DEFAULT extensions.uuid_generate_v4 (),
    created_at                  timestamp with time zone not null default now(),
    title                       text,
    slug                        text unique,
    slogan                      text,
    description                 text,
    account_id                  uuid references basejump.accounts(id) on delete cascade,  

    prices                      double precision,  

    is_new                      boolean not null default true,
 
    constraint product_pkey primary key (id)
  );


-- Open up access to listing
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.products TO authenticated, service_role;



alter table public.products enable row level security; 

create policy "Enable read access for all users" on public.products 
as permissive for select to public 
using (true);

create policy "Enable create for all owners of organization" on public.products 
for insert to authenticated 
with check (
  (basejump.has_role_on_account(account_id, 'owner'::basejump.account_role) = true)
  );

create policy "Enable update for all owners of organization" on public.products 
for update to authenticated 
using (
  (basejump.has_role_on_account(account_id, 'owner'::basejump.account_role) = true)
  );

create policy "Enable delete for all owners of organization" on public.products 
for delete to authenticated 
using (
  (basejump.has_role_on_account(account_id, 'owner'::basejump.account_role) = true)
  );
 


-- convert any character in the slug that's not a letter, number, or dash to a dash on insert/update for organizations
CREATE
OR REPLACE FUNCTION public.slugify_product_slug () RETURNS TRIGGER AS $$
BEGIN
    if NEW.slug is not null then
        NEW.slug = lower(regexp_replace(NEW.slug, '[^a-zA-Z0-9-]+', '-', 'g'));
    end if;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;


CREATE TRIGGER public_slugify_product_slug BEFORE INSERT
OR UPDATE ON public.products FOR EACH ROW
EXECUTE FUNCTION public.slugify_product_slug ();

