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
  athleteId: number;
  athleteEmail: string;
  onAssigned: () => void;
}

export function AssignPlanFromTemplateModal({
  athleteId,
  athleteEmail,
  onAssigned,
}: Props) {
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
    if (!templateId || !startDate) return;
    setLoading(true);
    try {
      await assignPlanTemplate({
        athleteId,
        templateId,
        startDate,
      });
      setIsOpen(false);
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
        <Button variant="default">Assign Plan</Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Assign Plan to Athlete</DialogTitle>
        </DialogHeader>

        <div className="space-y-4">
          <div className="text-sm text-gray-500">
            Assigning to: <strong>{athleteEmail}</strong>
          </div>

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

          <input
            type="date"
            value={startDate}
            onChange={(e) => setStartDate(e.target.value)}
            className="border rounded px-3 py-1 w-full text-sm"
          />

          <Button onClick={handleAssign} disabled={loading || !templateId}>
            {loading ? "Assigning..." : "Assign Plan"}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}
