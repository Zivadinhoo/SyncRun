"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
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
};

type AthleteFeedbackSummary = {
  athleteId: number;
  email: string;
  averageRating: number;
  totalFeedbacks: number;
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

  const summarizeByAthlete = (): AthleteFeedbackSummary[] => {
    const grouped: Record<number, AthleteFeedbackSummary> = {};

    feedbacks.forEach((fb) => {
      const { id, email } = fb.user;
      if (!grouped[id]) {
        grouped[id] = {
          athleteId: id,
          email,
          averageRating: 0,
          totalFeedbacks: 0,
        };
      }
      grouped[id].totalFeedbacks += 1;
      grouped[id].averageRating += fb.rating;
    });

    return Object.values(grouped).map((athlete) => ({
      ...athlete,
      averageRating: parseFloat(
        (athlete.averageRating / athlete.totalFeedbacks).toFixed(1)
      ),
    }));
  };

  const athleteSummaries = summarizeByAthlete();

  return (
    <div className="p-6">
      <h1 className="text-3xl font-bold mb-6">Training Feedback by Athlete</h1>

      {loading ? (
        <p>Loading...</p>
      ) : athleteSummaries.length === 0 ? (
        <p>No feedback available yet.</p>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {athleteSummaries.map((athlete) => (
            <Link
              key={athlete.athleteId}
              href={`/feedback/${athlete.athleteId.toString()}`}
              className="border rounded-xl p-4 shadow-sm hover:shadow-md transition block"
            >
              <p className="text-sm text-gray-500 mb-1">
                <b>Email:</b> {athlete.email}
              </p>
              <p className="text-sm text-gray-500 mb-1">
                <b>Feedback count:</b> {athlete.totalFeedbacks}
              </p>
              <p className="text-sm text-gray-500">
                <b>Avg rating:</b> {athlete.averageRating}/10
              </p>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
