"use client";
import React, { useEffect, useState } from "react";
import {
  Card,
  Button,
  Table,
  Modal,
  Select,
  Label,
  Badge,
  Spinner,
} from "flowbite-react";
import { Icon } from "@iconify/react";
import { useParams } from "next/navigation";
import axios from "axios";
import { User, Template, Assessment } from "@/types";
import Link from "next/link";
import toast from "react-hot-toast";
import useAuthStore from "@/store/authStore";

const UserDetails = () => {
  const { id } = useParams();
  const [user, setUser] = useState<User>();
  const [templates, setTemplates] = useState<Template[]>([]);
  const [assessment, setAssessment] = useState<Assessment[]>([]);
  const [loading, setLoading] = useState(true);
  const { token } = useAuthStore();

  const fetchUserDetails = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/user/${id}`
      );
      setUser(response.data.user);
      setAssessment(response.data.assessments);
    } catch (error) {
      console.error(error);
    }
  };

  const fetchTemplates = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/client-templates/by-token/client`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      console.log(response.data);
      setTemplates(response.data.map((template: any) => template.template));
    } catch (error) {
      console.error(error);
    }
  };

  useEffect(() => {
    fetchUserDetails();
    fetchTemplates();
    setLoading(false);
  }, []);

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [selectedTemplate, setSelectedTemplate] = useState("");

  const handleAssignAssessment = async () => {
    try {
      const response = await axios.post(
        `${process.env.NEXT_PUBLIC_API_URL}/assessments`,
        {
          client_id: user?.client_id,
          user_id: id,
          template_id: selectedTemplate,
        }
      );
      toast.success(
        response.data.message || "Assessment assigned successfully"
      );
      setSelectedTemplate("");
      fetchUserDetails();
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
    <div className="p-2 sm:p-6 space-y-6 bg-gray-100 dark:bg-darkgray rounded-lg shadow-md w-full">
      <Card>
        <h5 className="text-xl font-semibold">User Details</h5>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <p className="text-sm font-semibold text-gray-600 dark:text-gray-300">
              Name
            </p>
            <p className="text-lg font-semibold">{user?.name}</p>
          </div>
          <div>
            <p className="text-sm font-semibold text-gray-600 dark:text-gray-300">
              Email
            </p>
            <p className="text-lg font-semibold">{user?.email}</p>
          </div>
          <div>
            <p className="text-sm font-semibold text-gray-600 dark:text-gray-300">
              Phone
            </p>
            <p className="text-lg font-semibold">{user?.phone}</p>
          </div>
          <div className="flex items-center">
            <Badge
              color={user?.is_verified ? "success" : "warning"}
              className="text-md"
            >
              {user?.is_verified ? "Verified" : "Not Verified"}
            </Badge>
          </div>
        </div>
      </Card>
      <Card>
        <div className="flex  flex-col sm:flex-row justify-between gap-4 sm:gap-0 sm:items-center mb-4">
          <h5 className="text-xl font-semibold">Assigned Assessments</h5>
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
            {assessment.map((assessment) => (
              <Table.Row
                key={assessment.id}
                className="hover:bg-gray-100 dark:hover:bg-gray-800"
              >
                <Table.Cell className="w-full">
                  {assessment.assessment.name}
                </Table.Cell>
                <Table.Cell>
                  <Button
                    as={Link}
                    href={`/assessments/view/${assessment.assessment.id}`}
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
        <Modal.Header>Assign Assessment to User</Modal.Header>
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
          <Button color="primary" onClick={handleAssignAssessment}>
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

export default UserDetails;
