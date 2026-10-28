import React from "react";
import { cn } from "../../lib/utils";

const badgeVariants = {
  default: "border-transparent bg-blue-600 text-white shadow-sm hover:bg-blue-700",
  secondary: "border-transparent bg-blue-50 text-blue-700 hover:bg-blue-100",
  destructive: "border-transparent bg-red-600 text-white shadow",
  outline: "border-blue-200 text-blue-700",
  success: "border-emerald-200 bg-emerald-50 text-emerald-700",
  defaulter: "border-red-200 bg-red-50 text-red-700 font-mono font-bold",
};

export function Badge({ className, variant = "default", ...props }) {
  return (
    <div
      className={cn(
        "inline-flex items-center rounded-md border px-2 py-0.5 text-xs font-semibold focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
        badgeVariants[variant] || badgeVariants.default,
        className
      )}
      {...props}
    />
  );
}
