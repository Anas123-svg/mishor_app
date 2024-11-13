"use client";
import React, { useEffect, useState } from "react";
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
import ProfilePicUploader from "@/app/components/Uploader";
import { Icon } from "@iconify/react";
import { Admin } from "@/types";
import axios from "axios";
import useAuthStore from "@/store/authStore";
import toast from "react-hot-toast";

const Admins = () => {
  const [search, setSearch] = useState("");
  const [isModalOpen, setIsModalOpen] = useState(false);
  const { token, user } = useAuthStore();
  const [addAdmin, setAddAdmin] = useState({
    name: "",
    email: "",
    password: "",
    role: "admin",
    profile_image: "",
  });
  const [editAdmin, setEditAdmin] = useState<{
    id: number | null;
    name: string;
    email: string;
    role: string;
    profile_image: string;
  }>({
    id: null,
    name: "",
    email: "",
    role: "admin",
    profile_image: "",
  });
  const [editingMode, setEditingMode] = useState(false);
  const [admins, setAdmins] = useState<Admin[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchAdmins = async () => {
    try {
      const response = await axios.get(
        `${process.env.NEXT_PUBLIC_API_URL}/admin`,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setAdmins(response.data);
    } catch (error) {
      console.log(error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchAdmins();
  }, []);

  const handleAddAdmin = async () => {
    if (
      !addAdmin.name ||
      !addAdmin.email ||
      !addAdmin.password ||
      !addAdmin.profile_image ||
      !addAdmin.role
    ) {
      return toast.error("Please fill all fields!");
    }
    setLoading(true);
    try {
      const response = await axios.post(
        `${process.env.NEXT_PUBLIC_API_URL}/admin/register`,
        addAdmin,
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      toast.success(response.data.message || "Admin added successfully!");
      setIsModalOpen(false);
      setAddAdmin({
        name: "",
        email: "",
        password: "",
        role: "admin",
        profile_image: "",
      });
    } catch (error: any) {
      console.error("Error adding admin:", error);
      toast.error(error.response.data.email || "Error adding admin!");
    } finally {
      fetchAdmins();
    }
  };

  const handleEditAdmin = async () => {
    if (editAdmin.id === null) return;
    if (
      !editAdmin.name ||
      !editAdmin.email ||
      !editAdmin.role ||
      !editAdmin.profile_image
    ) {
      return toast.error("Please fill all fields!");
    }
    setLoading(true);
    try {
      const response = await axios.put(
        `${process.env.NEXT_PUBLIC_API_URL}/admin/${editAdmin.id}`,
        {
          name: editAdmin.name,
          email: editAdmin.email,
          role: editAdmin.role,
          profile_image: editAdmin.profile_image,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      toast.success(response.data.message || "Admin updated successfully!");
      setIsModalOpen(false);
      setEditAdmin({
        id: null,
        name: "",
        email: "",
        role: "admin",
        profile_image: "",
      });
      setEditingMode(false);
    } catch (error) {
      console.error("Error editing admin:", error);
    } finally {
      fetchAdmins();
    }
  };

  const handleDeleteAdmin = async (id: number) => {
    if (!window.confirm("Are you sure you want to delete this admin?")) return;
    try {
      await axios.delete(`${process.env.NEXT_PUBLIC_API_URL}/admin/${id}`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      toast.success("Admin deleted successfully!");
      fetchAdmins();
    } catch (error) {
      console.error("Error deleting admin:", error);
    }
  };

  const openAddModal = () => {
    setEditingMode(false);
    setIsModalOpen(true);
  };

  const openEditModal = (admin: Admin) => {
    setEditAdmin({
      id: admin.id,
      name: admin.name,
      email: admin.email,
      role: admin.role,
      profile_image: admin.profile_image,
    });
    setEditingMode(true);
    setIsModalOpen(true);
  };

  return (
    <>
      <div className="rounded-lg shadow-md bg-white dark:bg-darkgray p-6 w-full">
        <div className="flex justify-between items-center mb-4">
          <h5 className="card-title">Admins</h5>
          <Button color="primary" onClick={openAddModal}>
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
                      <img
                        src={admin.profile_image}
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
                        placement="left"
                        dismissOnClick={false}
                        renderTrigger={() => (
                          <span className="h-9 w-9 flex justify-center items-center rounded-full hover:bg-lightprimary hover:text-primary cursor-pointer">
                            <HiOutlineDotsVertical size={22} />
                          </span>
                        )}
                      >
                        <Dropdown.Item
                          disabled={admin.id === user?.id}
                          onClick={() => openEditModal(admin)}
                          className="flex gap-3"
                        >
                          <Icon
                            icon="solar:pen-new-square-broken"
                            height={18}
                          />
                          <span>Edit</span>{" "}
                          {admin.id === user?.id && (
                            <Icon
                              icon="solar:forbidden-circle-linear"
                              height={18}
                              className="text-red-500"
                            />
                          )}
                        </Dropdown.Item>
                        <Dropdown.Item
                          disabled={admin.id === user?.id}
                          onClick={() => handleDeleteAdmin(admin.id)}
                          className="flex gap-3"
                        >
                          <Icon
                            icon="solar:trash-bin-minimalistic-outline"
                            height={18}
                          />
                          <span>Delete</span>{" "}
                          {admin.id === user?.id && (
                            <Icon
                              icon="solar:forbidden-circle-linear"
                              height={18}
                              className="text-red-500 justify-self-end"
                            />
                          )}
                        </Dropdown.Item>
                      </Dropdown>
                    </Table.Cell>
                  </Table.Row>
                ))}
            </Table.Body>
          </Table>

          {admins.length === 0 ||
            (admins.filter(
              (admin) =>
                admin.name.toLowerCase().includes(search.toLowerCase()) ||
                admin.email.toLowerCase().includes(search.toLowerCase())
            ).length === 0 && (
              <p className="text-center mt-5">No Admins Found</p>
            ))}
        </div>
      </div>

      {/* Add/Edit Admin Modal */}
      <Modal
        show={isModalOpen}
        onClose={() => {
          setEditingMode(false);
          setAddAdmin({
            name: "",
            email: "",
            password: "",
            role: "admin",
            profile_image: "",
          });
          setEditAdmin({
            id: null,
            name: "",
            email: "",
            role: "admin",
            profile_image: "",
          });
          setIsModalOpen(false);
        }}
      >
        <Modal.Header>
          {editingMode ? "Edit Admin" : "Add New Admin"}
        </Modal.Header>
        <Modal.Body>
          <ProfilePicUploader
            profilePic={
              editingMode ? editAdmin.profile_image : addAdmin.profile_image
            }
            onChange={(url: string) =>
              editingMode
                ? setEditAdmin({ ...editAdmin, profile_image: url })
                : setAddAdmin({ ...addAdmin, profile_image: url })
            }
          />
          <TextInput
            placeholder="Name"
            value={editingMode ? editAdmin.name : addAdmin.name}
            onChange={(e) =>
              editingMode
                ? setEditAdmin({ ...editAdmin, name: e.target.value })
                : setAddAdmin({ ...addAdmin, name: e.target.value })
            }
            className="my-4"
          />
          <TextInput
            placeholder="Email"
            value={editingMode ? editAdmin.email : addAdmin.email}
            onChange={(e) =>
              editingMode
                ? setEditAdmin({ ...editAdmin, email: e.target.value })
                : setAddAdmin({ ...addAdmin, email: e.target.value })
            }
            className="mb-4"
          />
          {/* Show password field only in Add mode */}
          {!editingMode && (
            <TextInput
              type="password"
              placeholder="Password"
              value={addAdmin.password}
              onChange={(e) =>
                setAddAdmin({ ...addAdmin, password: e.target.value })
              }
              className="mb-4"
            />
          )}
          <Select
            value={editingMode ? editAdmin.role : addAdmin.role}
            onChange={(e) =>
              editingMode
                ? setEditAdmin({ ...editAdmin, role: e.target.value })
                : setAddAdmin({ ...addAdmin, role: e.target.value })
            }
            className="mb-4"
          >
            <option value="admin">Admin</option>
          </Select>
        </Modal.Body>
        <Modal.Footer>
          <Button
            color="primary"
            disabled={loading}
            onClick={editingMode ? handleEditAdmin : handleAddAdmin}
          >
            {loading
              ? "Loading..."
              : editingMode
              ? "Save Changes"
              : "Add Admin"}
          </Button>
          <Button
            color="secondary"
            onClick={() => {
              setEditingMode(false);
              setAddAdmin({
                name: "",
                email: "",
                password: "",
                role: "admin",
                profile_image: "",
              });
              setEditAdmin({
                id: null,
                name: "",
                email: "",
                role: "admin",
                profile_image: "",
              });
              setIsModalOpen(false);
            }}
          >
            Cancel
          </Button>
        </Modal.Footer>
      </Modal>
    </>
  );
};

export default Admins;
