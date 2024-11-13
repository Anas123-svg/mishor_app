"use client";
import React, { useState, useEffect } from "react";
import dynamic from "next/dynamic";
import { Select } from "flowbite-react";
import dayjs from "dayjs";

const Chart = dynamic(() => import("react-apexcharts"), { ssr: false });

const AssessmentOverview = ({
  assessments,
}: {
  assessments: {
    created_at: string;
  }[];
}) => {
  // Extract unique years from assessments data
  const years = Array.from(
    new Set(
      assessments.map((assessment) => dayjs(assessment.created_at).year())
    )
  ).sort();

  // State for selected year and monthly data
  const [selectedYear, setSelectedYear] = useState(years[years.length - 1]);
  const [monthlyData, setMonthlyData] = useState<number[]>(Array(12).fill(0));

  // Function to filter and count assessments per month for the selected year
  useEffect(() => {
    const monthlyCounts = Array(12).fill(0);
    assessments.forEach((assessment) => {
      const assessmentDate = dayjs(assessment.created_at);
      if (assessmentDate.year() === selectedYear) {
        const month = assessmentDate.month(); // 0 for Jan, 11 for Dec
        monthlyCounts[month] += 1;
      }
    });
    setMonthlyData(monthlyCounts);
  }, [selectedYear, assessments]);

  // Chart configuration
  const optionsLineChart: any = {
    chart: {
      type: "line",
      fontFamily: "inherit",
      foreColor: "#adb0bb",
      fontSize: "12px",
      offsetX: 0,
      offsetY: 10,
      animations: { speed: 500 },
      toolbar: { show: false },
    },
    colors: ["var(--color-primary)"],
    dataLabels: { enabled: false },
    fill: { type: "solid", opacity: 0.5 },
    grid: {
      show: true,
      strokeDashArray: 3,
      borderColor: "#90A4AE50",
    },
    stroke: { curve: "smooth", width: 2 },
    xaxis: {
      categories: [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ],
      axisBorder: { show: false },
      axisTicks: { show: false },
    },
    yaxis: {
      min: 0,
      labels: {
        formatter: (value: number) => value.toFixed(0),
      },
    },
    legend: { show: false },
    tooltip: { theme: "dark" },
  };

  // Data series for chart based on monthlyData
  const assessmentData = {
    series: [
      {
        name: "Completed Assessments",
        data: monthlyData,
      },
    ],
  };

  return (
    <div className="rounded-lg dark:shadow-dark-md shadow-md bg-white dark:bg-darkgray p-6 w-full">
      <div className="flex justify-between items-center mb-4">
        <h5 className="text-lg font-semibold">Assessment Overview</h5>
        <Select
          id="years"
          className="select-md"
          value={selectedYear}
          onChange={(e) => setSelectedYear(Number(e.target.value))}
          required
        >
          {years.map((year) => (
            <option key={year} value={year}>
              {year}
            </option>
          ))}
        </Select>
      </div>
      <div className="overflow-hidden">
        <Chart
          options={optionsLineChart}
          series={assessmentData.series}
          type="line"
          height="315px"
          width="100%"
        />
      </div>
    </div>
  );
};

export default AssessmentOverview;
