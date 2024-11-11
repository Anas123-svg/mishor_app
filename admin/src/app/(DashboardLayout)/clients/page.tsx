"use client";
import React, { useEffect, useState } from "react";
import { Badge, Dropdown, TextInput, Table } from "flowbite-react";
import { HiOutlineDotsVertical } from "react-icons/hi";
import { Icon } from "@iconify/react";
import axios from "axios";
import useAuthStore from "@/store/authStore";
import { Client } from "@/types";

const Clients = () => {
  const [search, setSearch] = useState("");
  const { token } = useAuthStore();
  const [clients, setClients] = useState<Client[]>([]);

  const fetchClients = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/client`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      console.log(response.data);
      setClients(response.data);
    } catch (err) {
      console.log(err);
    }
  };

  useEffect(() => {
    fetchClients();
  }, []);

  const actionOptions = [
    { icon: "solar:eye-outline", label: "View Details" },
    { icon: "solar:check-circle-outline", label: "Verify" },
    { icon: "solar:close-circle-outline", label: "Unverify" },
    { icon: "solar:trash-bin-minimalistic-outline", label: "Delete" },
  ];

  return (
    <>
      <div className="rounded-lg shadow-md bg-white dark:bg-darkgray p-6 w-full">
        <h5 className="text-xl font-semibold mb-4">Clients</h5>
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
              <Table.HeadCell>Verified</Table.HeadCell>
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
                      <img
                        src={client.profile_image}
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
                    <Table.Cell>{client.team} Users</Table.Cell>
                    <Table.Cell>
                      <Badge color={client.is_verified ? "success" : "warning"}>
                        {client.is_verified ? "Verified" : "Not Verified"}
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
