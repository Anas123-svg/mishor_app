"use client";
import React from "react";
import { Badge, Dropdown, Table } from "flowbite-react";
import { HiOutlineDotsVertical } from "react-icons/hi";
import { Icon } from "@iconify/react";
import Image from "next/image";
import SimpleBar from "simplebar-react";

const RecentClients = () => {
  const ClientTableData = [
    {
      pic: "/default-avatar.jpg",
      name: "Alice Johnson",
      email: "alice.johnson@example.com",
      team: "Marketing",
      users: 25,
    },
    {
      pic: "/default-avatar.jpg",
      name: "John Smith",
      email: "john.smith@example.com",
      team: "Sales",
      users: 30,
    },
    {
      pic: "/default-avatar.jpg",
      name: "Emma Brown",
      email: "emma.brown@example.com",
      team: "Product Development",
      users: 15,
    },
    {
      pic: "/default-avatar.jpg",
      name: "David Lee",
      email: "david.lee@example.com",
      team: "Customer Support",
      users: 10,
    },
    {
      pic: "/default-avatar.jpg",
      name: "Olivia Green",
      email: "olivia.green@example.com",
      team: "Engineering",
      users: 40,
    },
  ];

  const tableActionData = [
    { icon: "solar:add-circle-outline", listtitle: "Add" },
    { icon: "solar:pen-new-square-broken", listtitle: "Edit" },
    { icon: "solar:trash-bin-minimalistic-outline", listtitle: "Delete" },
  ];

  return (
    <div className="rounded-lg shadow-md bg-white dark:bg-darkgray py-6 w-full">
      <div className="px-6">
        <h5 className="card-title">Recent Clients</h5>
        <p className="card-subtitle">New client activity</p>
      </div>
      <SimpleBar className="max-h-[450px]">
        <div className="overflow-x-auto">
          <Table hoverable>
            <Table.Head>
              <Table.HeadCell className="p-6">Client</Table.HeadCell>
              <Table.HeadCell>Email</Table.HeadCell>
              <Table.HeadCell>Team</Table.HeadCell>
              <Table.HeadCell>No. of Users</Table.HeadCell>
              <Table.HeadCell></Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y divide-border dark:divide-darkborder">
              {ClientTableData.map((client, index) => (
                <Table.Row key={index}>
                  <Table.Cell className="whitespace-nowrap ps-6">
                    <div className="flex gap-3 items-center">
                      <img
                        src={client.pic}
                        alt="Client Profile"
                        className="h-[50px] w-[50px] rounded-full"
                      />
                      <div className="text-sm font-medium">{client.name}</div>
                    </div>
                  </Table.Cell>
                  <Table.Cell className="text-sm opacity-70">
                    {client.email}
                  </Table.Cell>
                  <Table.Cell>
                    <Badge color="info" className="text-info">
                      {client.team}
                    </Badge>
                  </Table.Cell>
                  <Table.Cell className="text-center">
                    {client.users}
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
                      {tableActionData.map((item, index) => (
                        <Dropdown.Item key={index} className="flex gap-3">
                          <Icon icon={item.icon} height={18} />
                          <span>{item.listtitle}</span>
                        </Dropdown.Item>
                      ))}
                    </Dropdown>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table.Body>
          </Table>
        </div>
      </SimpleBar>
    </div>
  );
};

export default RecentClients;
