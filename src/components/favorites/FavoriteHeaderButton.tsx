"use client";
import { createClient } from "@/lib/supabase/server";
import { FavouriteButtonProfile } from "./FavouriteButtonProfile";
import { getMyFavouriteCount } from "@/lib/actions/favourite-products";
import { usePersonalAccount } from "@/lib/hooks/use-personal-account";
import { Loader } from "lucide-react";
import { useFavouriteCount } from "@/lib/hooks/favorites";

export const FavoriteHeaderButton = () => {
  const { data, isLoading } = usePersonalAccount();

  const accountId = data?.account_id as string;
  if (isLoading) {
    return <Loader />;
  }

  if (!accountId) {
    return <>X</>;
  }
  return <FavoriteButton accountId={accountId} />;
};

const FavoriteButton = ({ accountId }: { accountId: string }) => {
  const { data, error } = useFavouriteCount(accountId);

  if (!data?.data?.count) {
    return <>0</>;
  }
  return <FavouriteButtonProfile count={data.data.count} />;
};
