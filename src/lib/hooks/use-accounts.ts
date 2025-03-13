import useSWR, { SWRConfiguration } from "swr";
import { createClient } from "../supabase/client";
import { GetAccountsResponse } from "@usebasejump/shared";

type Account = {
  account_id: string;
  role: "owner" | "member";
  is_primary_owner: boolean;
  name: string;
  slug: string;
  personal_account: boolean;
  created_at: Date;
  updated_at: Date;
};

export const useAccounts = (options?: SWRConfiguration) => {
  const supabaseClient = createClient();
  return useSWR<GetAccountsResponse>(
    !!supabaseClient && ["accounts"],
    async () => {
      const { data, error } = await supabaseClient.rpc("get_accounts");

      if (error) {
        throw new Error(error.message);
      }

      return data as unknown as GetAccountsResponse;
    },
    options
  );
};
