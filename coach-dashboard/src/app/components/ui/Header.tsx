"use client";

import { useRouter } from "next/navigation";
import { api } from "@/lib/api";

export default function Header() {
  const router = useRouter();

  const handleLogout = () => {
    // 1. Ukloni token iz api instance
    delete api.defaults.headers.common["Authorization"];

    // 2. (opciono) Ukloni iz localStorage ako si tamo čuvao
    localStorage.removeItem("accessToken");

    // 3. Vrati na login
    router.push("/login");
  };

  return (
    <div className="h-16 flex items-center justify-between px-6 border-b">
      <h1 className="text-xl font-bold">SyncRun Coach</h1>
      <button onClick={handleLogout} className="text-sm text-red-600 underline">
        Logout
      </button>
    </div>
  );
}
