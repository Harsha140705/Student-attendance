import React from "react";
import {
  LayoutDashboard,
  CalendarCheck,
  FileSpreadsheet,
  Users,
  AlertTriangle,
  Terminal,
  RefreshCw,
  GraduationCap,
  LogOut,
  User
} from "lucide-react";

export default function Sidebar({ currentPage, setCurrentPage, onResetData, isResetting, currentUser, onLogout }) {
  const isStudent = currentUser?.role === "STUDENT";

  const allNavItems = [
    { id: "dashboard", label: "Dashboard", icon: LayoutDashboard },
    { id: "daily", label: "Daily Attendance", icon: CalendarCheck, badge: "7 Periods", hideForStudent: true },
    { id: "monthly", label: "Monthly Summary", icon: FileSpreadsheet, badge: "Oct '26" },
    { id: "defaulters", label: "Defaulters Radar", icon: AlertTriangle, hideForStudent: true },
    { id: "students", label: "Students Roster", icon: Users, hideForStudent: true },
    { id: "devops", label: "DevOps Pipeline", icon: Terminal, badge: "10/10 QA" },
  ];

  const navItems = allNavItems.filter(item => !(isStudent && item.hideForStudent));

  return (
    <aside className="w-64 border-r border-blue-100 bg-white flex flex-col justify-between shrink-0 min-h-screen">
      <div>
        {/* Brand / Logo */}
        <div className="h-16 border-b border-blue-100 px-5 flex items-center gap-3">
          <div className="h-9 w-9 bg-gradient-to-br from-blue-500 to-blue-700 text-white rounded-xl flex items-center justify-center font-bold text-sm tracking-widest shadow-md shadow-blue-600/30">
            <GraduationCap className="h-5 w-5" />
          </div>
          <div>
            <div className="font-extrabold text-sm tracking-tight text-slate-900 leading-none">
              STUDENT AMS
            </div>
            <div className="text-[10px] font-mono text-slate-500 uppercase tracking-wider mt-1">
              DevOps Engineered
            </div>
          </div>
        </div>

        {/* Navigation Section */}
        <div className="p-3">
          <div className="text-[11px] font-semibold text-slate-400 uppercase tracking-wider px-3 mb-2">
            Main Navigation
          </div>
          <nav className="space-y-1">
            {navItems.map((item) => {
              const Icon = item.icon;
              const isActive = currentPage === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => setCurrentPage(item.id)}
                  className={`w-full flex items-center justify-between px-3 py-2 text-xs font-semibold rounded-xl border text-left cursor-pointer ${
                    isActive
                      ? "bg-blue-600 text-white border-blue-600 shadow-md shadow-blue-600/25"
                      : "bg-transparent text-slate-700 hover:bg-blue-50 hover:text-blue-700 border-transparent"
                  }`}
                >
                  <div className="flex items-center gap-2.5">
                    <Icon className={`h-4 w-4 ${isActive ? "text-white" : "text-blue-500"}`} />
                    <span>{item.label}</span>
                  </div>
                  {item.badge && (
                    <span
                      className={`text-[10px] font-mono px-1.5 py-0.5 rounded-md ${
                        isActive
                          ? "bg-white/20 text-white"
                          : "bg-blue-50 text-blue-700 border border-blue-100"
                      }`}
                    >
                      {item.badge}
                    </span>
                  )}
                </button>
              );
            })}
          </nav>
        </div>
      </div>

      {/* Footer / User Profile & Logout & Reset */}
      <div className="p-3 border-t border-blue-100 space-y-2.5 bg-blue-50/50">
        {currentUser && (
          <div className="p-2.5 bg-white border border-blue-100 rounded-xl">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <div className="h-7 w-7 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold text-xs">
                  {currentUser.name ? currentUser.name[0] : "U"}
                </div>
                <div className="overflow-hidden">
                  <div className="text-xs font-bold text-slate-900 truncate max-w-[110px]">
                    {currentUser.name}
                  </div>
                  <div className="text-[10px] font-mono text-slate-500">
                    {currentUser.role}
                  </div>
                </div>
              </div>

              <button
                onClick={onLogout}
                title="Log Out"
                className="p-1.5 rounded-lg text-slate-500 hover:text-blue-700 hover:bg-blue-50 border border-blue-200 cursor-pointer"
              >
                <LogOut className="h-3.5 w-3.5" />
              </button>
            </div>
          </div>
        )}

        {!isStudent && (
          <button
            onClick={onResetData}
            disabled={isResetting}
            className="w-full flex items-center justify-center gap-2 px-3 py-2 text-xs font-semibold rounded-xl border border-blue-200 bg-white hover:bg-blue-50 hover:border-blue-400 text-blue-700 shadow-sm cursor-pointer"
          >
            <RefreshCw className={`h-3.5 w-3.5 ${isResetting ? "animate-spin" : ""}`} />
            <span>{isResetting ? "Resetting..." : "Reload Demo Data"}</span>
          </button>
        )}

        <div className="flex items-center justify-between text-[11px] font-mono text-slate-600 bg-white border border-blue-100 p-2 rounded-xl">
          <div className="flex items-center gap-2">
            <span className="relative flex h-2 w-2">
              <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
            </span>
            <span className="font-semibold text-slate-900">PostgreSQL 18</span>
          </div>
          <span className="text-[10px] px-1.5 py-0.5 bg-emerald-50 rounded-md text-emerald-700">Active</span>
        </div>
      </div>
    </aside>
  );
}
