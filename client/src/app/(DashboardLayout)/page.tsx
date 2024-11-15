"use client";
import React, { useEffect, useState } from "react";
import AssessmentOverview from "../components/dashboard/AssessmentOverview";
import { Icon } from "@iconify/react";
import RecentUsers from "../components/dashboard/RecentUsers";
import axios from "axios";
import useAuthStore from "@/store/authStore";
import { Spinner } from "flowbite-react";

const DashboardPage = () => {
  const [stats, setStats] = useState({
    total_users: 0,
    total_assigned_template: 0,
    created_assessments: [],
    recent_users: [],
  });
  const [loading, setLoading] = useState(true);

  const { token } = useAuthStore();
  const fetchStats = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/client/statistics`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      console.log(response.data);
      setStats(response.data);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchStats();
  }, []);

  return loading ? (
    <div className="flex justify-center items-center w-full h-[80vh] text-primary">
      <Spinner size="xl" />
    </div>
  ) : (
    <div className="grid grid-cols-12 gap-6">
      {/* Assessment Overview */}
      <div className="lg:col-span-8 col-span-12">
        <AssessmentOverview assessments={stats.created_assessments} />
      </div>

      {/* Stats Cards Section */}
      <div className="lg:col-span-4 col-span-12 space-y-6">
        <div className="bg-lightprimary rounded-lg p-6 flex items-center gap-3">
          <span className="w-16 h-16 rounded-full flex items-center justify-center text-white bg-primary">
            <Icon icon="solar:users-group-rounded-bold-duotone" height={28} />
          </span>
          <div className="flex flex-col gap-1">
            <h5 className="text-lg font-semibold text-dark opacity-80">
              Total Users
            </h5>
            <h1 className="text-3xl font-semibold text-dark">
              {stats.total_users}
            </h1>
          </div>
        </div>
        <div className="bg-lightsuccess rounded-lg p-6 flex items-center gap-3">
          <span className="w-16 h-16 rounded-full flex items-center justify-center text-white bg-success">
            <Icon icon="solar:document-text-bold-duotone" height={28} />
          </span>
          <div className="flex flex-col gap-1">
            <h5 className="text-lg font-semibold text-dark opacity-80">
              Assigned Templates
            </h5>
            <h1 className="text-3xl font-semibold text-dark">
              {stats.total_assigned_template}
            </h1>
          </div>
        </div>
        <div className="bg-lightwarning rounded-lg p-6 flex items-center gap-3">
          <span className="w-16 h-16 rounded-full flex items-center justify-center text-white bg-warning">
            <Icon icon="solar:notes-bold-duotone" height={28} />
          </span>
          <div className="flex flex-col gap-1">
            <h5 className="text-lg font-semibold text-dark opacity-80">
              Total Assessments
            </h5>
            <h1 className="text-3xl font-semibold text-dark">
              {stats.created_assessments.length}
            </h1>
          </div>
        </div>
      </div>

      {/* Recent Clients Section */}
      <div className="col-span-12">
        <RecentUsers clients={stats.recent_users} />
      </div>
    </div>
  );
};

export default DashboardPage;
