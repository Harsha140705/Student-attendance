import React from "react";
import { cn } from "../../lib/utils";

const buttonVariants = {
  variant: {
    default: "bg-blue-600 text-white hover:bg-blue-700 shadow-sm shadow-blue-600/25 border border-blue-600 active:bg-blue-800",
    secondary: "bg-blue-50 text-blue-700 hover:bg-blue-100 border border-blue-200",
    outline: "border border-blue-200 bg-white text-blue-700 hover:bg-blue-50 hover:border-blue-400 active:bg-blue-100",
    ghost: "text-blue-700 hover:bg-blue-50",
    destructive: "bg-red-600 text-white hover:bg-red-700 shadow-sm",
    black: "bg-blue-700 text-white hover:bg-blue-800 border-2 border-blue-700",
  },
  // Semi-round corners: radius scales with height (~1/3) so small buttons don't turn into pills
  size: {
    default: "h-9 px-4 py-2 text-sm rounded-xl",
    sm: "h-8 px-3 text-xs rounded-[10px]",
    lg: "h-10 px-6 text-sm rounded-xl",
    icon: "h-9 w-9 rounded-xl",
    xs: "h-7 px-2.5 text-[11px] rounded-lg",
  },
};

export const Button = React.forwardRef(
  ({ className, variant = "default", size = "default", children, ...props }, ref) => {
    return (
      <button
        ref={ref}
        className={cn(
          "inline-flex items-center justify-center whitespace-nowrap font-medium ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-1 disabled:pointer-events-none disabled:opacity-50 select-none cursor-pointer",
          buttonVariants.variant[variant] || buttonVariants.variant.default,
          buttonVariants.size[size] || buttonVariants.size.default,
          className
        )}
        {...props}
      >
        {children}
      </button>
    );
  }
);
Button.displayName = "Button";
