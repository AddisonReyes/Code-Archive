import Link from "next/link";

export default function DashboardLayout({ children }) {
  return (
    <div className="flex gap-8">
      {/* Sidebar */}
      <aside className="w-64 bg-slate-100 p-6 rounded-lg min-h-[400px]">
        <nav>
          <ul className="space-y-4">
            <li className="font-bold text-slate-900 border-b border-slate-200 pb-2 mb-4">
              Dashboard Menu
            </li>
            <li>
              <Link
                href="/dashboard/stats"
                className="text-blue-600 hover:text-blue-800 hover:underline"
              >
                Stats
              </Link>
            </li>
            <li>
              <Link
                href="/dashboard/settings"
                className="text-blue-600 hover:text-blue-800 hover:underline"
              >
                Settings
              </Link>
            </li>
          </ul>
        </nav>
      </aside>

      {/* Main Content Area */}
      <section className="flex-1">{children}</section>
    </div>
  );
}
