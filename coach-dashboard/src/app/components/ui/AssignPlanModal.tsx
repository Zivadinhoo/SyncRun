"use client";

import { useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/app/components/ui/dialog";
import { Button } from "@/app/components/ui/button";
import { api } from "@/lib/api";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/app/components/ui/select";
import { format } from "date-fns";

interface Props {
  athletes: { id: number; email: string }[];
  plans: { id: string; name: string }[];
  onAssigned: () => void;
}

export function AssignPlanModal({ athletes, plans, onAssigned }: Props) {
  const [athleteId, setAthleteId] = useState<string>("");
  const [planId, setPlanId] = useState<string>("");
  const [isOpen, setIsOpen] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleAssign = async () => {
    if (!athleteId || !planId) return;
    setLoading(true);
    try {
      await api.post("/assigned-plans", {
        athleteId: Number(athleteId),
        trainingPlanId: Number(planId),
        startDate: format(new Date(), "yyyy-MM-dd"),
      });
      setIsOpen(false);
      setAthleteId("");
      setPlanId("");
      onAssigned();
    } catch (err) {
      console.error("Failed to assign plan", err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <Button variant="outline">Assign Plan</Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Assign Plan to Athlete</DialogTitle>
        </DialogHeader>

        <div className="space-y-4">
          <Select onValueChange={setAthleteId}>
            <SelectTrigger>
              <SelectValue placeholder="Select Athlete" />
            </SelectTrigger>
            <SelectContent>
              {athletes.map((a) => (
                <SelectItem key={a.id} value={a.id.toString()}>
                  {a.email}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>

          <Select onValueChange={setPlanId}>
            <SelectTrigger>
              <SelectValue placeholder="Select Plan" />
            </SelectTrigger>
            <SelectContent>
              {plans.map((p) => (
                <SelectItem key={p.id} value={p.id.toString()}>
                  {p.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>

          <Button onClick={handleAssign} disabled={loading}>
            {loading ? "Assigning..." : "Assign"}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
