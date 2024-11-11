"use client";
import React from "react";
import dynamic from "next/dynamic";
import { Select } from "flowbite-react";

const Chart = dynamic(() => import("react-apexcharts"), { ssr: false });

const AssessmentOverview = () => {
  // Chart configuration for a single-line graph with a solid fill below the line
  const optionsLineChart: any = {
    chart: {
      type: "line", // Line chart type
      fontFamily: "inherit",
      foreColor: "#adb0bb",
      fontSize: "12px",
      offsetX: 0,
      offsetY: 10,
      animations: {
        speed: 500,
      },
      toolbar: {
        show: false,
      },
    },
    colors: ["var(--color-primary)"], // Primary color for the line
    dataLabels: {
      enabled: false, // Disabling data labels
    },
    fill: {
      type: "solid", // Set fill type to solid color
      opacity: 0.5, // Increase the opacity to make the shaded area more visible
    },
    grid: {
      show: true,
      strokeDashArray: 3,
      borderColor: "#90A4AE50",
    },
    stroke: {
      curve: "smooth", // Smooth curve for the line
      width: 2,
    },
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
      ], // Set months from Jan to Dec
      axisBorder: {
        show: false,
      },
      axisTicks: {
        show: false,
      },
    },
    yaxis: {
      min: 0,
      max: 100, // Adjust the range as needed
      tickAmount: 4, // Number of ticks on the y-axis
    },
    legend: {
      show: false, // Hide the legend
    },
    tooltip: {
      theme: "dark", // Tooltip dark theme
    },
  };

  // Single line data series representing completed assessments over time
  const assessmentData = {
    series: [
      {
        name: "Completed Assessments",
        data: [5, 15, 30, 45, 60, 70, 85, 90, 100, 100, 95, 85], // Example data for each month
      },
    ],
  };

  return (
    <div className="rounded-lg dark:shadow-dark-md shadow-md bg-white dark:bg-darkgray p-6 w-full">
      <div className="flex justify-between items-center mb-4">
        <h5 className="text-lg font-semibold">Assessment Overview</h5>
        <Select id="years" className="select-md" required>
          <option>2021</option>
          <option>2022</option>
          <option>2023</option>
          <option>2024</option>
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
