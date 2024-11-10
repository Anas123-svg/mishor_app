"use client";
import React, { useState } from "react";
import {
  Badge,
  Dropdown,
  Modal,
  Button,
  TextInput,
  Select,
  Table,
} from "flowbite-react";
import { HiOutlineDotsVertical } from "react-icons/hi";
import { Icon } from "@iconify/react";
import Image from "next/image";

const Admins = () => {
  const [search, setSearch] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [newAdmin, setNewAdmin] = useState({
    name: "",
    email: "",
    password: "",
    role: "admin",
    profilePic: "",
  });
  const [admins, setAdmins] = useState([
    {
      img: "/images/profile/user-1.jpg",
      name: "John Doe",
      email: "john@example.com",
      role: "admin",
    },
    {
      img: "/images/profile/user-1.jpg",
      name: "Jane Smith",
      email: "jane@example.com",
      role: "admin",
    },
    {
      img: "/images/profile/user-1.jpg",
      name: "Alice Johnson",
      email: "alice@example.com",
      role: "admin",
    },
  ]);

  const tableActionData = [
    { icon: "solar:pen-new-square-broken", listtitle: "Edit" },
    { icon: "solar:trash-bin-minimalistic-outline", listtitle: "Delete" },
  ];

  const handleAddAdmin = () => {
    setAdmins([
      ...admins,
      { ...newAdmin, img: newAdmin.profilePic || "/images/profile/user-1.jpg" },
    ]);
    setIsModalOpen(false);
    setNewAdmin({
      name: "",
      email: "",
      password: "",
      role: "admin",
      profilePic: "",
    });
  };

  return (
    <>
      <div className="rounded-lg shadow-md bg-white dark:bg-darkgray p-6 w-full">
        <div className="flex justify-between items-center mb-4">
          <h5 className="card-title">Admins</h5>
          <Button color="primary" onClick={() => setIsModalOpen(true)}>
            Add Admin
          </Button>
        </div>

        <TextInput
          placeholder="Search Admins"
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
              <Table.HeadCell>Role</Table.HeadCell>
              <Table.HeadCell>Actions</Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y">
              {admins
                .filter(
                  (admin) =>
                    admin.name.toLowerCase().includes(search.toLowerCase()) ||
                    admin.email.toLowerCase().includes(search.toLowerCase())
                )
                .map((admin, index) => (
                  <Table.Row
                    key={index}
                    className="hover:bg-gray-100 dark:hover:bg-gray-900"
                  >
                    <Table.Cell className="p-4">
                      <Image
                        src={admin.img}
                        alt="Admin Profile"
                        width={50}
                        height={50}
                        className="rounded-full"
                      />
                    </Table.Cell>
                    <Table.Cell className="font-medium">
                      {admin.name}
                    </Table.Cell>
                    <Table.Cell className="text-gray-500">
                      {admin.email}
                    </Table.Cell>
                    <Table.Cell>
                      <Badge color="success">Admin</Badge>
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
                        {tableActionData.map((action, i) => (
                          <Dropdown.Item key={i} className="flex gap-3">
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
        </div>
      </div>

      {/* Add Admin Modal */}
      <Modal show={isModalOpen} onClose={() => setIsModalOpen(false)}>
        <Modal.Header>Add New Admin</Modal.Header>
        <Modal.Body>
          <TextInput
            placeholder="Name"
            value={newAdmin.name}
            onChange={(e) => setNewAdmin({ ...newAdmin, name: e.target.value })}
            className="mb-4"
          />
          <TextInput
            placeholder="Email"
            value={newAdmin.email}
            onChange={(e) =>
              setNewAdmin({ ...newAdmin, email: e.target.value })
            }
            className="mb-4"
          />
          <TextInput
            type="password"
            placeholder="Password"
            value={newAdmin.password}
            onChange={(e) =>
              setNewAdmin({ ...newAdmin, password: e.target.value })
            }
            className="mb-4"
          />
          <Select
            value={newAdmin.role}
            onChange={(e) => setNewAdmin({ ...newAdmin, role: e.target.value })}
            className="mb-4"
          >
            <option value="admin">Admin</option>
          </Select>
          <TextInput
            placeholder="Profile Picture URL"
            value={newAdmin.profilePic}
            onChange={(e) =>
              setNewAdmin({ ...newAdmin, profilePic: e.target.value })
            }
            className="mb-4"
          />
        </Modal.Body>
        <Modal.Footer>
          <Button color="primary" onClick={handleAddAdmin}>
            Add Admin
          </Button>
          <Button color="secondary" onClick={() => setIsModalOpen(false)}>
            Cancel
          </Button>
        </Modal.Footer>
      </Modal>
    </>
  );
};

export default Admins;
