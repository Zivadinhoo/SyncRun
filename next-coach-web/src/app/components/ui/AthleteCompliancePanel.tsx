import React from "react";

interface AthleteCompliance {
  name: string;
  completed: number;
  missed: number;
  compliance: number;
  status: string;
}

interface Props {
  data?: AthleteCompliance[];
}

export default function AthleteCompliancePanel({ data }: Props) {
  if (!Array.isArray(data) || data.length === 0) {
    return (
      <div className="bg-white border rounded-lg p-4">
        <h2 className="text-xl font-semibold mb-4">Plan Completion Summary</h2>
        <p className="text-sm text-gray-500">No compliance data available.</p>
      </div>
    );
  }

  return (
    <div className="bg-white border rounded-lg p-4">
      <h2 className="text-xl font-semibold mb-4">
        {" "}
        Athlete Performance Status"
      </h2>
      <div className="overflow-x-auto">
        <table className="min-w-full text-sm">
          <thead>
            <tr className="border-b">
              <th className="text-left py-2">Athlete</th>
              <th className="text-left py-2">Completed</th>
              <th className="text-left py-2">Missed</th>
              <th className="text-left py-2">Compliance</th>
              <th className="text-left py-2">Status</th>
            </tr>
          </thead>
          <tbody>
            {data.map((athlete, i) => (
              <tr key={i} className="border-b">
                <td className="py-2">{athlete.name}</td>
                <td className="py-2">{athlete.completed}</td>
                <td className="py-2">{athlete.missed}</td>
                <td className="py-2">{athlete.compliance}%</td>
                <td className="py-2">
                  {athlete.status === "on-track" && "✅ On Track"}
                  {athlete.status === "warning" && "⚠️ Warning"}
                  {athlete.status === "risk" && "🔴 At Risk"}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
