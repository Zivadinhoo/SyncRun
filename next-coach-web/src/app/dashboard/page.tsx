"use client";

import { useEffect, useState } from "react";
import { fetchDashboardData } from "@/app/services/dashboard.service";
import {
  Activity,
  Users,
  ClipboardList,
  CalendarCheck,
  BarChart2,
  HeartPulse,
  TrendingUp,
  Watch,
} from "lucide-react";
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

  if (!stats) return <p className="p-6">Loading...</p>;

  return (
    <div className="p-6 space-y-6 bg-gradient-to-br from-gray-50 to-white min-h-screen">
      <div>
        <h1 className="text-2xl font-bold mb-1">Coach Dashboard</h1>
        <p className="text-sm text-gray-500">
          Monitor team metrics, trends, and upcoming sessions.
        </p>
      </div>

      {/* Performance Metrics */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <StatCard
          icon={<Users className="text-blue-500 w-5 h-5" />}
          bg="bg-blue-100"
          title="Total Runners"
          value={stats.totalRunners}
        />
        <StatCard
          icon={<ClipboardList className="text-emerald-500 w-5 h-5" />}
          bg="bg-emerald-100"
          title="Total Plans"
          value={stats.totalPlans}
        />
        <StatCard
          icon={<CalendarCheck className="text-indigo-500 w-5 h-5" />}
          bg="bg-indigo-100"
          title="Completed Today"
          value={stats.completedToday}
        />
        <StatCard
          icon={<Activity className="text-rose-500 w-5 h-5" />}
          bg="bg-rose-100"
          title="Missed Today"
          value={stats.missedToday}
        />
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <StatCard
          icon={<TrendingUp className="text-orange-500 w-5 h-5" />}
          bg="bg-orange-100"
          title="CTL"
          value={stats.ctl || 0}
        />
        <StatCard
          icon={<Watch className="text-cyan-500 w-5 h-5" />}
          bg="bg-cyan-100"
          title="ATL"
          value={stats.atl || 0}
        />
        <StatCard
          icon={<BarChart2 className="text-purple-500 w-5 h-5" />}
          bg="bg-purple-100"
          title="TSB"
          value={stats.tsb || 0}
        />
        <StatCard
          icon={<HeartPulse className="text-pink-500 w-5 h-5" />}
          bg="bg-pink-100"
          title="HRV Avg"
          value={stats.hrv || 0}
        />
      </div>

      {/* Compliance Progress */}
      <AthleteCompliancePanel data={stats.athleteCompliance} />

      {/* Top Runners */}
      <div className="bg-white border rounded-xl p-4 shadow-sm">
        <div className="flex items-center justify-between mb-3">
          <h2 className="text-lg font-semibold">🏅 Top Runners This Week</h2>
          <button className="text-sm text-blue-600 hover:underline">
            View All
          </button>
        </div>
        {stats.topRunners.length === 0 ? (
          <p className="text-sm text-gray-500 italic">No data available.</p>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
            {stats.topRunners.map((r: any, i: number) => (
              <div
                key={i}
                className="bg-gray-50 border rounded-md p-3 shadow-sm hover:shadow transition"
              >
                <p className="text-sm text-gray-800 font-medium">{r.email}</p>
                <p className="text-sm text-gray-500">
                  {r.count} workouts this week
                </p>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Upcoming Workouts */}
      <div className="bg-white border rounded-xl p-4 shadow-sm">
        <div className="flex items-center justify-between mb-3">
          <h2 className="text-lg font-semibold">📅 Upcoming Workouts</h2>
          <button className="text-sm text-blue-600 hover:underline">
            View All
          </button>
        </div>
        {stats.upcomingWorkouts.length === 0 ? (
          <p className="text-sm text-gray-500 italic">
            No workouts scheduled yet.
          </p>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-4">
            {stats.upcomingWorkouts.map((w: any, i: number) => (
              <div
                key={i}
                className="bg-gray-50 border rounded-md p-3 shadow-sm hover:shadow transition"
              >
                <p className="text-sm text-gray-800 font-medium">
                  {w.assignedTo?.email}
                </p>
                <p className="text-sm text-gray-500">
                  🏃 {w.title || "Workout"} <br />
                  📅 {w.date}
                </p>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

function StatCard({
  icon,
  title,
  value,
  bg,
}: {
  icon: React.ReactNode;
  title: string;
  value: number;
  bg: string;
}) {
  return (
    <div className="bg-white rounded-xl border p-4 shadow-sm flex items-center gap-3">
      <div className={`${bg} p-2 rounded-full`}>{icon}</div>
      <div>
        <p className="text-sm text-gray-500">{title}</p>
        <p className="text-lg font-semibold text-gray-800">{value}</p>
      </div>
    </div>
  );
}
