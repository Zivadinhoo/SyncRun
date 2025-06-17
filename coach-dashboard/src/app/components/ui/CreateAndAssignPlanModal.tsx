"use client";

import { useState } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/app/components/ui/dialog";
import { Input } from "@/app/components/ui/input";
import { Button } from "@/app/components/ui/button";
import { Textarea } from "@/app/components/ui/textarea";
import { api } from "@/lib/api";
import { format } from "date-fns";

interface Props {
  athleteId: number;
  athleteEmail: string;
  onAssigned: () => void;
}

export function CreateAndAssignPlanModal({
  athleteId,
  athleteEmail,
  onAssigned,
}: Props) {
  const [isOpen, setIsOpen] = useState(false);
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [loading, setLoading] = useState(false);

  const handleCreateAndAssign = async () => {
    if (!name.trim()) return;
    setLoading(true);
    try {
      const planRes = await api.post("/training-plans", {
        name,
        description,
      });

      const trainingPlanId = planRes.data.id;

      await api.post("/assigned-plans", {
        athleteId,
        trainingPlanId,
        startDate: format(new Date(), "yyyy-MM-dd"),
      });

      setIsOpen(false);
      setName("");
      setDescription("");
      onAssigned();
    } catch (err) {
      console.error("Failed to create and assign plan", err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <Button variant="outline">Create Plan</Button>
      </DialogTrigger>

      <DialogContent>
        <DialogHeader>
          <DialogTitle>Create Plan for {athleteEmail}</DialogTitle>
        </DialogHeader>

        <div className="space-y-4">
          <Input
            placeholder="Plan name"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
          <Textarea
            placeholder="Short description"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
          />
          <Button onClick={handleCreateAndAssign} disabled={loading}>
            {loading ? "Creating..." : "Create & Assign"}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
