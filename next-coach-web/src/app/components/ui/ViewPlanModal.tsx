"use client";

import { useEffect, useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/app/components/ui/dialog";
import { Button } from "@/app/components/ui/button";
import { api } from "@/lib/api";

interface Props {
  planId: string;
}

interface TrainingDay {
  id: string;
  date: string;
  title: string;
  description: string;
  duration: number;
  tss: number;
}

export function ViewPlanModal({ planId }: Props) {
  const [isOpen, setIsOpen] = useState(false);
  const [days, setDays] = useState<TrainingDay[]>([]);

  useEffect(() => {
    if (!isOpen) return;
    api
      .get(`/training-days/by-plan/${Number(planId)}`)
      .then((res) => setDays(res.data))
      .catch((err) => console.error("Failed to fetch training days", err));
  }, [isOpen, planId]);

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <Button variant="outline">📋 View Plan</Button>
      </DialogTrigger>
      <DialogContent className="max-w-2xl">
        <DialogHeader>
          <DialogTitle>Plan Details</DialogTitle>
        </DialogHeader>
        <div className="space-y-3 max-h-[60vh] overflow-y-auto">
          {days.length === 0 ? (
            <p className="text-gray-500">No training days.</p>
          ) : (
            days
              .sort(
                (a, b) =>
                  new Date(a.date).getTime() - new Date(b.date).getTime()
              )
              .map((day) => (
                <div key={day.id} className="border p-3 rounded">
                  <p className="text-sm font-semibold">
                    {new Date(day.date).toLocaleDateString()}
                  </p>
                  <p className="text-xs text-gray-600">{day.title}</p>
                  <p className="text-xs text-gray-500">{day.description}</p>
                  <p className="text-xs mt-1">
                    ⏱ {day.duration} min | TSS: {day.tss}
                  </p>
                </div>
              ))
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}
