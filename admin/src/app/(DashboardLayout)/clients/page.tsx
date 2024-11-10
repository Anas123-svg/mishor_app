"use client";
import React, { useState } from "react";
import {
  Badge,
  Dropdown,
  Modal,
  Button,
  TextInput,
  Table,
} from "flowbite-react";
import { HiOutlineDotsVertical } from "react-icons/hi";
import { Icon } from "@iconify/react";
import Image from "next/image";

const Clients = () => {
  const [search, setSearch] = useState("");
  const [clients, setClients] = useState([
    {
      img: "/images/profile/user-2.jpg",
      name: "Company A",
      email: "contact@companya.com",
      teamSize: 12,
      status: "active",
    },
    {
      img: "/images/profile/user-3.jpg",
      name: "Company B",
      email: "info@companyb.com",
      teamSize: 8,
      status: "pending",
    },
    {
      img: "/images/profile/user-1.jpg",
      name: "Company C",
      email: "support@companyc.com",
      teamSize: 15,
      status: "rejected",
    },
  ]);

  const actionOptions = [
    { icon: "solar:eye-outline", label: "View Details" },
    { icon: "solar:check-circle-outline", label: "Approve" },
    { icon: "solar:close-circle-outline", label: "Reject" },
  ];

  return (
    <>
      <div className="rounded-lg shadow-md bg-white dark:bg-darkgray p-6 w-full">
        <div className="flex justify-between items-center mb-4">
          <h5 className="text-xl font-semibold">Clients</h5>
          <Button color="primary">Add Client</Button>
        </div>

        <TextInput
          placeholder="Search Clients"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="mb-3"
        />

        <div className="overflow-x-auto">
          <Table hoverable>
            <Table.Head>
              <Table.HeadCell>Picture</Table.HeadCell>
              <Table.HeadCell>Name</Table.HeadCell>
              <Table.HeadCell>Email</Table.HeadCell>
              <Table.HeadCell>Team</Table.HeadCell>
              <Table.HeadCell>Status</Table.HeadCell>
              <Table.HeadCell>Actions</Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y">
              {clients
                .filter(
                  (client) =>
                    client.name.toLowerCase().includes(search.toLowerCase()) ||
                    client.email.toLowerCase().includes(search.toLowerCase())
                )
                .map((client, index) => (
                  <Table.Row
                    key={index}
                    className="hover:bg-gray-100 dark:hover:bg-gray-900"
                  >
                    <Table.Cell className="p-4">
                      <Image
                        src={client.img}
                        alt="Client Profile"
                        width={50}
                        height={50}
                        className="rounded-full"
                      />
                    </Table.Cell>
                    <Table.Cell className="font-medium">
                      {client.name}
                    </Table.Cell>
                    <Table.Cell className="text-gray-500">
                      {client.email}
                    </Table.Cell>
                    <Table.Cell>{client.teamSize} Users</Table.Cell>
                    <Table.Cell>
                      <Badge
                        color={
                          client.status === "active"
                            ? "success"
                            : client.status === "pending"
                            ? "warning"
                            : "failure"
                        }
                      >
                        {client.status.charAt(0).toUpperCase() +
                          client.status.slice(1)}
                      </Badge>
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
        </div>
      </div>
    </>
  );
};

export default Clients;
