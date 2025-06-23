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
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/app/components/ui/select";
import { format } from "date-fns";
import {
  getPlanTemplates,
  assignPlanTemplate,
} from "@/app/services/planTemplateService";

interface Props {
  athletes: { id: number; email: string }[];
  onAssigned: () => void;
}

export function AssignPlanFromTemplateModal({ athletes, onAssigned }: Props) {
  const [athleteId, setAthleteId] = useState<string>("");
  const [templateId, setTemplateId] = useState<string>("");
  const [startDate, setStartDate] = useState<string>(
    format(new Date(), "yyyy-MM-dd")
  );
  const [templates, setTemplates] = useState<{ id: string; name: string }[]>(
    []
  );
  const [loading, setLoading] = useState(false);
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    getPlanTemplates()
      .then(setTemplates)
      .catch((err) => console.error("❌ Failed to fetch templates:", err));
  }, []);

  const handleAssign = async () => {
    if (!athleteId || !templateId || !startDate) return;
    setLoading(true);
    try {
      await assignPlanTemplate({
        athleteId,
        templateId,
        startDate,
      });
      setIsOpen(false);
      setAthleteId("");
      setTemplateId("");
      onAssigned();
    } catch (err) {
      console.error("❌ Failed to assign template:", err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <Button variant="outline">Assign Plan from Template</Button>
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

          <Select onValueChange={setTemplateId}>
            <SelectTrigger>
              <SelectValue placeholder="Select Plan Template" />
            </SelectTrigger>
            <SelectContent>
              {templates.map((t) => (
                <SelectItem key={t.id} value={t.id}>
                  {t.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>

          {/* Date input – za sada samo plain text */}
          <input
            type="date"
            value={startDate}
            onChange={(e) => setStartDate(e.target.value)}
            className="border rounded px-3 py-1 w-full text-sm"
          />

          <Button onClick={handleAssign} disabled={loading}>
            {loading ? "Assigning..." : "Assign Plan"}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
