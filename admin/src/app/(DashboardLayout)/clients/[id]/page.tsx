"use client";
import React, { useEffect, useState } from "react";
import {
  Card,
  Badge,
  Button,
  Table,
  ListGroup,
  Modal,
  Select,
  Label,
} from "flowbite-react";
import { Icon } from "@iconify/react";
import Image from "next/image";
import { useParams } from "next/navigation";
import axios from "axios";
import { Client, Template } from "@/types";
import Link from "next/link";
import toast from "react-hot-toast";

const ClientDetails = () => {
  const { id } = useParams();
  const [client, setClient] = useState<Client>();
  const [templates, setTemplates] = useState<Template[]>([]);

  const fetchClientDetails = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/client/${id}`
      );
      setClient(response.data);
      console.log(response.data);
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

  useEffect(() => {
    fetchClientDetails();
    fetchTemplates();
  }, []);

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedTemplate, setSelectedTemplate] = useState("");

  const handleAssignTemplate = async () => {
    try {
      const response = await axios.post(
        `${process.env.NEXT_PUBLIC_API_URL}/client-templates`,
        {
          client_id: id,
          template_id: selectedTemplate,
        }
      );
      toast.success(response.data.message || "Template assigned successfully");
      setSelectedTemplate("");
      fetchClientDetails();
      setIsModalOpen(false);
    } catch (error: any) {
      console.error(error);
      toast.error(error.response.data.message || "Something went wrong");
    }
  };

  return (
    <div className="p-2 sm:p-6 bg-gray-100 dark:bg-darkgray rounded-lg shadow-md w-full">
      <Card className="w-full h-fit">
        <div className="flex flex-col md:flex-row items-center gap-6">
          <div className="w-24 h-24 relative rounded-full overflow-hidden">
            <img
              src={client?.profile_image}
              alt="Client Avatar"
              className="w-full h-full object-cover"
            />
          </div>
          <div className="flex-1 space-y-1">
            <h5 className="text-2xl font-semibold">{client?.name}</h5>
            <p className="text-sm text-gray-500 dark:text-gray-400">
              {client?.email}
            </p>
            <Badge color={client?.is_verified ? "success" : "warning"}>
              {client?.is_verified ? "Verified" : "Not Verified"}
            </Badge>
          </div>
        </div>
      </Card>
      <div className="mt-6 flex flex-col md:flex-row gap-6 ">
        <Card className="w-full md:w-1/2 h-fit">
          <h5 className="text-xl font-semibold mb-4">Client Users</h5>
          <ListGroup>
            {client?.users?.map((user) => (
              <ListGroup.Item key={user.id} className="flex items-center gap-4">
                <div className="flex-1 space-y-1">
                  <h6 className="font-medium text-gray-800 dark:text-gray-200">
                    {user.name}
                  </h6>
                  <p className="text-sm text-gray-500 dark:text-gray-400">
                    {user.email}
                  </p>
                  <p className="text-sm text-gray-500 dark:text-gray-400">
                    {user.phone}
                  </p>
                </div>
              </ListGroup.Item>
            ))}
          </ListGroup>
        </Card>

        {/* Client Assessments Section */}
        <Card className="w-full md:w-1/2 h-fit">
          <div className="flex  flex-col sm:flex-row justify-between gap-4 sm:gap-0 sm:items-center mb-4">
            <h5 className="text-xl font-semibold">Assigned Templates</h5>
            <Button
              color="primary"
              size="sm"
              className="flex items-center gap-2 w-fit"
              onClick={() => setIsModalOpen(true)}
            >
              <Icon icon="solar:document-add-linear" />
              Assign New
            </Button>
          </div>
          <Table hoverable>
            <Table.Head>
              <Table.HeadCell className="w-full">Title</Table.HeadCell>
              <Table.HeadCell>Action</Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y">
              {client?.client_template.map((template) => (
                <Table.Row
                  key={template.template_id}
                  className="hover:bg-gray-100 dark:hover:bg-gray-800"
                >
                  <Table.Cell className="w-full">
                    {template.template.name}
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      as={Link}
                      href={`/templates/view/${template.template_id}`}
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
      </div>

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
            <option value="">Select Template</option>
            {templates.map((template) => (
              <option key={template.id} value={template.id}>
                {template.name}
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
