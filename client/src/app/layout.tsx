"use client";
import React, { useEffect } from "react";
import { Inter } from "next/font/google";
import "simplebar-react/dist/simplebar.min.css";
import "./css/globals.css";
import { Flowbite, ThemeModeScript } from "flowbite-react";
import customTheme from "@/utils/theme/custom-theme";
import { Toaster } from "react-hot-toast";
import useAuthStore from "@/store/authStore";
import { loginBack } from "@/hooks/auth";
import Auth from "./components/auth";

const inter = Inter({ subsets: ["latin"] });

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const { setUser, setToken, user } = useAuthStore();
  useEffect(() => {
    handleLoginBack();
  }, []);

  const handleLoginBack = async () => {
    try {
      const res = await loginBack();
      if (!res) {
        setToken("");
        setUser(null);
        localStorage.removeItem("token");
        return;
      }
      setUser(res?.user);

      if (res?.token) {
        setToken(res.token);
      }
    } catch (error: any) {
      setToken("");
      setUser(null);
      localStorage.removeItem("token");
    }
  };
  return (
    <html lang="en">
      <head>
        <link rel="icon" href="/favicon.svg" type="image/svg+xml" />
        <title>Client Panel</title>
        <ThemeModeScript />
      </head>
      <body className={`${inter.className}`}>
        <Flowbite theme={{ theme: customTheme }}>
          {user ? children : <Auth />}
        </Flowbite>
        <Toaster />
      </body>
    </html>
  );
}
