"use client";
import { Button, Label, TextInput } from "flowbite-react";
import React, { useState } from "react";
import toast from "react-hot-toast";
import { useRouter } from "next/navigation";
import useAuthStore from "@/store/authStore";
import ProfilePicUploader from "../../Uploader";
import { register } from "@/hooks/auth";

const AuthRegister = ({
  setIsLogin,
}: {
  setIsLogin: React.Dispatch<React.SetStateAction<boolean>>;
}) => {
  const [image, setImage] = useState("");
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const { user } = useAuthStore();

  if (user) {
    router.push("/");
    return null;
  }

  const handleResister = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!name || !email || !password || !confirmPassword) {
      toast.error("Please fill in all fields");
      return;
    }
    if (password !== confirmPassword) {
      toast.error("Passwords do not match");
      return;
    }
    setLoading(true);
    try {
      const { message } = await register({
        name,
        email,
        password,
        profile_image: image,
      });
      toast.success(
        message || "Registration successful, please wait for admin approval"
      );
      setIsLogin(true);
    } catch (error: any) {
      if (error.response?.status === 400) {
        toast.error("Email already exists");
        setLoading(false);
        return;
      }
      toast.error("Something went wrong, please try again");
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <form onSubmit={handleResister}>
        <ProfilePicUploader
          profilePic={image}
          onChange={(url) => setImage(url)}
        />
        <div className="mb-4">
          <div className="mb-2 block">
            <Label htmlFor="name" value="Name" />
          </div>
          <TextInput
            id="name"
            type="name"
            sizing="md"
            className="form-control"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
        </div>
        <div className="mb-4">
          <div className="mb-2 block">
            <Label htmlFor="email" value="Email" />
          </div>
          <TextInput
            id="email"
            type="email"
            sizing="md"
            className="form-control"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </div>
        <div className="mb-8">
          <div className="mb-2 block">
            <Label htmlFor="userpwd" value="Password" />
          </div>
          <TextInput
            id="userpwd"
            type="password"
            sizing="md"
            className="form-control"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </div>
        <div className="mb-8">
          <div className="mb-2 block">
            <Label htmlFor="cfmpwd" value="Confirm Password" />
          </div>
          <TextInput
            id="cfmpwd"
            type="password"
            sizing="md"
            className="form-control"
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
          />
        </div>
        <Button
          type="submit"
          disabled={loading}
          color="failure"
          className="w-full"
        >
          {loading ? "Loading..." : "Register"}
        </Button>
      </form>
    </>
  );
};

export default AuthRegister;
