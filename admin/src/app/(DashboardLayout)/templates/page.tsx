"use client";
import React, { useEffect, useState } from "react";
import { Badge, Dropdown, TextInput } from "flowbite-react";
import { HiOutlineDotsVertical } from "react-icons/hi";
import { Icon } from "@iconify/react";
import { Table } from "flowbite-react";
import Link from "next/link";
import axios from "axios";
import { Template } from "@/types";
import useAuthStore from "@/store/authStore";

const TemplatePage = () => {
  const [templates, setTemplates] = useState<Template[]>([]);
  const { token } = useAuthStore();
  const fetchTemplates = async () => {
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
    }
  };

  useEffect(() => {
    fetchTemplates();
  }, []);

  const [searchTerm, setSearchTerm] = useState("");

  const tableActionData = [
    {
      icon: "solar:pen-new-square-broken",
      listtitle: "Edit",
    },
    {
      icon: "solar:trash-bin-minimalistic-outline",
      listtitle: "Delete",
    },
  ];

  return (
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
              <Table.HeadCell>Description</Table.HeadCell>
              <Table.HeadCell>Created By</Table.HeadCell>
              <Table.HeadCell></Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y divide-border dark:divide-darkborder whitespace-nowrap">
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
                    <Table.Cell className="whitespace-nowrap ps-6">
                      <h6 className="text-sm">{item.name}</h6>
                    </Table.Cell>
                    <Table.Cell>
                      <p className="text-sm text-wrap">{item.description}</p>
                    </Table.Cell>
                    <Table.Cell>
                      <Badge color="success">{item.created_by}</Badge>
                    </Table.Cell>
                    <Table.Cell>
                      <Dropdown
                        label=""
                        dismissOnClick={false}
                        renderTrigger={() => (
                          <span className="h-9 w-9 flex justify-center items-center rounded-full hover:bg-lightprimary hover:text-primary cursor-pointer">
                            <HiOutlineDotsVertical size={22} />
                          </span>
                        )}
                      >
                        {tableActionData.map((action, index) => (
                          <Dropdown.Item key={index} className="flex gap-3">
                            <Icon icon={action.icon} height={18} />
                            <span>{action.listtitle}</span>
                          </Dropdown.Item>
                        ))}
                      </Dropdown>
                    </Table.Cell>
                  </Table.Row>
                ))}
            </Table.Body>
          </Table>
          {templates.length === 0 ||
            (templates.filter(
              (template) =>
                template.name
                  .toLowerCase()
                  .includes(searchTerm.toLowerCase()) ||
                template.description
                  .toLowerCase()
                  .includes(searchTerm.toLowerCase())
            ).length === 0 && (
              <p className="text-center mt-5">No Templates Found</p>
            ))}
        </div>
      </div>
    </>
  );
};

export default TemplatePage;
