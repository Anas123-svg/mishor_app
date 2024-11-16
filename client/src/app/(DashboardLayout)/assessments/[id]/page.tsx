"use client";
import React, { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { Field, Table, Assessment } from "@/types";
import axios from "axios";
import useAuthStore from "@/store/authStore";
import Masonry, { ResponsiveMasonry } from "react-responsive-masonry";
import Zoom from "react-medium-image-zoom";
import "react-medium-image-zoom/dist/styles.css";
import {
  Card,
  Table as FlowTable,
  Badge,
  Select,
  Radio,
  Checkbox,
  Spinner,
  TextInput,
  Textarea,
  Label,
  Button,
} from "flowbite-react";
import toast from "react-hot-toast";

const ViewAssessment: React.FC = () => {
  const { id } = useParams();
  const { token } = useAuthStore();
  const [assessment, setAssessment] = useState<Assessment | null>(null);
  const [loading, setLoading] = useState<boolean>(true);

  const fetchTemplate = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/assessments/${id}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      console.log(response.data);
      setAssessment(response.data);
    } catch (err) {
      console.log(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTemplate();
  }, []);

  const approveAssessment = async () => {
    setLoading(true);
    try {
      await axios.put(
        `${process.env.NEXT_PUBLIC_API_URL}/assessments/${id}`,
        {
          status: "approved",
        },
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );
      toast.success("Assessment approved successfully.");
      fetchTemplate();
    } catch (err) {
      toast.error("Failed to approve assessment.");
      console.log(err);
    } finally {
      setLoading(false);
    }
  };

  const rejectAssessment = async () => {
    setLoading(true);
    try {
      await axios.put(
        `${process.env.NEXT_PUBLIC_API_URL}/assessments/${id}`,
        {
          status: "rejected",
        },
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );
      toast.success("Assessment rejected successfully.");
      fetchTemplate();
    } catch (err) {
      toast.error("Failed to reject assessment.");
      console.log(err);
    } finally {
      setLoading(false);
    }
  };

  if (loading)
    return (
      <div className="flex justify-center items-center w-full h-[80vh] text-primary">
        <Spinner aria-label="Loading assessment..." size="xl" />
      </div>
    );

  if (!assessment) return <p>Assessment not found.</p>;

  return (
    <div className="space-y-6">
      <Badge
        className="text-lg"
        color={
          assessment.status === "Approved"
            ? "success"
            : assessment.status === "Pending"
            ? "warning"
            : "failure"
        }
      >
        {assessment.status.charAt(0).toUpperCase() + assessment.status.slice(1)}
      </Badge>
      <Card className="flex gap-5">
        <Button
          onClick={rejectAssessment}
          disabled={loading}
          color="failure"
          className="w-full"
        >
          Reject
        </Button>
        <Button
          onClick={approveAssessment}
          disabled={loading}
          color="success"
          className="w-full"
        >
          Approve
        </Button>
      </Card>
      <Card>
        <h1 className="text-2xl font-semibold">{assessment.assessment.name}</h1>
        <p className="text-gray-600">{assessment.assessment.description}</p>
        <p className="text-sm text-gray-500">Created by: Admin</p>
        <p className="text-sm text-gray-500">
          Client Name: {assessment.client.name}
        </p>
        <p className="text-sm text-gray-500">
          User Name: {assessment.user.name}
        </p>
        <p className="text-sm text-gray-500">Created by: Admin</p>

        <p className="text-sm text-gray-500">
          Created on: {new Date(assessment.created_at).toLocaleDateString()}
        </p>
      </Card>

      <Card>
        {assessment.assessment.fields.map((field: Field, index) => (
          <div key={index}>
            <div className="flex items-center gap-5">
              <p className="text-lg font-semibold">
                {" "}
                {field.label}
                {field.attributes.required && (
                  <span className="text-primary ml-1">*</span>
                )}
              </p>{" "}
              {field.isFlagged ? (
                <Badge color="failure">Flagged by Admin</Badge>
              ) : null}
            </div>
            {(field.type === "text" || field.type === "number") && (
              <TextInput
                className="w-full mt-2"
                type={field.type}
                value={field.value}
                disabled
              />
            )}
            {field.type === "textarea" && (
              <Textarea
                rows={5}
                className="w-full mt-2"
                value={field.value}
                disabled
              />
            )}
            {field.type === "select" && (
              <Select className="w-full mt-2" disabled value={field.value}>
                {field.options.map((option, index) => (
                  <option key={index} value={option}>
                    {option}
                  </option>
                ))}
              </Select>
            )}
            {field.type === "radio" && (
              <div className="mt-2 flex flex-col gap-2">
                {field.options.map((option, index) => (
                  <label key={index} className="space-x-1">
                    <Radio
                      name={field.label}
                      value={option}
                      disabled
                      checked={field.value === option}
                    />
                    <span>{option}</span>
                  </label>
                ))}
              </div>
            )}
            {field.type === "checkbox" && (
              <div className="mt-2 flex flex-col gap-2">
                {field.options.map((option, index) => (
                  <label key={index} className="space-x-1">
                    <Checkbox
                      value={option}
                      disabled
                      checked={field.value.includes(option)}
                    />
                    <span>{option}</span>
                  </label>
                ))}
              </div>
            )}
          </div>
        ))}
      </Card>

      {assessment.assessment.tables &&
        assessment.assessment.tables.length > 0 && (
          <Card>
            {assessment.assessment.tables.map((table: Table, index) => (
              <div key={index} className="overflow-x-auto overflow-y-hidden">
                <p className="text-lg font-semibold">{table.table_name}</p>
                <FlowTable hoverable className="border mt-2">
                  <FlowTable.Head>
                    <FlowTable.HeadCell className="w-[300px] border-x"></FlowTable.HeadCell>
                    {table.table_data.columns.map((column, index) => (
                      <FlowTable.HeadCell key={index} className="border-x">
                        {column}
                      </FlowTable.HeadCell>
                    ))}
                  </FlowTable.Head>
                  <FlowTable.Body className="divide-y divide-border dark:divide-darkborder">
                    {Object.entries(table.table_data.rows).map(([key, row]) => (
                      <FlowTable.Row key={key}>
                        <FlowTable.Cell className="w-[300px] border-x font-semibold">
                          {key}
                        </FlowTable.Cell>
                        {Object.values(row).map((value, index) => (
                          <FlowTable.Cell key={index} className="border-x">
                            {value}
                          </FlowTable.Cell>
                        ))}
                      </FlowTable.Row>
                    ))}
                  </FlowTable.Body>
                </FlowTable>
              </div>
            ))}
          </Card>
        )}
      {assessment.site_images && assessment.site_images.length > 0 && (
        <Card>
          <p className="text-lg font-semibold mb-4">Site Images</p>
          <ResponsiveMasonry
            columnsCountBreakPoints={{ 350: 1, 750: 2, 900: 3 }}
          >
            <Masonry gutter="20px">
              {assessment.site_images.map((image, index) => (
                <Zoom key={index}>
                  <img
                    src={image}
                    alt={`Site Image ${index + 1}`}
                    className="w-full h-auto rounded-lg"
                  />
                </Zoom>
              ))}
            </Masonry>
          </ResponsiveMasonry>
        </Card>
      )}
      {assessment.feedback_by_admin && (
        <Card>
          <p className="text-lg font-semibold">Admin Feedback</p>
          <Textarea
            rows={10}
            className="w-full"
            placeholder="Write your feedback here..."
            value={assessment.feedback_by_admin || ""}
            disabled
          />
        </Card>
      )}
    </div>
  );
};

export default ViewAssessment;
