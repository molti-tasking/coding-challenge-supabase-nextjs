"use server";

import { createClient } from "../supabase/server";

export const getProducts = async () => {
  const supabase = createClient();
  return await supabase.from("products").select();
};
