"use client";

import { useEffect, useState } from "react";
import { api } from "@/lib/api";
import { AddAthleteModal } from "../components/ui/AddAthleteModal";
import { EditAthleteModal } from "../components/ui/EditAthleteModal";
import { DeleteAthleteModal } from "../components/ui/DeleteAthleteModal";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogClose,
} from "@/app/components/ui/dialog";
import { Button } from "@/app/components/ui/button";
import { Input } from "@/app/components/ui/input";

interface Runner {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
}

export default function RunnersPage() {
  const [runners, setRunners] = useState<Runner[]>([]);
  const [selectedRunner, setSelectedRunner] = useState<Runner | null>(null);
  const [planName, setPlanName] = useState("");
  const [planDescription, setPlanDescription] = useState("");
  const [startDate, setStartDate] = useState("");

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

  const openPlanModal = (runner: Runner) => {
    setSelectedRunner(runner);
    setPlanName("");
    setPlanDescription("");
    setStartDate("");
  };

  const submitPlan = async () => {
    if (!selectedRunner) return;
    try {
      const planRes = await api.post("/training-plans", {
        name: planName,
        description: planDescription,
      });

      await api.post("/assigned-plans", {
        athleteId: selectedRunner.id,
        trainingPlanId: planRes.data.id,
        startDate,
      });

      setSelectedRunner(null);
      await fetchRunners();
    } catch (err) {
      console.error("❌ Error creating and assigning plan", err);
      alert("Error");
    }
  };

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
              <Dialog>
                <DialogTrigger asChild>
                  <Button onClick={() => openPlanModal(runner)}>
                    Create Plan
                  </Button>
                </DialogTrigger>
                <DialogContent className="max-w-md">
                  <DialogHeader>
                    <DialogTitle>
                      Create Plan for {runner.firstName}
                    </DialogTitle>
                  </DialogHeader>
                  <div className="space-y-4">
                    <div>
                      <label className="block mb-1 text-sm font-medium text-gray-700">
                        Plan Name:
                      </label>
                      <Input
                        placeholder="e.g. 5k progression"
                        value={planName}
                        onChange={(e) => setPlanName(e.target.value)}
                      />
                    </div>
                    <div>
                      <label className="block mb-1 text-sm font-medium text-gray-700">
                        Description:
                      </label>
                      <Input
                        placeholder="e.g. Build up to consistent 5k pace"
                        value={planDescription}
                        onChange={(e) => setPlanDescription(e.target.value)}
                      />
                    </div>
                    <div>
                      <label className="block mb-1 text-sm font-medium text-gray-700">
                        Start Date:
                      </label>
                      <Input
                        type="date"
                        value={startDate}
                        onChange={(e) => setStartDate(e.target.value)}
                      />
                    </div>
                    <div className="flex justify-end space-x-2 pt-4">
                      <DialogClose asChild>
                        <Button variant="outline">Cancel</Button>
                      </DialogClose>
                      <DialogClose asChild>
                        <Button onClick={submitPlan}>Create & Assign</Button>
                      </DialogClose>
                    </div>
                  </div>
                </DialogContent>
              </Dialog>

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
