"use client";

import { useState } from "react";
import { api } from "@/lib/api";
import {
  Dialog,
  DialogTrigger,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogClose,
} from "./dialog";
import { Input } from "./input";
import { Button } from "./button";
import { Pencil } from "lucide-react"; // Ikonica za edit

interface EditAthleteModalProps {
  athlete: {
    id: number;
    firstName: string;
    lastName: string;
    email: string;
  };
  onUpdated: () => void;
}

export function EditAthleteModal({
  athlete,
  onUpdated,
}: EditAthleteModalProps) {
  const [firstName, setFirstName] = useState(athlete.firstName);
  const [lastName, setLastName] = useState(athlete.lastName);
  const [email, setEmail] = useState(athlete.email);
  const [loading, setLoading] = useState(false);

  const handleUpdate = async () => {
    try {
      setLoading(true);
      await api.patch(`/users/${athlete.id}`, {
        firstName,
        lastName,
        email,
      });
      onUpdated();
    } catch (err) {
      console.error("❌ Error updating athlete", err);
      alert("Failed to update athlete");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button
          variant="ghost"
          size="icon"
          className="text-blue-600 hover:text-blue"
        >
          <Pencil className="w-4 h-4" />
        </Button>
      </DialogTrigger>
      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle>Edit Athlete</DialogTitle>
        </DialogHeader>
        <div className="space-y-4">
          <div>
            <label className="block mb-1">First Name:</label>
            <Input
              value={firstName}
              onChange={(e) => setFirstName(e.target.value)}
            />
          </div>
          <div>
            <label className="block mb-1">Last Name:</label>
            <Input
              value={lastName}
              onChange={(e) => setLastName(e.target.value)}
            />
          </div>
          <div>
            <label className="block mb-1">Email:</label>
            <Input value={email} onChange={(e) => setEmail(e.target.value)} />
          </div>
          <div className="flex justify-end space-x-2 pt-4">
            <DialogClose asChild>
              <Button variant="outline">Cancel</Button>
            </DialogClose>
            <DialogClose asChild>
              <Button onClick={handleUpdate} disabled={loading}>
                {loading ? "Saving..." : "Save Changes"}
              </Button>
            </DialogClose>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
