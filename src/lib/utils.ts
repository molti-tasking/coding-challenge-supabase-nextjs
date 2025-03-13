import { PostgrestSingleResponse } from "@supabase/supabase-js";
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export type ExtractSingleType<T> = T extends Promise<
  PostgrestSingleResponse<infer U>
>
  ? U
  : never;
