"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { api } from "@/lib/api";
import clsx from "clsx"; // ako nemaš, install: npm i clsx

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [shake, setShake] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    setShake(false);

    try {
      await api.post("/auth/login", { email, password });
      router.push("/dashboard");
    } catch (err: unknown) {
      setError(err instanceof Error ? err.message : "Unknown error occurred.");
      setShake(true);
      setTimeout(() => setShake(false), 500); // reset shake
    }
  };

  return (
    <div className="min-h-screen w-full bg-black flex items-center justify-center px-4">
      <div
        className={clsx(
          "bg-neutral-900 border border-neutral-800 rounded-xl p-8 w-full max-w-md text-white shadow-lg transition-all duration-300",
          shake && "animate-shake"
        )}
      >
        <h1 className="text-2xl font-bold text-center mb-6">SyncRun Coach</h1>

        {error && (
          <p className="text-red-500 text-sm mb-4 text-center">{error}</p>
        )}

        <form onSubmit={handleLogin} className="space-y-4">
          <input
            type="email"
            placeholder="Email"
            className="w-full bg-neutral-800 border border-neutral-700 rounded px-4 py-2 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-gray-400"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <input
            type="password"
            placeholder="Password"
            className="w-full bg-neutral-800 border border-neutral-700 rounded px-4 py-2 text-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-gray-400"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <button
            type="submit"
            className="w-full bg-white text-black font-semibold py-2 rounded hover:bg-gray-200 transition"
          >
            Log in
          </button>
        </form>

        <div className="text-sm text-center mt-6 text-neutral-400">
          Don’t have an account?{" "}
          <a href="/signup" className="text-blue-400 hover:underline">
            Sign up
          </a>
        </div>
      </div>
    </div>
  );
}
