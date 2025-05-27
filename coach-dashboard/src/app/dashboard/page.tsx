"use client";

import DashboardCard from "@/app/components/ui/DashboardCard";

export default function DashboardPage() {
  return (
    <div className="p-6">
      <h1 className="text-3xl font-bold">Welcome to Coach Dashboard</h1>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mt-8">
        <DashboardCard title="Total Runners" value={5} />
        <DashboardCard title="Total Plans" value={4} />
        <DashboardCard title="Completed Today" value={6} />
        <DashboardCard title="Missed Today" value={2} />
      </div>
    </div>
  );
}
