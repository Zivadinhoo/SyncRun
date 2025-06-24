"use client";

import { useEffect, useState } from "react";
import { api } from "@/lib/api";
import { AddAthleteModal } from "../components/ui/AddAthleteModal";
import { EditAthleteModal } from "../components/ui/EditAthleteModal";
import { DeleteAthleteModal } from "../components/ui/DeleteAthleteModal";
import { Button } from "@/app/components/ui/button";
import { AssignPlanFromTemplateModal } from "../components/ui/AssignPlanFromTemplateModal";

interface Runner {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
}

export default function RunnersPage() {
  const [runners, setRunners] = useState<Runner[]>([]);

  const fetchRunners = async () => {
    try {
      const res = await api.get("/users/athletes/my");
      setRunners(res.data);
    } catch (err) {
      console.error("❌ Failed to fetch runners:", err);
    }
  };

  useEffect(() => {
    fetchRunners();
  }, []);

  return (
    <div className="p-6 bg-gradient-to-br from-gray-50 to-white min-h-screen w-full space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-gray-800">My Runners</h1>
        <AddAthleteModal onCreated={fetchRunners} />
      </div>

      <ul className="space-y-3">
        {runners.map((runner) => (
          <li
            key={runner.id}
            className="flex items-center justify-between border rounded-xl px-4 py-3 shadow-sm bg-white hover:shadow transition"
          >
            <div>
              <p className="text-base font-semibold text-gray-900">
                {runner.firstName} {runner.lastName}
              </p>
              <p className="text-sm text-gray-500">{runner.email}</p>
            </div>

            <div className="flex items-center gap-2">
              <AssignPlanFromTemplateModal
                athleteId={runner.id}
                athleteEmail={runner.email}
                onAssigned={fetchRunners}
              />

              <EditAthleteModal athlete={runner} onUpdated={fetchRunners} />
              <DeleteAthleteModal
                athleteId={runner.id}
                athleteName={`${runner.firstName} ${runner.lastName}`}
                onDeleted={fetchRunners}
              />
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
}
