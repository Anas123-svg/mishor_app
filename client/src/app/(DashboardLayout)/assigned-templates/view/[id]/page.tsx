"use client";
import React, { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { Template, Field, Table } from "@/types";
import axios from "axios";
import useAuthStore from "@/store/authStore";
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
} from "flowbite-react";

const ViewTemplate: React.FC = () => {
  const { id } = useParams();
  const { token } = useAuthStore();
  const [template, setTemplate] = useState<Template | null>(null);
  const [loading, setLoading] = useState<boolean>(true);

  const fetchTemplate = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/templates/${id}`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setTemplate(response.data);
    } catch (err) {
      console.log(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTemplate();
  }, []);

  if (loading)
    return (
      <div className="flex justify-center items-center w-full h-[80vh] text-primary">
        <Spinner size="xl" />
      </div>
    );
  if (!template) return <p>Template not found.</p>;

  return (
    <div className="space-y-6">
      <Card>
        <h1 className="text-2xl font-semibold">{template.name}</h1>
        <p className="text-gray-600">{template.description}</p>
        <p className="text-sm text-gray-500">Created by: Admin</p>
        <p className="text-sm text-gray-500">Reference: {template.Reference}</p>
        <p className="text-sm text-gray-500">
          Created on: {new Date(template.created_at).toLocaleDateString()}
        </p>
      </Card>

      <Card>
        {template.fields.map((field: Field) => (
          <div>
            <p className="text-lg font-semibold">
              {field.label}
              {field.attributes.required && (
                <span className="text-primary ml-1">*</span>
              )}{" "}
              ({field.type})
            </p>
            {(field.type === "text" || field.type === "number") && (
              <TextInput
                className="w-full mt-2"
                type={field.type}
                placeholder={field.attributes.placeholder || ""}
              />
            )}
            {field.type === "textarea" && (
              <Textarea
                rows={5}
                className="w-full mt-2"
                placeholder={field.attributes.placeholder || ""}
              />
            )}
            {field.type === "select" && (
              <Select className="w-full mt-2">
                {field.options.map((option) => (
                  <option key={option} value={option}>
                    {option}
                  </option>
                ))}
              </Select>
            )}
            {field.type === "radio" && (
              <div className="mt-2 flex flex-col gap-2">
                {field.options.map((option) => (
                  <label className="space-x-1">
                    <Radio name={field.label} value={option} />
                    <span>{option}</span>
                  </label>
                ))}
              </div>
            )}
            {field.type === "checkbox" && (
              <div className="mt-2 flex flex-col gap-2">
                {field.options.map((option) => (
                  <label className="space-x-1">
                    <Checkbox value={option} />
                    <span>{option}</span>
                  </label>
                ))}
              </div>
            )}
          </div>
        ))}
      </Card>

      {template.tables.length > 0 && (
        <Card>
          {template.tables.map((table: Table) => (
            <div className="overflow-x-auto overflow-y-hidden">
              <p className="text-lg font-semibold">{table.table_name}</p>
              <FlowTable hoverable className="border mt-2">
                <FlowTable.Head>
                  <FlowTable.HeadCell className="w-[300px] border-x"></FlowTable.HeadCell>
                  {table.table_data.columns.map((column) => (
                    <FlowTable.HeadCell className="border-x">
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
                      {Object.values(row).map(() => (
                        <FlowTable.Cell className="border-x"></FlowTable.Cell>
                      ))}
                    </FlowTable.Row>
                  ))}
                </FlowTable.Body>
              </FlowTable>
            </div>
          ))}
        </Card>
      )}
    </div>
  );
};

export default ViewTemplate;
