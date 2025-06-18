import { api } from "@/lib/api";

export const fetchDashboardData = async () => {
  const [runnersRes, plansRes] = await Promise.all([
    api.get("/users/athletes/my"),
    api.get("/training-plans/my"),
  ]);

  const runners = runnersRes.data;
  const plans = plansRes.data;

  // Extract all workouts from plans
  const allWorkouts = plans.flatMap((plan: any) => plan.workouts || []);

  const today = new Date().toISOString().split("T")[0];

  const completedToday = allWorkouts.filter(
    (w: any) => w.date === today && w.isCompleted
  ).length;

  const missedToday = allWorkouts.filter(
    (w: any) => w.date === today && !w.isCompleted
  ).length;

  // Count workouts per athlete
  const athleteActivityMap: Record<string, number> = {};
  allWorkouts.forEach((w: any) => {
    if (w.isCompleted) {
      const athleteEmail = w.assignedTo?.email;
      if (athleteEmail) {
        athleteActivityMap[athleteEmail] =
          (athleteActivityMap[athleteEmail] || 0) + 1;
      }
    }
  });

  const topRunners = Object.entries(athleteActivityMap)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 3)
    .map(([email, count]) => ({ email, count }));

  return {
    totalRunners: runners.length,
    totalPlans: plans.length,
    completedToday,
    missedToday,
    topRunners,
    upcomingWorkouts: allWorkouts.filter(
      (w: any) =>
        w.date === today ||
        w.date === new Date(Date.now() + 86400000).toISOString().split("T")[0]
    ),
  };
};
