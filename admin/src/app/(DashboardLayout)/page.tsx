"use client";
import React from "react";
import AssessmentOverview from "../components/dashboard/AssessmentOverview";
import { Icon } from "@iconify/react";
import RecentClients from "../components/dashboard/RecentClients";

const DashboardPage = () => {
  const statsData = [
    {
      title: "Total Clients",
      count: 100,
      iconColor: "bg-primary",
      cardColor: "bg-lightprimary",
    },
    {
      title: "Total Templates",
      count: 100,
      iconColor: "bg-success",
      cardColor: "bg-lightsuccess",
    },
    {
      title: "Total Assessments",
      count: 100,
      iconColor: "bg-warning",
      cardColor: "bg-lightwarning",
    },
  ];

  return (
    <div className="grid grid-cols-12 gap-6">
      {/* Assessment Overview */}
      <div className="lg:col-span-8 col-span-12">
        <AssessmentOverview />
      </div>

      {/* Stats Cards Section */}
      <div className="lg:col-span-4 col-span-12 space-y-6">
        {statsData.map((stat, index) => (
          <div
            key={index}
            className={`${stat.cardColor} rounded-lg p-6 flex items-center justify-between`}
          >
            <div className="flex items-center gap-3">
              <span
                className={`w-16 h-16 rounded-full flex items-center justify-center text-white ${stat.iconColor}`}
              >
                <Icon
                  icon="solar:users-group-rounded-bold-duotone"
                  height={28}
                />
              </span>
              <div>
                <h5 className="text-lg font-semibold text-dark opacity-80">
                  {stat.title}
                </h5>
              </div>
            </div>
            <h1 className="text-3xl font-bold text-dark">{stat.count}</h1>
          </div>
        ))}
      </div>

      {/* Recent Clients Section */}
      <div className="col-span-12">
        <RecentClients />
      </div>
    </div>
  );
};

export default DashboardPage;
