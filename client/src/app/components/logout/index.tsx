import React, { useState } from "react";
import { Modal, Button } from "flowbite-react"; // Import Modal and Button from flowbite-react
import { logout } from "@/hooks/auth";
import useAuthStore from "@/store/authStore";
import toast from "react-hot-toast";

const Logout = () => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const { setUser, setToken } = useAuthStore();

  const handleLogout = () => {
    logout();
    setUser(null);
    setToken(null);
    toast.success("Logged out successfully");
    setIsModalOpen(false);
  };

  return (
    <div className="w-full bg-primary p-4">
      <Button
        onClick={() => setIsModalOpen(true)}
        className="w-full text-white bg-black/50"
      >
        Logout
      </Button>
      <Modal show={isModalOpen} onClose={() => setIsModalOpen(false)}>
        <Modal.Header>Logout Confirmation</Modal.Header>
        <Modal.Body>
          <p>Are you sure you want to logout?</p>
        </Modal.Body>
        <Modal.Footer className="flex justify-end">
          <Button color="secondary" onClick={() => setIsModalOpen(false)}>
            Cancel
          </Button>
          <Button color="primary" onClick={handleLogout}>
            Confirm
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
};

export default Logout;
