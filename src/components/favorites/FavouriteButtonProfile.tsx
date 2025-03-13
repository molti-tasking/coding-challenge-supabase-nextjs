"use client";
import { cn } from "@/lib/utils";
import { HeartIcon } from "lucide-react";
import React from "react";
import { Button } from "../ui/button";

type FavouriteButtonProps = {
  count?: number;
};

export const FavouriteButtonProfile = ({ count }: FavouriteButtonProps) => {
  return (
    <div className={"w-8 h-8 relative animate-fade-in"}>
      <HeartIcon
        className={cn(
          "stroke-primary text-secondary w-full h-full stroke-[0.6px]"
        )}
      />
      {!!count && (
        <span className="absolute top-1/2 -translate-y-1/2 left-1/2 -translate-x-1/2 text-sm font-light animate-fade-in">
          {count}
        </span>
      )}
    </div>
  );
};

export const FavouriteButtonCard = React.forwardRef<
  HTMLButtonElement,
  FavouriteButtonProps & {
    isActive?: boolean;
    className?: string;
    onClick?: () => void;
  }
>(({ isActive, onClick, className }, ref) => {
  return (
    <Button
      ref={ref}
      size={"icon"}
      onClick={onClick}
      className={cn("shadow-lg", className)}
      variant={"secondary"}
    >
      <HeartIcon
        className={cn(
          "stroke-white",
          !!isActive ? "fill-white" : "fill-secondary"
        )}
      />
    </Button>
  );
});
FavouriteButtonCard.displayName = "FavouriteButtonCard";
