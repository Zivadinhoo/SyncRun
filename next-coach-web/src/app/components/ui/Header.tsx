"use client";

import { useRouter } from "next/navigation";
import { api } from "@/lib/api";

export default function Header() {
  const router = useRouter();

  const handleLogout = () => {
    delete api.defaults.headers.common["Authorization"];
    localStorage.removeItem("accessToken");
    router.push("/login");
  };

  return (
    <div className="h-16 flex items-center justify-between px-6 border-b bg-white">
      {/* Title + Search */}
      <div className="flex items-center gap-4">
        <h1 className="text-xl font-semibold">Dashboard</h1>
        <input
          type="text"
          placeholder="Search athletes"
          className="px-3 py-1 border rounded-md text-sm focus:outline-none"
        />
        <button className="text-sm px-3 py-1 border rounded-md hover:bg-gray-100">
          Filters
        </button>
      </div>

      {/* Logout */}
      <button
        onClick={handleLogout}
        className="text-sm text-red-600 underline hover:text-red-800"
      >
        Log out
      </button>
    </div>
  );
}
