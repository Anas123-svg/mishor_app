"use client";
import { Button, Label, TextInput } from "flowbite-react";
import React, { useState } from "react";
import toast from "react-hot-toast";

const AuthLogin = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!email || !password) {
      toast.error("Please fill in all fields");
      return;
    }
    setLoading(true);
    try {
      // const res = await login({ email, password });
      // console.log(res);
    } catch (error) {
      console.log(error);
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
