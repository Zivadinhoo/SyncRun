"use client";

import { usePathname } from "next/navigation";

import Sidebar from "@/app/components/ui/Sidebar";
import Header from "@/app/components/ui/Header";
import { ReactNode } from "react";

export default function ClientLayout({ children }: { children: ReactNode }) {
  const pathname = usePathname();
  const isLoginPage = pathname === "/login";

  if (isLoginPage) {
    return <main className="w-full">{children}</main>;
  }

  return (
    <div className="flex">
      <Sidebar />
      <div className="flex-1 flex flex-col">
        <Header />
        <main className="p-6">{children}</main>
      </div>
    </div>
  );
}
