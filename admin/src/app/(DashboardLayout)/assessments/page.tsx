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
} from "flowbite-react";
import { HiOutlineDotsVertical } from "react-icons/hi";
import { Icon } from "@iconify/react";
import axios from "axios";

const Assessments = () => {
  const [search, setSearch] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedTemplate, setSelectedTemplate] = useState("");
  const [selectedClient, setSelectedClient] = useState("");
  const fetchAssessments = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/assessments`
      );
    } catch (error) {
      console.error(error);
    }
  };

  useEffect(() => {
    fetchAssessments();
  }, []);

  const [assessments, setAssessments] = useState([
    {
      title: "Risk Analysis",
      description: "Assessment of potential risks",
      client: "Company A",
      status: "completed",
    },
    {
      title: "Compliance Check",
      description: "Regulatory compliance assessment",
      client: "Company B",
      status: "pending",
    },
    {
      title: "Security Review",
      description: "Comprehensive security assessment",
      client: "Company C",
      status: "in-progress",
    },
  ]);

  const actionOptions = [
    { icon: "solar:eye-outline", label: "View Assessment" },
  ];

  const handleAssignTemplate = () => {
    // Logic for assigning template to a client
    setIsModalOpen(false);
  };

  return (
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
              <Table.HeadCell>Status</Table.HeadCell>
              <Table.HeadCell>Actions</Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y">
              {assessments
                .filter(
                  (assessment) =>
                    assessment.title
                      .toLowerCase()
                      .includes(search.toLowerCase()) ||
                    assessment.client
                      .toLowerCase()
                      .includes(search.toLowerCase())
                )
                .map((assessment, index) => (
                  <Table.Row
                    key={index}
                    className="hover:bg-gray-100 dark:hover:bg-gray-900"
                  >
                    <Table.Cell className="font-medium">
                      {assessment.title}
                    </Table.Cell>
                    <Table.Cell className="text-gray-500">
                      {assessment.description}
                    </Table.Cell>
                    <Table.Cell>{assessment.client}</Table.Cell>
                    <Table.Cell className="whitespace-nowrap">
                      <Badge
                        color={
                          assessment.status === "completed"
                            ? "success"
                            : assessment.status === "pending"
                            ? "warning"
                            : "failure"
                        }
                      >
                        {assessment.status.charAt(0).toUpperCase() +
                          assessment.status.slice(1)}
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
                        {actionOptions.map((action, i) => (
                          <Dropdown.Item key={i} className="flex gap-3">
                            <Icon icon={action.icon} height={18} />
                            <span>{action.label}</span>
                          </Dropdown.Item>
                        ))}
                      </Dropdown>
                    </Table.Cell>
                  </Table.Row>
                ))}
            </Table.Body>
          </Table>
          {assessments.length === 0 ||
            (assessments.filter(
              (assessment) =>
                assessment.title.toLowerCase().includes(search.toLowerCase()) ||
                assessment.description
                  .toLowerCase()
                  .includes(search.toLowerCase())
            ).length === 0 && (
              <p className="text-center mt-5">No assessments found</p>
            ))}
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
            <option value="template1">Template 1</option>
            <option value="template2">Template 2</option>
            <option value="template3">Template 3</option>
          </Select>
          <Select
            value={selectedClient}
            onChange={(e) => setSelectedClient(e.target.value)}
            className="mb-4"
          >
            <option value="" disabled>
              Select Client
            </option>
            <option value="Company A">Company A</option>
            <option value="Company B">Company B</option>
            <option value="Company C">Company C</option>
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
