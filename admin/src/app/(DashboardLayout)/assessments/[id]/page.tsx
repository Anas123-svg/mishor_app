"use client";
import React from "react";
import { Card, Table, Button } from "flowbite-react";
import { Icon } from "@iconify/react";
import Image from "next/image";

// Define types for the structure
interface Field {
  id: number;
  label: string;
  type: string;
  value: string | null;
  attributes?: string[] | { label: string; checked: boolean }[]; // Can be an array of strings or objects with label and checked
}

interface TableData {
  id: number;
  template_id: number;
  table_name: string;
  table_data: {
    columns: string[];
    rows: {
      [key: string]: {
        [key: string]: string | { label: string; checked: boolean };
      };
    };
  };
}

interface AssessmentDetails {
  id: number;
  client_id: number;
  template_id: number;
  user_id: number;
  assessment: {
    id: number;
    name: string;
    description: string;
    Reference: string | null;
    Assessor: string | null;
    Date: string | null;
    fields: Field[];
    tables: TableData[];
  };
  status: string;
  client: {
    id: number;
    name: string;
    email: string;
    profile_image: string;
  };
  template: {
    id: number;
    name: string;
    description: string;
  };
  user: {
    id: number;
    client_id: number;
    name: string;
    email: string;
  };
}

const AssessmentDetails: React.FC = () => {
  const assessment: AssessmentDetails = {
    id: 2,
    client_id: 3,
    template_id: 14,
    user_id: 4,
    assessment: {
      id: 14,
      name: "Sample Template Updated",
      description:
        "This is a test template with updated named rows and multiple field types.",
      Reference: "fdsfsddfsfd",
      Assessor: "sfdfd",
      Date: "sfdfsd",
      fields: [
        {
          id: 35,
          label: "Field2",
          type: "text",
          value: "updated text",
        },
        {
          id: 36,
          label: "Field4",
          type: "radio",
          attributes: ["Option1", "Option2", "Option3"],
          value: "Option2",
        },
        {
          id: 37,
          label: "Field5",
          type: "dropdown",
          attributes: ["Choice1", "Choice2", "Choice3"],
          value: "Choice1",
        },
        {
          id: 38,
          label: "ChecklistField",
          type: "checklist",
          attributes: [
            { label: "Item1", checked: true },
            { label: "Item2", checked: false },
            { label: "Item3", checked: false },
          ],
          value: null,
        },
      ],
      tables: [
        {
          id: 14,
          template_id: 14,
          table_name: "Meeting Schedule Updated",
          table_data: {
            columns: ["Session", "Date", "Time", "Topic"],
            rows: {
              "Session 1": {
                Session: "Session 1",
                Date: "updated date",
                Time: "updated time",
                Topic: "updated topic",
              },
              "Session 2": {
                Session: "Session 2",
                Date: "updated date",
                Time: "updated time",
                Topic: "updated topic",
              },
              "Session 3": {
                Session: "Session 3",
                Date: "updated date",
                Time: "updated time",
                Topic: "updated topic",
              },
            },
          },
        },
        {
          id: 15,
          template_id: 14,
          table_name: "Feedback Details Updated",
          table_data: {
            columns: ["Feedback ID", "Submitted By", "Date"],
            rows: {
              "Feedback 1": {
                "Feedback ID": "updated",
                "Submitted By": "updated",
                Date: "updated",
              },
              "Feedback 2": {
                "Feedback ID": "approved updated",
                "Submitted By": "approved updated",
                Date: "approved updated",
              },
            },
          },
        },
      ],
    },
    status: "rejected",
    client: {
      id: 3,
      name: "Anas",
      email: "anas@gmail.com",
      profile_image: "fafas",
    },
    template: {
      id: 14,
      name: "Sample Template",
      description:
        "This is a test template with named rows and multiple field types.",
    },
    user: {
      id: 4,
      client_id: 3,
      name: "John Doe",
      email: "johdzfasddsfdndoe@example.com",
    },
  };

  return (
    <div className="p-8 bg-gray-100 dark:bg-darkgray rounded-xl space-y-8">
      {/* Client Information */}
      <Card className="p-6 shadow-sm bg-white rounded-xl">
        <h5 className="text-2xl font-semibold mb-4">Client Information</h5>
        <div className="flex items-center gap-6">
          <Image
            src={`/images/profile/${assessment.client.profile_image}.jpg`}
            alt={`${assessment.client.name}'s Profile`}
            width={60}
            height={60}
            className="rounded-full border-2 border-gray-300"
          />
          <div>
            <h6 className="font-medium text-xl text-gray-800">
              {assessment.client.name}
            </h6>
            <p className="text-md text-gray-500">{assessment.client.email}</p>
          </div>
        </div>
      </Card>

      {/* Assessment Template Details */}
      <Card className="p-6 shadow-sm bg-white rounded-xl">
        <h5 className="text-2xl font-semibold mb-4">Assessment Details</h5>
        <p>
          <strong>Title:</strong> {assessment.assessment.name}
        </p>
        <p>
          <strong>Description:</strong> {assessment.assessment.description}
        </p>
        <p>
          <strong>Reference:</strong> {assessment.assessment.Reference}
        </p>
        <p>
          <strong>Assessor:</strong> {assessment.assessment.Assessor}
        </p>
        <p>
          <strong>Date:</strong> {assessment.assessment.Date}
        </p>
      </Card>

      {/* Fields Information */}
      <Card className="p-6 shadow-sm bg-white rounded-xl">
        <h5 className="text-2xl font-semibold mb-4">Fields</h5>
        <Table hoverable>
          <Table.Head>
            <Table.HeadCell>Label</Table.HeadCell>
            <Table.HeadCell>Value</Table.HeadCell>
          </Table.Head>
          <Table.Body className="divide-y">
            {assessment.assessment.fields.map((field) => (
              <Table.Row key={field.id}>
                <Table.Cell>{field.label}</Table.Cell>
                <Table.Cell>
                  {field.type === "checklist" ? (
                    <ul className="list-disc ml-6">
                      {Array.isArray(field.attributes) &&
                        field.attributes.map((item, index) =>
                          typeof item === "string" ? (
                            <li key={index} className="text-gray-700">
                              {item}
                            </li>
                          ) : (
                            <li
                              key={index}
                              className={`${
                                item.checked
                                  ? "text-green-500"
                                  : "text-gray-500"
                              }`}
                            >
                              {item.label}{" "}
                              {item.checked && (
                                <Icon icon="solar:checkmark-circle-line" />
                              )}
                            </li>
                          )
                        )}
                    </ul>
                  ) : (
                    field.value || (
                      <span className="text-gray-500">No Value</span>
                    )
                  )}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table.Body>
        </Table>
      </Card>

      {/* Tables Information */}
      {assessment.assessment.tables.map((table) => (
        <Card key={table.id} className="p-6 shadow-sm bg-white rounded-xl">
          <h5 className="text-2xl font-semibold mb-4">{table.table_name}</h5>
          <Table hoverable>
            <Table.Head>
              {table.table_data.columns.map((column, idx) => (
                <Table.HeadCell key={idx}>{column}</Table.HeadCell>
              ))}
            </Table.Head>
            <Table.Body className="divide-y">
              {Object.keys(table.table_data.rows).map((rowKey) => (
                <Table.Row key={rowKey}>
                  {table.table_data.columns.map((column, idx) => (
                    <Table.Cell key={idx}>
                      {typeof table.table_data.rows[rowKey][column] === "string"
                        ? table.table_data.rows[rowKey][column]
                        : "Updated Value"}
                    </Table.Cell>
                  ))}
                </Table.Row>
              ))}
            </Table.Body>
          </Table>
        </Card>
      ))}

      {/* Buttons for Approval/Rejection */}
      <div className="flex gap-4 justify-center mt-6">
        <Button color="success" size="lg" className="w-1/3">
          Approve
        </Button>
        <Button color="failure" size="lg" className="w-1/3">
          Reject
        </Button>
      </div>
    </div>
  );
};

export default AssessmentDetails;
