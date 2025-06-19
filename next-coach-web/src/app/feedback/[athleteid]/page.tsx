import { serverApi } from "@/lib/api";
import { notFound } from "next/navigation";
import { cookies } from "next/headers";
import { ArrowLeft } from "lucide-react";
import Link from "next/link";

type Feedback = {
  id: number;
  comment: string;
  rating: number;
  createdAt: string;
  trainingDay: {
    date: string;
  };
  user: {
    id: number;
    email: string;
  };
};

export default async function FeedbackByAthletePage({
  params,
}: {
  params: { athleteid: string };
}) {
  const athleteid = params.athleteid;
  const cookieStore = cookies();
  const token = (await cookieStore).get("access_token")?.value;

  if (!token) {
    console.error("❌ No access token found in cookies");
    notFound();
  }

  let feedbacks: Feedback[] = [];

  try {
    const res = await serverApi.get(
      `/training-day-feedback/by-athlete/${athleteid}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    feedbacks = res.data;
  } catch (error) {
    console.error("❌ Failed to fetch feedbacks", error);
    notFound();
  }

  if (!feedbacks.length) {
    return (
      <div className="p-6">
        <h1 className="text-2xl font-bold mb-4">
          No feedback found for this athlete.
        </h1>
      </div>
    );
  }

  const email = feedbacks[0]?.user?.email || "";

  return (
    <div className="p-6">
      {/* Back Button */}
      <div className="mb-6">
        <Link
          href="/feedback"
          className="inline-flex items-center px-3 py-1.5 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm hover:bg-gray-50 transition"
        >
          <ArrowLeft className="w-4 h-4 mr-2" />
          Back to Feedback
        </Link>
      </div>

      {/* Header with avatar and email */}
      <div className="mb-6">
        <div className="flex items-center space-x-3 bg-gray-100 px-3 py-1.5 rounded-md w-fit shadow-sm">
          <div className="w-7 h-7 rounded-full bg-indigo-500 flex items-center justify-center text-white font-semibold text-xs uppercase">
            {email.charAt(0)}
          </div>
          <div className="text-xs text-gray-700 font-medium">{email}</div>
        </div>
      </div>

      {/* Feedback Cards */}
      <div className="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-4">
        {feedbacks.map((fb) => (
          <div
            key={fb.id}
            className="bg-white border border-gray-200 rounded-lg shadow-sm hover:shadow-md transition p-3 space-y-1"
          >
            <div className="text-xs text-gray-500">
              📅 <b>Date:</b>{" "}
              {new Date(fb.trainingDay.date).toLocaleDateString()}
            </div>
            <div className="text-xs text-gray-500">
              ⭐ <b>Rating:</b> {fb.rating}/10
            </div>
            <div className="text-sm text-gray-800 italic mt-1 line-clamp-4">
              “{fb.comment}”
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
