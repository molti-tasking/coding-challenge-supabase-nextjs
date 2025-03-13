import {
  addToFavourites,
  Favourites,
  getMyFavouriteCount,
  getMyFavourites,
  removeFromFavourites,
} from "@/lib/actions/favourite-products";
import { PostgrestSingleResponse } from "@supabase/supabase-js";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";

export const useMutateFavouriteListing = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (variables: {
      productId: string;
      accountId: string;
      isInFavourites: boolean;
    }) => {
      const { accountId, isInFavourites, productId } = variables;
      if (isInFavourites) {
        return removeFromFavourites(accountId, productId);
      } else {
        return addToFavourites(accountId, productId);
      }
    },
    // When mutate is called:
    onMutate: async (variables) => {
      // Cancel any outgoing refetches
      // (so they don't overwrite our optimistic update)
      await queryClient.cancelQueries({
        queryKey: ["favourite-product", "list"],
      });

      // Snapshot the previous value
      const previousData = queryClient.getQueryData<
        Favourites,
        string[],
        Pick<PostgrestSingleResponse<Favourites>, "data">
      >(["favourite-product", "list"]);

      // Optimistically update to the new value
      queryClient.setQueryData<
        Favourites,
        string[],
        Pick<PostgrestSingleResponse<Favourites>, "data">
      >(
        ["favourite-product", "list"],
        variables.isInFavourites
          ? {
              data:
                previousData?.data?.filter(
                  (entry) => entry.product_id !== variables.productId
                ) ?? [],
            }
          : {
              ...previousData,
              data: [
                ...(previousData?.data ?? []),
                {
                  product_id: variables.productId,
                  account_id: variables.accountId,
                } as Favourites[number],
              ],
            }
      );

      // Return a context with the previous and new data
      return { previousData, variables };
    },
    // If the mutation fails, use the context we returned above
    onError: (err, newTodo, context) => {
      const variables = context?.variables;
      queryClient.setQueryData(
        ["favourite-product", variables?.productId, variables?.accountId],
        context?.previousData
      );
    },
    // Always refetch after error or success:
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ["favourite-product"] });
      // queryClient.invalidateQueries({
      //   queryKey: ["favourite-product", "count"],
      // });
      // queryClient.invalidateQueries({
      //   queryKey: [
      //     "favourite-product",
      //     variables.productId,
      //     variables.accountId,
      //   ],
      // });
      // queryClient.invalidateQueries({
      //   queryKey: ["favourite-product", "all"],
      // });
    },
  });
};

export const useFavouriteCount = (accountId: string) => {
  return useQuery({
    queryKey: ["favourite-product", "count"],
    queryFn: () => getMyFavouriteCount(accountId),
  });
};

export const useMyFavourites = (accountId: string) => {
  return useQuery({
    queryKey: ["favourite-product", "list"],
    queryFn: () => getMyFavourites(accountId),
  });
};
