"use client";
import React, { useEffect, useState } from "react";
import {
  Badge,
  Dropdown,
  Modal,
  Button,
  TextInput,
  Select,
  Table,
  Spinner,
} from "flowbite-react";
import { HiOutlineDotsVertical } from "react-icons/hi";
import { Icon } from "@iconify/react";
import axios from "axios";
import { Assessment, Client, Template } from "@/types";
import Link from "next/link";
import toast from "react-hot-toast";

const Assessments = () => {
  const [search, setSearch] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedTemplate, setSelectedTemplate] = useState("");
  const [selectedClient, setSelectedClient] = useState("");
  const [assessments, setAssessments] = useState<Assessment[]>([]);
  const [templates, setTemplates] = useState<Template[]>([]);
  const [clients, setClients] = useState<Client[]>([]);
  const [loading, setLoading] = useState(true);
  const fetchAssessments = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/assessments/completed-by-user`
      );
      setAssessments(response.data);
    } catch (error) {
      console.error(error);
    }
  };

  const fetchTemplates = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/templates`
      );
      setTemplates(response.data);
    } catch (error) {
      console.error(error);
    }
  };

  const fetchClients = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/client`
      );
      setClients(response.data);
    } catch (error) {
      console.error(error);
    }
  };

  useEffect(() => {
    fetchAssessments();
    fetchTemplates();
    fetchClients();
    setLoading(false);
  }, []);

  const handleAssignTemplate = async () => {
    try {
      const response = await axios.post(
        `${process.env.NEXT_PUBLIC_API_URL}/client-templates`,
        {
          client_id: selectedClient,
          template_id: selectedTemplate,
        }
      );
      toast.success(response.data.message || "Template assigned successfully");
      setSelectedTemplate("");
      setSelectedClient("");
      fetchAssessments();
      setIsModalOpen(false);
    } catch (error: any) {
      console.error(error);
      toast.error(error.response.data.message || "Something went wrong");
    }
  };

  return loading ? (
    <div className="flex justify-center items-center w-full h-[80vh] text-primary">
      <Spinner size="xl" />
    </div>
  ) : (
    <>
      <div className="rounded-lg shadow-md bg-white dark:bg-darkgray p-6 w-full">
        <div className="flex flex-col sm:flex-row gap-4 sm:gap-0 justify-between sm:items-center mb-4">
          <h5 className="text-xl font-semibold">Assessments</h5>
          <Button
            color="primary"
            onClick={() => setIsModalOpen(true)}
            className="w-fit"
          >
            Assign Template
          </Button>
        </div>

        <TextInput
          placeholder="Search Assessments"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="mb-3"
        />

        <div className="overflow-x-auto">
          <Table hoverable>
            <Table.Head>
              <Table.HeadCell>Title</Table.HeadCell>
              <Table.HeadCell>Description</Table.HeadCell>
              <Table.HeadCell>Client</Table.HeadCell>
              <Table.HeadCell>Status By Client</Table.HeadCell>
              <Table.HeadCell>Status By Admin</Table.HeadCell>
              <Table.HeadCell>Actions</Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y">
              {assessments
                .filter(
                  (assessment) =>
                    assessment.assessment.name
                      .toLowerCase()
                      .includes(search.toLowerCase()) ||
                    assessment.client.name
                      .toLowerCase()
                      .includes(search.toLowerCase()) ||
                    assessment.assessment.description
                      .toLowerCase()
                      .includes(search.toLowerCase())
                )
                .map((assessment, index) => (
                  <Table.Row
                    key={index}
                    className="hover:bg-gray-100 dark:hover:bg-gray-900"
                  >
                    <Table.Cell className="font-medium">
                      {assessment.assessment.name}
                    </Table.Cell>
                    <Table.Cell className="text-gray-500">
                      {assessment.assessment.description}
                    </Table.Cell>
                    <Table.Cell>{assessment.client.name}</Table.Cell>
                    <Table.Cell className="whitespace-nowrap">
                      <Badge
                        color={
                          assessment.status === "Approved"
                            ? "success"
                            : assessment.status === "Pending"
                            ? "warning"
                            : "failure"
                        }
                      >
                        {assessment.status.charAt(0).toUpperCase() +
                          assessment.status.slice(1)}
                      </Badge>
                    </Table.Cell>
                    <Table.Cell className="whitespace-nowrap">
                      <Badge
                        color={
                          assessment.status_by_admin === "approved"
                            ? "success"
                            : assessment.status_by_admin === "pending"
                            ? "warning"
                            : "failure"
                        }
                      >
                        {assessment.status_by_admin.charAt(0).toUpperCase() +
                          assessment.status_by_admin.slice(1)}
                      </Badge>
                    </Table.Cell>
                    <Table.Cell>
                      <Dropdown
                        label=""
                        placement="left"
                        dismissOnClick={false}
                        renderTrigger={() => (
                          <span className="h-9 w-9 flex justify-center items-center rounded-full hover:bg-lightprimary hover:text-primary cursor-pointer">
                            <HiOutlineDotsVertical size={22} />
                          </span>
                        )}
                      >
                        <Dropdown.Item
                          as={Link}
                          href={`/assessments/${assessment.id}`}
                          className="flex gap-3"
                        >
                          <Icon icon="solar:eye-outline" height={18} />
                          <span>View Assessment</span>
                        </Dropdown.Item>
                      </Dropdown>
                    </Table.Cell>
                  </Table.Row>
                ))}
            </Table.Body>
          </Table>
          {assessments.length === 0 ? (
            <p className="text-center mt-5">No assessments found</p>
          ) : assessments.filter(
              (assessment) =>
                assessment.assessment.name
                  .toLowerCase()
                  .includes(search.toLowerCase()) ||
                assessment.client.name
                  .toLowerCase()
                  .includes(search.toLowerCase()) ||
                assessment.assessment.description
                  .toLowerCase()
                  .includes(search.toLowerCase())
            ).length === 0 ? (
            <p className="text-center mt-5">No assessments found</p>
          ) : null}
        </div>
      </div>

      {/* Assign Template Modal */}
      <Modal show={isModalOpen} onClose={() => setIsModalOpen(false)}>
        <Modal.Header>Assign Template</Modal.Header>
        <Modal.Body>
          <Select
            value={selectedTemplate}
            onChange={(e) => setSelectedTemplate(e.target.value)}
            className="mb-4"
          >
            <option value="" disabled>
              Select Template
            </option>
            {templates.map((template) => (
              <option key={template.id} value={template.id}>
                {template.name}
              </option>
            ))}
          </Select>
          <Select
            value={selectedClient}
            onChange={(e) => setSelectedClient(e.target.value)}
            className="mb-4"
          >
            <option value="" disabled>
              Select Client
            </option>
            {clients.map((client) => (
              <option key={client.id} value={client.id}>
                {client.name}
              </option>
            ))}
          </Select>
        </Modal.Body>
        <Modal.Footer>
          <Button color="primary" onClick={handleAssignTemplate}>
            Assign Template
          </Button>
          <Button color="secondary" onClick={() => setIsModalOpen(false)}>
            Cancel
          </Button>
        </Modal.Footer>
      </Modal>
    </>
  );
};

export default Assessments;
