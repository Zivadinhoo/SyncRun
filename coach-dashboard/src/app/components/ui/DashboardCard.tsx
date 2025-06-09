type DashboardCardProps = {
  title: string;
  value: number;
};

export default function DashboardCard({ title, value }: DashboardCardProps) {
  return (
    <div className="bg-neutral-50 shadow-sm border border-gray-200 rounded-lg p-6 text-center">
      <h2 className="text-sm text-gray-500">{title}</h2>
      <p className="text-3xl font-bold mt-2 text-gray-800">{value}</p>
    </div>
  );
}
