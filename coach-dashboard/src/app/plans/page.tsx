"use client";

import { useEffect, useState } from "react";
import { api } from "@/lib/api";
import { CreatePlanModal } from "@/app/components/ui/CreatePlanModal";
import { AssignPlanModal } from "@/app/components/ui/AssignPlanModal";
import { EditPlanModal } from "@/app/components/ui/EditPlanModal";
import { DeletePlanModal } from "../components/ui/DeletePlanModal";
import { Button } from "@/app/components/ui/button";
import { Trash2 } from "lucide-react";

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
  const [plans, setPlans] = useState<Plan[]>([]);
  const [assignedPlans, setAssignedPlans] = useState<AssignedPlan[]>([]);
  const [athletes, setAthletes] = useState<any[]>([]);

  const [selectedPlanToDelete, setSelectedPlanToDelete] = useState<Plan | null>(
    null
  );
  const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);

  const fetchData = async () => {
    try {
      const plansRes = await api.get("/training-plans/my");
      setPlans(plansRes.data);
      const assignedRes = await api.get("/assigned-plans/my");
      setAssignedPlans(assignedRes.data);
      const athletesRes = await api.get("/users/athletes/my");
      setAthletes(athletesRes.data);
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
    setPlans((prev) => prev.filter((p) => p.id !== deletedId));
  };

  return (
    <div className="p-6">
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-3xl font-bold">My Training Plans</h1>
        <div className="flex gap-2">
          <CreatePlanModal onPlanCreated={fetchData} />
          {plans.length > 0 && athletes.length > 0 && (
            <AssignPlanModal
              plans={plans}
              athletes={athletes}
              onAssigned={fetchData}
            />
          )}
        </div>
      </div>

      {plans.length === 0 ? (
        <p className="text-gray-500">You don't have any plans yet.</p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {plans.map((plan: Plan) => (
            <div
              key={plan.id}
              className="border rounded-lg p-4 shadow bg-white"
            >
              <h2 className="font-semibold text-lg">{plan.name}</h2>
              <p className="text-sm text-gray-600">{plan.description}</p>

              <div className="mt-2 text-xs text-gray-500">
                <strong>Assigned to:</strong>
                {assignedPlans.filter((ap) => ap.trainingPlan.id === plan.id)
                  .length === 0 && <div>None</div>}
                {assignedPlans
                  .filter((ap) => ap.trainingPlan.id === plan.id)
                  .map((ap) => (
                    <div key={ap.id}>
                      {ap.athlete.email} (
                      {new Date(ap.assignedAt).toLocaleDateString()})
                    </div>
                  ))}
              </div>

              <div className="flex justify-end gap-2 mt-3">
                <EditPlanModal plan={plan} onUpdated={fetchData} />
                <Button
                  variant="ghost"
                  size="icon"
                  className="text-red-600 hover:text-red-700"
                  onClick={() => handleOpenDelete(plan)}
                >
                  <Trash2 className="w-4 h-4" />
                </Button>
              </div>
            </div>
          ))}
        </div>
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
