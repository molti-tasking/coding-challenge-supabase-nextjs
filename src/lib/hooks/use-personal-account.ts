import useSWR, { SWRConfiguration } from "swr";
import { createClient } from "../supabase/client";
import { GetAccountResponse, GetAccountsResponse } from "@usebasejump/shared";

export const usePersonalAccount = (options?: SWRConfiguration) => {
  const supabaseClient = createClient();
  return useSWR<GetAccountResponse>(
    !!supabaseClient && ["personal-account"],
    async () => {
      const { data, error } = await supabaseClient.rpc("get_personal_account");

      if (error) {
        throw new Error(error.message);
      }

      return data as unknown as GetAccountResponse;
    },
    options
  );
};
