"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import clsx from "clsx";

const navItems = [
  { href: "/dashboard", label: "Dashboard" },
  { href: "/runners", label: "Runners" },
  { href: "/plans", label: "Plans" },
  { href: "/feedback", label: "Feedback" },
];

export default function Sidebar() {
  const pathname = usePathname();

  return (
    <div className="w-64 h-screen bg-neutral-900 text-white p-4 flex flex-col gap-8">
      {/* LOGO */}
      <div className="text-2xl font-bold px-2">
        sync <span className="text-purple-500">run</span>
      </div>

      {/* NAV LINKS */}
      <nav className="flex flex-col gap-2">
        {navItems.map(({ href, label }) => (
          <Link
            key={href}
            href={href}
            className={clsx(
              "px-3 py-2 rounded-md hover:bg-neutral-800 transition",
              pathname === href && "bg-neutral-800"
            )}
          >
            {label}
          </Link>
        ))}
      </nav>
    </div>
  );
}
