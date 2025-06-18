"use client";

import { useEffect, useState } from "react";
import DashboardCard from "@/app/components/ui/DashboardCard";
import { fetchDashboardData } from "@/app/services/dashboard.service";
import AthleteCompliancePanel from "@/app/components/ui/AthleteCompliancePanel";

export default function DashboardPage() {
  const [stats, setStats] = useState<any>(null);

  useEffect(() => {
    const load = async () => {
      const data = await fetchDashboardData();
      setStats(data);
    };
    load();
  }, []);

  if (!stats) return <p>Loading...</p>;

  return (
    <div className="p-6 space-y-6">
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        <DashboardCard title="Total Runners" value={stats.totalRunners} />
        <DashboardCard title="Total Plans" value={stats.totalPlans} />
        <DashboardCard title="Completed Today" value={stats.completedToday} />
        <DashboardCard title="Missed Today" value={stats.missedToday} />
      </div>

      <div className="bg-white border rounded-lg p-4">
        <h2 className="text-xl font-semibold mb-2">🥇 Top Runners This Week</h2>
        <ul className="list-disc pl-4 text-sm">
          {stats.topRunners.map((r: any, i: number) => (
            <li key={i}>
              {r.email} – {r.count} workouts
            </li>
          ))}
        </ul>
      </div>

      <AthleteCompliancePanel data={stats.athleteCompliance} />

      <div className="bg-white border rounded-lg p-4">
        <h2 className="text-xl font-semibold mb-2">📅 Upcoming Workouts</h2>
        <ul className="list-disc pl-4 text-sm">
          {stats.upcomingWorkouts.map((w: any, i: number) => (
            <li key={i}>
              {w.assignedTo?.email} – {w.title || "Workout"} on {w.date}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
