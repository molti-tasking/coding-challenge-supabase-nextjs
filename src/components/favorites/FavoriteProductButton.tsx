"use client";

import {
  useMutateFavouriteListing,
  useMyFavourites,
} from "@/lib/hooks/favorites";
import { usePersonalAccount } from "@/lib/hooks/use-personal-account";
import { Loader, LucideFoldVertical } from "lucide-react";
import { FavouriteButtonCard } from "./FavouriteButtonProfile";

export const FavoriteProductButton = ({ productId }: { productId: string }) => {
  const { data, isLoading } = usePersonalAccount();

  const accountId = data?.account_id as string;
  if (isLoading) {
    return <Loader />;
  }

  if (!accountId) {
    return <></>;
  }
  return <FavoriteButton accountId={accountId} productId={productId} />;
};

const FavoriteButton = ({
  productId,
  accountId,
}: {
  productId: string;
  accountId: string;
}) => {
  const { data: favouriteData, isLoading: isLoading } =
    useMyFavourites(accountId);
  const { mutate } = useMutateFavouriteListing();

  const isInFavourites = !!favouriteData?.data?.some(
    ({ product_id }) => product_id === productId
  );

  if (isLoading) {
    return <Loader />;
  }

  const onAddToFavourites = async () => {
    if (!accountId || !productId) {
      console.log("On add to favorites failed: ", accountId, productId);

      return;
    }

    mutate({
      productId: productId,
      accountId: accountId,
      isInFavourites,
    });
  };

  return (
    <FavouriteButtonCard
      isActive={isInFavourites}
      className="active:animate-spin"
      onClick={onAddToFavourites}
    />
  );
};
