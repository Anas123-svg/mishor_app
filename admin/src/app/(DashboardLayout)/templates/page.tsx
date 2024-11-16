"use client";
import React, { useEffect, useState } from "react";
import { Badge, Dropdown, Spinner, TextInput } from "flowbite-react";
import { HiOutlineDotsVertical } from "react-icons/hi";
import { Icon } from "@iconify/react";
import { Table } from "flowbite-react";
import axios from "axios";
import { Template } from "@/types";
import useAuthStore from "@/store/authStore";
import Link from "next/link";
import toast from "react-hot-toast";

const TemplatePage = () => {
  const [templates, setTemplates] = useState<Template[]>([]);
  const [loading, setLoading] = useState(false);
  const { token } = useAuthStore();
  const fetchTemplates = async () => {
    setLoading(true);
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/templates`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setTemplates(response.data);
    } catch (err) {
      console.log(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchTemplates();
  }, []);

  const [searchTerm, setSearchTerm] = useState("");

  const handleDelete = (id: number) => async () => {
    if (!window.confirm("Are you sure you want to delete this template?")) {
      return;
    }
    try {
      await axios.delete(`${process.env.NEXT_PUBLIC_API_URL}/templates/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success("Template deleted successfully");
      fetchTemplates();
    } catch (err) {
      toast.error("Failed to delete template");
      console.log(err);
    }
  };

  return loading ? (
    <div className="flex justify-center items-center w-full h-[80vh] text-primary">
      <Spinner size="xl" />
    </div>
  ) : (
    <>
      <div className="rounded-lg dark:shadow-dark-md shadow-md bg-white dark:bg-darkgray p-6 relative w-full break-words">
        <div className="flex justify-between items-center mb-4">
          <h5 className="card-title">Templates</h5>
          <Link
            href="/templates/add-template"
            className="bg-primary text-white px-4 py-2.5 font-medium rounded-full"
          >
            Add Template
          </Link>
        </div>
        <TextInput
          placeholder="Search Templates"
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="mb-3"
        />
        <div className="overflow-x-auto">
          <Table hoverable>
            <Table.Head>
              <Table.HeadCell className="p-6">Name</Table.HeadCell>
              <Table.HeadCell className="max-w-lg">Description</Table.HeadCell>
              <Table.HeadCell className="whitespace-nowrap">
                Created By
              </Table.HeadCell>
              <Table.HeadCell></Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y divide-border dark:divide-darkborder">
              {templates
                .filter(
                  (template) =>
                    template.name
                      .toLowerCase()
                      .includes(searchTerm.toLowerCase()) ||
                    template.description
                      .toLowerCase()
                      .includes(searchTerm.toLowerCase())
                )
                .map((item, index) => (
                  <Table.Row key={index}>
                    <Table.Cell className="ps-6">
                      <h6 className="text-sm">{item.name}</h6>
                    </Table.Cell>
                    <Table.Cell>
                      <p className="text-sm max-w-lg shrink-0 line-clamp-2">
                        {item.description}
                      </p>
                    </Table.Cell>
                    <Table.Cell>
                      <Badge color="success">Admin</Badge>
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
                          href={`/templates/edit/${item.id}`}
                          key={index}
                          className="flex gap-3"
                        >
                          <Icon
                            icon="solar:pen-new-square-broken"
                            height={18}
                          />
                          <span>Edit</span>
                        </Dropdown.Item>
                        <Dropdown.Item
                          as="button"
                          className="flex gap-3"
                          onClick={handleDelete(item.id)}
                        >
                          <Icon
                            icon="solar:trash-bin-minimalistic-outline"
                            height={18}
                          />
                          <span>Delete</span>
                        </Dropdown.Item>
                        <Dropdown.Item
                          as={Link}
                          href={`/templates/view/${item.id}`}
                          key={index}
                          className="flex gap-3"
                        >
                          <Icon icon="solar:eye-outline" height={18} />
                          <span>View</span>
                        </Dropdown.Item>
                      </Dropdown>
                    </Table.Cell>
                  </Table.Row>
                ))}
            </Table.Body>
          </Table>
          {templates.length === 0 ? (
            <p className="text-center mt-5">No Templates Found</p>
          ) : templates.filter(
              (template) =>
                template.name
                  .toLowerCase()
                  .includes(searchTerm.toLowerCase()) ||
                template.description
                  .toLowerCase()
                  .includes(searchTerm.toLowerCase())
            ).length === 0 ? (
            <p className="text-center mt-5">No Templates Found</p>
          ) : null}
        </div>
      </div>
    </>
  );
};

export default TemplatePage;
