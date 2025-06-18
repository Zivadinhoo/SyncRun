"use client";

import { api } from "@/lib/api";
import { useState, useRef } from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogClose,
} from "@/app/components/ui/dialog";
import { Button } from "@/app/components/ui/button";
import { Trash2 } from "lucide-react";

interface DeleteAthleteModalProps {
  athleteId: number;
  athleteName: string;
  onDeleted: () => void;
}

export function DeleteAthleteModal({
  athleteId,
  athleteName,
  onDeleted,
}: DeleteAthleteModalProps) {
  const [loading, setLoading] = useState(false);
  const closeRef = useRef<HTMLButtonElement>(null); // 👈 referenca za zatvaranje

  const handleDelete = async () => {
    try {
      setLoading(true);
      await api.delete(`/users/${athleteId}`);
      onDeleted();
      closeRef.current?.click(); // 👈 ručno zatvori dijalog
    } catch (err) {
      console.error("❌ Failed to delete athlete:", err);
      alert("Failed to delete athlete.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button variant="ghost" size="icon">
          <Trash2 className="w-4 h-4 text-red-500" />
        </Button>
      </DialogTrigger>
      <DialogContent className="max-w-sm">
        <DialogHeader>
          <DialogTitle>Delete {athleteName}?</DialogTitle>
        </DialogHeader>
        <p className="text-sm text-gray-600">
          Are you sure you want to delete this athlete? This action can be
          reversed from admin panel if needed.
        </p>
        <div className="flex justify-end space-x-2 pt-4">
          <DialogClose asChild>
            <Button variant="outline">Cancel</Button>
          </DialogClose>
          <Button
            onClick={handleDelete}
            disabled={loading}
            variant="destructive"
          >
            {loading ? "Deleting..." : "Delete"}
          </Button>
          {/* hidden button to close programmatically */}
          <DialogClose asChild>
            <button ref={closeRef} className="hidden" />
          </DialogClose>
        </div>
      </DialogContent>
    </Dialog>
  );
}
