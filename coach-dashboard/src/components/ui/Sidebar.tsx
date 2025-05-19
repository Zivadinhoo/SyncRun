import Link from "next/link";

export default function Sidebar() {
  return (
    <div className="w-64 h-screen p-4 border-r flex flex-col gap-4">
      <Link href="/">🏠 Dashboard</Link>
      <Link href="/runners">👟 Runners</Link>
      <Link href="/plans">📅 Plans</Link>
      <Link href="/feedback">📝 Feedback</Link>
    </div>
  );
}
