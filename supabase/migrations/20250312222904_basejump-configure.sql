create table public.favourite_listing (
  id uuid primary key default extensions.uuid_generate_v4(),

  updated_at              timestamp with time zone,
  created_at              timestamp with time zone,
  created_by              uuid references auth.users on delete set null,
  updated_by              uuid references auth.users on delete set null,

  listing_id uuid not null references public.listing(id) on delete cascade,
  family_profile_id uuid not null references public.family_profile(id) on delete cascade,

  unique (listing_id, family_profile_id)
);


create or replace function public.has_favourite_listing_access (
  favourite_listing_id uuid
) returns boolean language sql security definer
set search_path = public as $$
select exists(
              select 1
              from public.favourite_listing csr
              where public.has_role_for_listing(listing_id)
                and csr.id = has_favourite_listing_access.favourite_listing_id
          ) ;
$$; 

grant execute on function public.has_favourite_listing_access (uuid) to authenticated;

alter table public.favourite_listing enable row level security;

create policy "Enable Insert only for family owners"
on public.favourite_listing
as permissive 
for all 
to authenticated
using (public.has_role_on_family_profile(family_profile_id));

create policy "Enable Select for listing owners"
on public.favourite_listing
as PERMISSIVE
for SELECT
to authenticated
using (
  public.has_role_for_listing(listing_id)
);

create policy "Enable Select for admin users"
on public.favourite_listing
as PERMISSIVE
for SELECT
to authenticated
using (
  public.get_is_admin()
);

create trigger public_set_favourite_listing_timestamp before insert
or
update on public.favourite_listing for each row
execute procedure public.trigger_set_timestamps ();

create trigger public_set_favourite_listing_user_tracking before insert
or
update on public.favourite_listing for each row
execute procedure public.trigger_set_user_tracking ();

