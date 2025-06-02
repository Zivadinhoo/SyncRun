"use client";

import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/app/components/ui/dialog";
import { Button } from "@/app/components/ui/button";
import { api } from "@/lib/api";
import { useState } from "react";

interface DeletePlanModalProps {
  open: boolean;
  onClose: () => void;
  planId: string;
  onPlanDeleted: (deletedId: string) => void;
}

export const DeletePlanModal = ({
  open,
  onClose,
  planId,
  onPlanDeleted,
}: DeletePlanModalProps) => {
  const [isLoading, setIsLoading] = useState(false);

  const handleDelete = async () => {
    try {
      setIsLoading(true);
      await api.delete(`/training-plans/${planId}`);
      onPlanDeleted(planId);
      onClose();
    } catch (error) {
      console.error("Failed to delete a plan", error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Are you sure?</DialogTitle>
        </DialogHeader>
        <p>This action cannot be undone. Thiw will pernament delete the plan</p>
        <DialogFooter>
          <Button variant="outline" onClick={onClose} disabled={isLoading}>
            Cancel
          </Button>
          <Button
            variant="destructive"
            onClick={handleDelete}
            disabled={isLoading}
          >
            {isLoading ? "Deleting..." : "Delete"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};
