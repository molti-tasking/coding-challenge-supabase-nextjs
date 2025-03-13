"use client";

import { Database } from "@/lib/supabase/types";
import { FavoriteProductButton } from "../favorites/FavoriteProductButton";

export const ProductCard = ({
  product,
}: {
  product: Database["public"]["Tables"]["products"]["Row"];
}) => (
  <div className="rounded-2xl border bg-primary/5 p-4 flex flex-col gap-2 relative">
    <p className="text-xl">{product.title}</p>

    <p className="text-lg">{product.description}</p>

    <div className="absolute top-2 right-2">
      <FavoriteProductButton productId={product.id} />
    </div>
  </div>
);
