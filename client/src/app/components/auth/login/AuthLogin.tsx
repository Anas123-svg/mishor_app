"use client";
import { Button, Label, TextInput } from "flowbite-react";
import React, { useState } from "react";
import toast from "react-hot-toast";
import { useRouter } from "next/navigation";
import useAuthStore from "@/store/authStore";
import { login } from "@/hooks/auth";

const AuthLogin = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const { user, setToken, setUser } = useAuthStore();

  if (user) {
    router.push("/");
    return null;
  }

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email || !password) {
      toast.error("Please fill in all fields");
      return;
    }
    setLoading(true);
    try {
      const { user, token } = await login(email, password);
      setUser(user);
      setToken(token);
      router.push("/");
      toast.success("Logged in successfully");
    } catch (error: any) {
      console.log("error", error);
      if (error.response?.status === 401) {
        toast.error("Invalid email or password");
        setLoading(false);
        return;
      } else if (error.response?.status === 403) {
        toast.error("You are not approved yet, please wait for admin approval");
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
      <form onSubmit={handleLogin}>
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
        <Button
          type="submit"
          disabled={loading}
          color="failure"
          className="w-full"
        >
          {loading ? "Loading..." : "Login"}
        </Button>
      </form>
    </>
  );
};

export default AuthLogin;
