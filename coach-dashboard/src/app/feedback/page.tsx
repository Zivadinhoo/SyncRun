"use client";

import { useState, useEffect } from "react";
import axios from "axios";
import { api } from "@/lib/api";

type Feedback = {
  id: number;
  comment: string;
  rating: number;
  createdAt: string;

  user: {
    id: number;
    email: string;
  };
  trainingDay: {
    id: number;
    date: string;
  };
};

export default function FeedbackPage() {
  const [feedbacks, setFeedbacks] = useState<Feedback[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchFeedbacks = async () => {
      try {
        const res = await api.get("/training-day-feedback/for-coach");
        setFeedbacks(res.data);
      } catch (err) {
        console.error("❌ Error fetching feedbacks", err);
      } finally {
        setLoading(false);
      }
    };

    fetchFeedbacks();
  }, []);

  return (
    <div className="p-6">
      <h1 className="text-3xl font-bold mb-6">Training Feedback</h1>

      {loading ? (
        <p>Loading...</p>
      ) : feedbacks.length === 0 ? (
        <p>No feedback available yet.</p>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {feedbacks.map((fb) => (
            <div
              key={fb.id}
              className="border rounded-xl p-4 shadow-sm hover:shadow-md transition"
            >
              <p className="text-sm text-gray-500 mb-1">
                <b>Runner:</b> {fb.user.email}
              </p>
              <p className="text-sm text-gray-500 mb-1">
                <b>Date:</b>{" "}
                {new Date(fb.trainingDay.date).toLocaleDateString()}
              </p>
              <p className="text-sm text-gray-500 mb-1">
                <b>Rating:</b> {fb.rating}/10
              </p>
              <p className="text-base mt-2">{fb.comment}</p>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
