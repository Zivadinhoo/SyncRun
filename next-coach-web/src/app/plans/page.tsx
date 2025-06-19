"use client";

import { useEffect, useState } from "react";
import { api } from "@/lib/api";
import { EditPlanModal } from "@/app/components/ui/EditPlanModal";
import { DeletePlanModal } from "../components/ui/DeletePlanModal";
import { Button } from "@/app/components/ui/button";
import { Trash2, User, CalendarDays } from "lucide-react";
import {
  Accordion,
  AccordionItem,
  AccordionTrigger,
  AccordionContent,
} from "@/components/ui/accordion";

interface Plan {
  id: string;
  name: string;
  description: string;
}

interface AssignedPlan {
  id: string;
  trainingPlan: Plan;
  athlete: {
    email: string;
  };
  assignedAt: string;
}

export default function PlansPage() {
  const [assignedPlans, setAssignedPlans] = useState<AssignedPlan[]>([]);
  const [selectedPlanToDelete, setSelectedPlanToDelete] = useState<Plan | null>(
    null
  );
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);

  const fetchData = async () => {
    try {
      const assignedRes = await api.get("/assigned-plans/my");
      setAssignedPlans(assignedRes.data);
    } catch (err) {
      console.error("❌ Failed to fetch data:", err);
    }
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleOpenDelete = (plan: Plan) => {
    setSelectedPlanToDelete(plan);
    setIsDeleteModalOpen(true);
  };

  const handlePlanDeleted = (deletedId: string) => {
    setAssignedPlans((prev) =>
      prev.filter((ap) => ap.trainingPlan.id !== deletedId)
    );
  };

  const groupByAthlete = () => {
    const grouped: Record<string, AssignedPlan[]> = {};
    assignedPlans.forEach((ap) => {
      const email = ap.athlete.email;
      if (!grouped[email]) grouped[email] = [];
      grouped[email].push(ap);
    });
    return grouped;
  };

  const groupedByAthlete = groupByAthlete();

  return (
    <div className="p-6 bg-gradient-to-br from-gray-50 to-white min-h-screen">
      <h1 className="text-3xl font-bold mb-4">My Training Plans</h1>

      {Object.keys(groupedByAthlete).length === 0 ? (
        <p className="text-gray-500">No assigned plans yet.</p>
      ) : (
        <Accordion type="multiple">
          {Object.entries(groupedByAthlete)
            .sort(([a], [b]) => a.localeCompare(b))
            .map(([email, plans]) => (
              <AccordionItem key={email} value={email}>
                <AccordionTrigger>
                  <div className="flex items-center gap-2">
                    <User className="w-4 h-4 text-gray-600" />
                    <span className="text-sm">
                      {email}{" "}
                      <span className="text-gray-400">({plans.length})</span>
                    </span>
                  </div>
                </AccordionTrigger>
                <AccordionContent>
                  <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                    {plans
                      .sort(
                        (a, b) =>
                          new Date(b.assignedAt).getTime() -
                          new Date(a.assignedAt).getTime()
                      )
                      .map((ap) => {
                        const isToday =
                          new Date(ap.assignedAt).toDateString() ===
                          new Date().toDateString();
                        return (
                          <div
                            key={ap.id}
                            className="border rounded-lg p-4 shadow bg-white hover:shadow-md transition"
                          >
                            <h3 className="font-semibold text-lg">
                              {ap.trainingPlan.name}
                            </h3>
                            <p className="text-sm text-gray-600">
                              {ap.trainingPlan.description}
                            </p>
                            <div className="mt-2 text-xs text-gray-600 flex items-center gap-1">
                              <CalendarDays className="w-4 h-4" />
                              {new Date(ap.assignedAt).toLocaleDateString()}
                              {isToday && (
                                <span className="text-green-600 font-medium ml-1">
                                  (today)
                                </span>
                              )}
                            </div>
                            <div className="flex justify-end gap-2 mt-3">
                              <EditPlanModal
                                plan={ap.trainingPlan}
                                onUpdated={fetchData}
                              />
                              <Button
                                variant="ghost"
                                size="icon"
                                className="text-red-600 hover:text-red-700"
                                onClick={() =>
                                  handleOpenDelete(ap.trainingPlan)
                                }
                              >
                                <Trash2 className="w-4 h-4" />
                              </Button>
                            </div>
                          </div>
                        );
                      })}
                  </div>
                </AccordionContent>
              </AccordionItem>
            ))}
        </Accordion>
      )}

      {selectedPlanToDelete && (
        <DeletePlanModal
          open={isDeleteModalOpen}
          onClose={() => setIsDeleteModalOpen(false)}
          planId={selectedPlanToDelete.id}
          onPlanDeleted={handlePlanDeleted}
        />
      )}
    </div>
  );
}
