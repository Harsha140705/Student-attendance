import React from "react";
import { Layers, Calendar, ChevronRight } from "lucide-react";

export default function Header({ currentPage, selectedDept, setSelectedDept, departments, currentUser, onLogout }) {
  const pageTitles = {
    dashboard: "Executive Dashboard",
    daily: "Daily 7-Period Attendance Grid",
    monthly: "Monthly Attendance Summary",
    defaulters: "Low Attendance Defaulters Radar",
    students: "Student Roster Directory",
    devops: "DevOps CI/CD & Selenium QA Pipeline",
  };

  return (
    <header className="h-16 border-b border-blue-100 bg-white/90 backdrop-blur px-6 flex items-center justify-between sticky top-0 z-40">
      {/* Breadcrumbs */}
      <div className="flex items-center gap-2 text-xs">
        <span className="font-semibold text-blue-600">AMS</span>
        <ChevronRight className="h-3.5 w-3.5 text-blue-300" />
        <span className="font-bold text-slate-900 uppercase tracking-wide">
          {pageTitles[currentPage] || "Overview"}
        </span>
      </div>

      {/* Right Controls: User Profile, Department & Academic Year */}
      <div className="flex items-center gap-3">
        {currentUser && (
          <div className="hidden md:flex items-center gap-2 bg-blue-50 border border-blue-100 px-2.5 py-1 rounded-xl text-xs">
            <span className="font-medium text-slate-800">{currentUser.name}</span>
            <span className="text-[10px] font-mono font-bold bg-blue-600 text-white px-1.5 py-0.5 rounded-md">
              {currentUser.role}
            </span>
          </div>
        )}

        <div className="hidden lg:flex items-center gap-2 bg-white border border-blue-100 px-3 py-1 rounded-xl">
          <Calendar className="h-3.5 w-3.5 text-blue-500" />
          <span className="text-xs font-semibold text-slate-700 font-mono">Academic 2026-27</span>
        </div>

        {currentUser?.role !== "STUDENT" && (
          <div className="flex items-center gap-2">
            <label className="text-xs font-semibold text-slate-600 hidden sm:inline">Dept:</label>
            <select
              value={selectedDept}
              onChange={(e) => setSelectedDept(e.target.value)}
              className="h-8 px-2.5 text-xs font-semibold rounded-[10px] border border-blue-200 bg-white text-slate-900 shadow-sm cursor-pointer focus:outline-none focus:ring-2 focus:ring-blue-500/40 focus:border-blue-500"
            >
              {departments && departments.length > 0 ? (
                departments.map((d) => (
                  <option key={d} value={d}>
                    {d}
                  </option>
                ))
              ) : (
                <option value="CSE (AI & ML)">CSE (AI & ML)</option>
              )}
              <option value="ALL">All Departments</option>
            </select>
          </div>
        )}
      </div>
    </header>
  );
}
