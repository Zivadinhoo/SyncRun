"use client";

import { useState } from "react";
import { api } from "@/lib/api";

interface EditPlanModalProps {
  plan: {
    id: number;
    name: string;
    description: string;
  };
  onUpdated: () => void;
}

export function EditPlanModal({ plan, onUpdated }: EditPlanModalProps) {
  const [isOpen, setIsOpen] = useState(false);
  const [name, setName] = useState(plan.name);
  const [description, setDescription] = useState(plan.description);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async () => {
    setLoading(true);

    try {
      await api.patch(`/training-plans/${plan.id}`, {
        name,
        description,
      });
      setIsOpen(false);
      onUpdated();
    } catch (err) {
      console.error("Failed to update plan", err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <button
        onClick={() => setIsOpen(true)}
        className="text-sm text-blue-600 hover:underline"
      >
        Edit
      </button>

      {isOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-30 flex items-center justify-center z-50">
          <div className="bg-white p-6 rounded-lg w-full max-w-md shadow-lg">
            <h2 className="text-xl font-bold mb-4">Edit Plan</h2>

            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="w-full border p-2 mb-3 rounded"
              placeholder="Plan name"
            />

            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              className="w-full border p-2 mb-4 rounded"
              placeholder="Description"
              rows={4}
            />

            <div className="flex justify-end gap-3">
              <button
                onClick={() => setIsOpen(false)}
                className="text-sm text-gray-600"
              >
                Cancel
              </button>
              <button
                onClick={handleSubmit}
                disabled={loading}
                className="bg-blue-600 text-white px-4 py-1 rounded hover:bg-blue-700 text-sm"
              >
                {loading ? "Saving..." : "Save"}
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}
