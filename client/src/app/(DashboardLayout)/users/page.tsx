"use client";
import React, { useEffect, useState } from "react";
import {
  Badge,
  Dropdown,
  TextInput,
  Table,
  TableRow,
  Spinner,
} from "flowbite-react";
import { HiOutlineDotsVertical } from "react-icons/hi";
import { Icon } from "@iconify/react";
import axios from "axios";
import useAuthStore from "@/store/authStore";
import { User } from "@/types";
import toast from "react-hot-toast";
import Link from "next/link";

const Users = () => {
  const [search, setSearch] = useState("");
  const { token } = useAuthStore();
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);

  const fetchUsers = async () => {
    setLoading(true);
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/client/users`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setUsers(response.data.users);
    } catch (err) {
      console.log(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  const verifyUser = async (id: number) => {
    try {
      await axios.put(
        `${process.env.NEXT_PUBLIC_API_URL}/user/${id}/verify`,
        {},
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      toast.success("User Verified Successfully");
      fetchUsers();
    } catch (err) {
      console.log(err);
      toast.error("Error verifying user");
    }
  };

  const deleteUser = async (id: number) => {
    if (!confirm("Are you sure you want to delete this user?")) return;
    try {
      await axios.delete(`${process.env.NEXT_PUBLIC_API_URL}/user/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success("user deleted successfully");
      fetchUsers();
    } catch (err) {
      toast.error("Failed to delete user");
      console.log(err);
    }
  };

  return loading ? (
    <div className="flex justify-center items-center w-full h-[80vh] text-primary">
      <Spinner size="xl" />
    </div>
  ) : (
    <>
      <div className="rounded-lg shadow-md bg-white dark:bg-darkgray p-6 w-full">
        <h5 className="text-xl font-semibold mb-4">Users</h5>
        <TextInput
          placeholder="Search Users"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="mb-3"
        />
        <div className="overflow-x-auto">
          <Table hoverable>
            <Table.Head>
              <Table.HeadCell>Name</Table.HeadCell>
              <Table.HeadCell>Email</Table.HeadCell>
              <Table.HeadCell>Phone</Table.HeadCell>
              <Table.HeadCell>Verified</Table.HeadCell>
              <Table.HeadCell>Actions</Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y">
              {users
                .filter(
                  (user) =>
                    user.name.toLowerCase().includes(search.toLowerCase()) ||
                    user.email.toLowerCase().includes(search.toLowerCase())
                )
                .map((user, index) => (
                  <Table.Row
                    key={index}
                    className="hover:bg-gray-100 dark:hover:bg-gray-900 whitespace-nowrap"
                  >
                    <Table.Cell className="font-medium">{user.name}</Table.Cell>
                    <Table.Cell className="text-gray-500">
                      {user.email}
                    </Table.Cell>
                    <Table.Cell className="text-gray-500">
                      {user.phone}
                    </Table.Cell>
                    <Table.Cell>
                      <Badge color={user.is_verified ? "success" : "warning"}>
                        {user.is_verified ? "Verified" : "Not Verified"}
                      </Badge>
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
                          href={`/users/${user.id}`}
                          className="flex gap-3"
                        >
                          <Icon icon="solar:eye-outline" height={18} />
                          <span> View Details</span>
                        </Dropdown.Item>
                        <Dropdown.Item
                          className="flex gap-3"
                          onClick={() => verifyUser(user.id)}
                        >
                          <Icon icon="solar:check-circle-outline" height={18} />
                          <span>Verify</span>
                        </Dropdown.Item>
                        <Dropdown.Item
                          onClick={() => deleteUser(user.id)}
                          className="flex gap-3"
                        >
                          <Icon
                            icon="solar:trash-bin-minimalistic-outline"
                            height={18}
                          />
                          <span> Delete</span>
                        </Dropdown.Item>
                      </Dropdown>
                    </Table.Cell>
                  </Table.Row>
                ))}
            </Table.Body>
          </Table>
          {users.length === 0 ? (
            <p className="text-center mt-5">No users found</p>
          ) : users.filter(
              (user) =>
                user.name.toLowerCase().includes(search.toLowerCase()) ||
                user.email.toLowerCase().includes(search.toLowerCase())
            ).length === 0 ? (
            <p className="text-center mt-5">No users found</p>
          ) : null}
        </div>
      </div>
    </>
  );
};

export default Users;
