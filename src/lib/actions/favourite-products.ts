"use server";
import { createClient } from "../supabase/server";
import { ExtractSingleType } from "../utils";

export type Favourites = ExtractSingleType<ReturnType<typeof getMyFavourites>>;

export const addToFavourites = async (
  account_id: string,
  product_id: string
) => {
  const supabaseClient = createClient();
  return await supabaseClient.from("favourite_products").insert({
    account_id,
    product_id,
  });
};

export const removeFromFavourites = async (
  account_id: string,
  product_id: string
) => {
  const supabaseClient = createClient();
  return await supabaseClient
    .from("favourite_products")
    .delete()
    .eq("account_id", account_id)
    .eq("product_id", product_id);
};

export const getMyFavourites = async (account_id: string) => {
  const supabaseClient = createClient();
  return await supabaseClient
    .from("favourite_products")
    .select()
    .eq("account_id", account_id);
};

export const getMyFavouriteCount = async (account_id: string) => {
  const supabaseClient = createClient();
  return await supabaseClient
    .from("favourite_products")
    .select("count")
    .eq("account_id", account_id)
    .single();
};
