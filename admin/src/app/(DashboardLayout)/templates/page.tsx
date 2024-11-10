"use client";
import React, { useState } from "react";
import { Badge, Dropdown, TextInput } from "flowbite-react";
import { HiOutlineDotsVertical } from "react-icons/hi";
import { Icon } from "@iconify/react";
import { Table } from "flowbite-react";
import Link from "next/link";

const TemplatePage = () => {
  // Initial data for templates
  const TemplateTableData = [
    {
      title: "Marketing Campaign",
      description: "A comprehensive template for marketing campaigns.",
      createdBy: "John Doe",
    },
    {
      title: "Project Plan",
      description: "Template for project planning and management.",
      createdBy: "Jane Smith",
    },
    {
      title: "Sales Report",
      description: "Detailed template for monthly sales reporting.",
      createdBy: "Alice Johnson",
    },
  ];

  // State to store search input and filtered data
  const [searchTerm, setSearchTerm] = useState("");
  const [filteredData, setFilteredData] = useState(TemplateTableData);

  // Handle search input change
  const handleSearchChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    setSearchTerm(value);

    // Filter data based on search term
    const filteredTemplates = TemplateTableData.filter((template) =>
      template.title.toLowerCase().includes(value.toLowerCase())
    );

    setFilteredData(filteredTemplates);
  };

  // Action options
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
          onChange={handleSearchChange}
          className="mb-3"
        />
        <div className="overflow-x-auto">
          <Table hoverable>
            <Table.Head>
              <Table.HeadCell className="p-6">Title</Table.HeadCell>
              <Table.HeadCell>Description</Table.HeadCell>
              <Table.HeadCell>Created By</Table.HeadCell>
              <Table.HeadCell></Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y divide-border dark:divide-darkborder">
              {filteredData.length > 0 ? (
                filteredData.map((item, index) => (
                  <Table.Row key={index}>
                    <Table.Cell className="whitespace-nowrap ps-6">
                      <h6 className="text-sm">{item.title}</h6>
                    </Table.Cell>
                    <Table.Cell>
                      <p className="text-sm text-wrap">{item.description}</p>
                    </Table.Cell>
                    <Table.Cell>
                      <Badge color="success">{item.createdBy}</Badge>
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
                ))
              ) : (
                <Table.Row>
                  <Table.Cell colSpan={4} className="text-center py-4">
                    No templates found
                  </Table.Cell>
                </Table.Row>
              )}
            </Table.Body>
          </Table>
        </div>
      </div>
    </>
  );
};

export default TemplatePage;
