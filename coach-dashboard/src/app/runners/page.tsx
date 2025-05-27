"use client";

import { useEffect, useState } from "react";
import { api } from "@/lib/api";
import {
  Dialog,
  DialogTrigger,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogClose,
} from "@/app/components/ui/dialog";
import { Button } from "@/app/components/ui/button";
import { Input } from "@/app/components/ui/input";

console.log("✅ RunnersPage mounted");

type Runner = {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
};

type PlanDay = {
  day: string;
  activity: string;
};

export default function RunnersPage() {
  const [runners, setRunners] = useState<Runner[]>([]);
  const [selectedRunner, setSelectedRunner] = useState<Runner | null>(null);
  const [weekStart, setWeekStart] = useState("");
  const [days, setDays] = useState<PlanDay[]>([
    { day: "MONDAY", activity: "" },
    { day: "TUESDAY", activity: "" },
    { day: "WEDNESDAY", activity: "" },
    { day: "THURSDAY", activity: "" },
    { day: "FRIDAY", activity: "" },
    { day: "SATURDAY", activity: "" },
    { day: "SUNDAY", activity: "" },
  ]);

  useEffect(() => {
    console.log("Fetching runners...");
    api
      .get("/users/athletes/my")
      .then((res) => {
        console.log("Fetched runners:", res.data);
        setRunners(res.data);
      })
      .catch((err) => {
        console.error("Failed to fetch runners:", err);
      });
  }, []);

  const openPlanModal = (runner: Runner) => {
    setSelectedRunner(runner);
    setWeekStart(""); // reset fields
    setDays(days.map((d) => ({ ...d, activity: "" })));
  };

  const submitPlan = async () => {
    if (!selectedRunner) return;
    try {
      await api.post("/plans", {
        athleteId: selectedRunner.id,
        weekStart,
        days,
      });
      alert("Plan created!");
      setSelectedRunner(null);
    } catch (err) {
      console.error(err);
      alert("Error creating plan");
    }
  };

  return (
    <div>
      <h1 className="text-2xl font-bold mb-4">My Runners</h1>
      <ul className="space-y-2">
        {runners.map((runner) => (
          <li
            key={runner.id}
            className="border p-4 rounded flex justify-between items-center"
          >
            <div>
              <p>
                <strong>Name:</strong> {runner.firstName} {runner.lastName}
              </p>
              <p>
                <strong>Email:</strong> {runner.email}
              </p>
            </div>
            <Dialog>
              <DialogTrigger asChild>
                <Button onClick={() => openPlanModal(runner)}>
                  Create Plan
                </Button>
              </DialogTrigger>
              <DialogContent className="max-w-md">
                <DialogHeader>
                  <DialogTitle>
                    Create Weekly Plan for {runner.firstName}
                  </DialogTitle>
                </DialogHeader>
                <div className="space-y-4">
                  <div>
                    <label className="block mb-1">
                      Week Start (YYYY-MM-DD):
                    </label>
                    <Input
                      type="date"
                      value={weekStart}
                      onChange={(e) => setWeekStart(e.target.value)}
                    />
                  </div>
                  {days.map((d, idx) => (
                    <div key={d.day}>
                      <label className="block mb-1">{d.day}:</label>
                      <Input
                        placeholder="Activity e.g. 10km easy run"
                        value={d.activity}
                        onChange={(e) => {
                          const newDays = [...days];
                          newDays[idx].activity = e.target.value;
                          setDays(newDays);
                        }}
                      />
                    </div>
                  ))}
                  <div className="flex justify-end space-x-2 pt-4">
                    <DialogClose asChild>
                      <Button variant="outline">Cancel</Button>
                    </DialogClose>
                    <Button onClick={submitPlan}>Submit</Button>
                  </div>
                </div>
              </DialogContent>
            </Dialog>
          </li>
        ))}
      </ul>
    </div>
  );
}
