"use client";
import React, { useState } from "react";
import { Button, TextInput, Card } from "flowbite-react";
import { Icon } from "@iconify/react";
import Image from "next/image";

const Settings = () => {
  const [personalInfo, setPersonalInfo] = useState({
    profilePic: "/images/profile/user-1.jpg",
    name: "John Doe",
    email: "john@example.com",
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

  const handlePersonalInfoSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Logic to save personal information
  };

  const handlePasswordSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Logic to change password
  };

  return (
    <div className="flex flex-col md:flex-row gap-6 p-6 bg-gray-100 dark:bg-darkgray rounded-lg shadow-md w-full">
      {/* Personal Info Form */}
      <Card className="w-full md:w-1/2 p-6">
        <h5 className="text-xl font-semibold mb-4">Personal Info</h5>
        <form onSubmit={handlePersonalInfoSubmit} className="space-y-4">
          <div className="flex flex-col items-center">
            <Image
              src={personalInfo.profilePic}
              alt="Profile"
              width={100}
              height={100}
              className="rounded-full mb-3 border"
            />
            <Button color="light" className="flex items-center gap-2">
              <Icon icon="solar:camera-linear" className="text-lg" />
              Change Profile Picture
            </Button>
          </div>
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
      <Card className="w-full md:w-1/2 p-6 h-fit">
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
