"use client";
import React, { useState } from "react";
import {
  Card,
  Badge,
  Button,
  Table,
  ListGroup,
  Modal,
  Select,
  TextInput,
  Label,
} from "flowbite-react";
import { Icon } from "@iconify/react";
import Image from "next/image";

const ClientDetails = () => {
  // Sample data for users and assessments
  const [clientUsers, setClientUsers] = useState([
    {
      id: 1,
      name: "Alice Johnson",
      email: "alice@example.com",
      profilePic: "/images/profile/user-2.jpg",
    },
    {
      id: 2,
      name: "Bob Smith",
      email: "bob@example.com",
      profilePic: "/images/profile/user-3.jpg",
    },
    {
      id: 3,
      name: "Charlie Brown",
      email: "charlie@example.com",
      profilePic: "/images/profile/user-1.jpg",
    },
  ]);

  const [clientAssessments, setClientAssessments] = useState([
    {
      id: 1,
      title: "Web Security Assessment",
      description: "Evaluation of web app security protocols",
      status: "Pending",
    },
    {
      id: 2,
      title: "UI/UX Review",
      description: "Assessment of user interface and experience",
      status: "Completed",
    },
    {
      id: 3,
      title: "Database Optimization",
      description: "Review and optimization of database performance",
      status: "In Progress",
    },
  ]);

  // State for modal control
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedTemplate, setSelectedTemplate] = useState("");
  const [selectedClient, setSelectedClient] = useState("");

  // Template options for select
  const templateOptions = [
    { value: "template1", label: "Template 1" },
    { value: "template2", label: "Template 2" },
    { value: "template3", label: "Template 3" },
  ];

  const handleAssignTemplate = () => {
    console.log(`Assigned ${selectedTemplate} to ${selectedClient}`);
    setIsModalOpen(false);
  };

  return (
    <div className="flex flex-col md:flex-row gap-6 p-6 bg-gray-100 dark:bg-darkgray rounded-lg shadow-md w-full">
      {/* Client Users Section */}
      <Card className="w-full md:w-1/2 p-6 h-fit">
        <h5 className="text-xl font-semibold mb-4">Client Users</h5>
        <ListGroup>
          {clientUsers.map((user) => (
            <ListGroup.Item key={user.id} className="flex items-center gap-4">
              <Image
                src={user.profilePic}
                alt={`${user.name}'s Profile`}
                width={50}
                height={50}
                className="rounded-full shadow-md"
              />
              <div className="flex-1">
                <h6 className="font-medium text-gray-800 dark:text-gray-200">
                  {user.name}
                </h6>
                <p className="text-sm text-gray-500 dark:text-gray-400">
                  {user.email}
                </p>
              </div>
            </ListGroup.Item>
          ))}
        </ListGroup>
      </Card>

      {/* Client Assessments Section */}
      <Card className="w-full md:w-1/2 p-6 h-fit">
        <div className="flex justify-between items-center mb-4">
          <h5 className="text-xl font-semibold">Assessments</h5>
          <Button
            color="primary"
            size="sm"
            className="flex items-center gap-2"
            onClick={() => setIsModalOpen(true)}
          >
            <Icon icon="solar:document-add-linear" />
            Assign New
          </Button>
        </div>
        <Table hoverable>
          <Table.Head>
            <Table.HeadCell>Title</Table.HeadCell>
            <Table.HeadCell>Status</Table.HeadCell>
            <Table.HeadCell>Action</Table.HeadCell>
          </Table.Head>
          <Table.Body className="divide-y">
            {clientAssessments.map((assessment) => (
              <Table.Row
                key={assessment.id}
                className="hover:bg-gray-100 dark:hover:bg-gray-800"
              >
                <Table.Cell>{assessment.title}</Table.Cell>
                <Table.Cell className="whitespace-nowrap">
                  <Badge
                    color={
                      assessment.status === "Completed"
                        ? "success"
                        : assessment.status === "In Progress"
                        ? "warning"
                        : "gray"
                    }
                  >
                    {assessment.status}
                  </Badge>
                </Table.Cell>
                <Table.Cell>
                  <Button
                    size="xs"
                    color="light"
                    className="flex items-center gap-2"
                  >
                    <Icon icon="solar:eye-outline" />
                    View
                  </Button>
                </Table.Cell>
              </Table.Row>
            ))}
          </Table.Body>
        </Table>
      </Card>

      {/* Modal to Assign Template */}
      <Modal show={isModalOpen} onClose={() => setIsModalOpen(false)}>
        <Modal.Header>Assign Template to Client</Modal.Header>
        <Modal.Body>
          <Label
            htmlFor="template"
            className="block text-sm font-medium text-gray-700 dark:text-gray-300"
          >
            Select Template
          </Label>
          <Select
            id="template"
            value={selectedTemplate}
            onChange={(e) => setSelectedTemplate(e.target.value)}
            className="mt-3 block w-full"
          >
            {templateOptions.map((template) => (
              <option key={template.value} value={template.value}>
                {template.label}
              </option>
            ))}
          </Select>
        </Modal.Body>
        <Modal.Footer>
          <Button color="primary" onClick={handleAssignTemplate}>
            Assign
          </Button>
          <Button color="secondary" onClick={() => setIsModalOpen(false)}>
            Cancel
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
};

export default ClientDetails;
