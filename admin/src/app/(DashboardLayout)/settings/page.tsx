"use client";
import React, { useState } from "react";
import { Button, TextInput, Card } from "flowbite-react";
import { Icon } from "@iconify/react";
import PhotosUploader from "@/app/components/Uploader";
import useAuthStore from "@/store/authStore";
import toast from "react-hot-toast";
import axios from "axios";

const Settings = () => {
  const { user, token, setUser } = useAuthStore();
  const [personalInfo, setPersonalInfo] = useState({
    profilePic: user?.profile_image,
    name: user?.name,
    email: user?.email,
  });

  const [passwords, setPasswords] = useState({
    oldPassword: "",
    newPassword: "",
    confirmPassword: "",
  });

  const handlePersonalInfoChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setPersonalInfo((prevInfo) => ({ ...prevInfo, [name]: value }));
  };

  const handlePasswordChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setPasswords((prevPasswords) => ({ ...prevPasswords, [name]: value }));
  };

  const handlePersonalInfoSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!personalInfo.name || !personalInfo.email || !personalInfo.profilePic) {
      toast.error("Please fill all fields");
      return;
    }
    try {
      const response = await axios.put(
        `${process.env.NEXT_PUBLIC_API_URL}/admin/${user?.id}`,
        {
          email: personalInfo.email,
          name: personalInfo.name,
          profile_image: personalInfo.profilePic,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setUser(response.data.admin);
      toast.success(response.data.message || "Admin updated successfully");
    } catch (error) {
      toast.error("An error occurred while updating profile");
    }
  };

  const handlePasswordSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (
      !passwords.oldPassword ||
      passwords.newPassword.length < 8 ||
      passwords.confirmPassword.length < 8
    ) {
      toast.error(
        "Please fill all fields and ensure password is at least 8 characters"
      );
      return;
    }
    if (passwords.newPassword !== passwords.confirmPassword) {
      toast.error("Passwords do not match");
      return;
    }
    try {
      const response = await axios.post(
        `${process.env.NEXT_PUBLIC_API_URL}/admin/reset-password`,
        {
          old_password: passwords.oldPassword,
          new_password: passwords.newPassword,
          new_password_confirmation: passwords.confirmPassword,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      toast.success(response.data.message || "Password changed successfully");
      setPasswords({
        oldPassword: "",
        newPassword: "",
        confirmPassword: "",
      });
    } catch (error) {
      console.log(error);
      if (axios.isAxiosError(error) && error.response?.status === 400) {
        toast.error(error.response.data.error || "Old password is incorrect");
        return;
      }
      toast.error("An error occurred while changing password");
    }
  };

  return (
    <div className="flex flex-col md:flex-row gap-6 p-2 sm:p-6 bg-gray-100 dark:bg-darkgray rounded-lg shadow-md w-full">
      {/* Personal Info Form */}
      <Card className="w-full md:w-1/2">
        <h5 className="text-xl font-semibold mb-4">Personal Info</h5>
        <form onSubmit={handlePersonalInfoSubmit} className="space-y-4">
          <PhotosUploader
            profilePic={personalInfo.profilePic || ""}
            onChange={(url) =>
              setPersonalInfo((prevInfo) => ({ ...prevInfo, profilePic: url }))
            }
          />
          <div className="flex items-center gap-2">
            <Icon
              icon="solar:user-circle-linear"
              className="text-gray-500 text-xl"
            />
            <TextInput
              placeholder="Name"
              name="name"
              value={personalInfo.name}
              onChange={handlePersonalInfoChange}
              required
              className="w-full"
            />
          </div>
          <div className="flex items-center gap-2">
            <Icon
              icon="solar:letter-linear"
              className="text-gray-500 text-xl"
            />
            <TextInput
              type="email"
              placeholder="Email"
              name="email"
              value={personalInfo.email}
              onChange={handlePersonalInfoChange}
              required
              className="w-full"
            />
          </div>
          <Button type="submit" color="primary" className="w-full">
            Save Changes
          </Button>
        </form>
      </Card>

      {/* Password Change Form */}
      <Card className="w-full md:w-1/2 h-fit">
        <h5 className="text-xl font-semibold mb-4">Change Password</h5>
        <form onSubmit={handlePasswordSubmit} className="space-y-4">
          <div className="flex items-center gap-2">
            <Icon icon="solar:lock-linear" className="text-gray-500 text-xl" />
            <TextInput
              type="password"
              placeholder="Old Password"
              name="oldPassword"
              value={passwords.oldPassword}
              onChange={handlePasswordChange}
              required
              className="w-full"
            />
          </div>
          <div className="flex items-center gap-2">
            <Icon
              icon="solar:lock-password-linear"
              className="text-gray-500 text-xl"
            />
            <TextInput
              type="password"
              placeholder="New Password"
              name="newPassword"
              value={passwords.newPassword}
              onChange={handlePasswordChange}
              required
              className="w-full"
            />
          </div>
          <div className="flex items-center gap-2">
            <Icon
              icon="solar:lock-password-linear"
              className="text-gray-500 text-xl"
            />
            <TextInput
              type="password"
              placeholder="Confirm New Password"
              name="confirmPassword"
              value={passwords.confirmPassword}
              onChange={handlePasswordChange}
              required
              className="w-full"
            />
          </div>
          <Button type="submit" color="primary" className="w-full">
            Change Password
          </Button>
        </form>
      </Card>
    </div>
  );
};

export default Settings;
