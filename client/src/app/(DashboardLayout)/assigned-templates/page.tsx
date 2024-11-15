"use client";
import React, { useEffect, useState } from "react";
import { Badge, Dropdown, TextInput } from "flowbite-react";
import { HiOutlineDotsVertical } from "react-icons/hi";
import { Icon } from "@iconify/react";
import { Table } from "flowbite-react";
import axios from "axios";
import { Template } from "@/types";
import useAuthStore from "@/store/authStore";
import Link from "next/link";

const TemplatePage = () => {
  const [templates, setTemplates] = useState<Template[]>([]);
  const { token } = useAuthStore();
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
      setTemplates(response.data.map((template: any) => template.template));
    } catch (err) {
      console.log(err);
    }
  };

  useEffect(() => {
    fetchTemplates();
  }, []);

  const [searchTerm, setSearchTerm] = useState("");

  return (
    <>
      <div className="rounded-lg dark:shadow-dark-md shadow-md bg-white dark:bg-darkgray p-6 relative w-full break-words">
        <h5 className="card-title mb-4">Assigned Templates</h5>
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
                          href={`/assigned-templates/view/${item.id}`}
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
