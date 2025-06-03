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
import { Input } from "@/app/components/ui/input";
import { api } from "@/lib/api";

export function AddAthleteModal({ onCreated }: { onCreated: () => void }) {
  const [isOpen, setIsOpen] = useState(false);
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("test123");
  const [loading, setLoading] = useState(false);

  const handleCreate = async () => {
    console.log("🔥 handleCreate called");

    if (!firstName || !lastName || !email) {
      alert("Please fill in all fields.");
      return;
    }

    const payload = {
      firstName,
      lastName,
      email,
      password,
      role: "athlete",
    };

    console.log("📦 Sending payload:", payload);

    setLoading(true);
    try {
      const response = await api.post("/auth/register", payload);
      console.log("✅ Athlete created successfully:", response.data);

      onCreated(); // refetch runners
      setFirstName("");
      setLastName("");
      setEmail("");
      setIsOpen(false);
    } catch (err: any) {
      console.error("❌ Failed to create athlete:", err?.response?.data || err);
      alert(err?.response?.data?.message || "Failed to create athlete");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={setIsOpen}>
      <DialogTrigger asChild>
        <Button variant="outline">Add Athlete</Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Create New Athlete</DialogTitle>
        </DialogHeader>

        <form
          className="space-y-4"
          onSubmit={(e) => {
            e.preventDefault();
            handleCreate();
          }}
        >
          <Input
            placeholder="First Name"
            value={firstName}
            onChange={(e) => setFirstName(e.target.value)}
          />
          <Input
            placeholder="Last Name"
            value={lastName}
            onChange={(e) => setLastName(e.target.value)}
          />
          <Input
            placeholder="Email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />

          <Button
            type="submit"
            disabled={loading || !email || !firstName || !lastName}
          >
            {loading ? "Creating..." : "Create"}
          </Button>
        </form>
      </DialogContent>
    </Dialog>
  );
}
