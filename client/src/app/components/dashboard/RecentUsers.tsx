"use client";
import React from "react";
import { Badge, Table } from "flowbite-react";
import SimpleBar from "simplebar-react";
import { User } from "@/types";
import Link from "next/link";

const RecentUsers = ({ clients }: { clients: User[] }) => {
  return (
    <div className="rounded-lg shadow-md bg-white dark:bg-darkgray py-6 w-full">
      <div className="flex justify-between items-center px-6">
        <div>
          <h5 className="card-title">Recent Users</h5>
          <p className="card-subtitle">New users activity</p>
        </div>
        <Link
          href="/users"
          className="text-primary hover:underline underline-offset-4"
        >
          View All
        </Link>
      </div>
      <SimpleBar className="max-h-[450px]">
        <div className="overflow-x-auto whitespace-nowrap">
          <Table hoverable>
            <Table.Head>
              <Table.HeadCell>Name</Table.HeadCell>
              <Table.HeadCell>Email</Table.HeadCell>
              <Table.HeadCell>Phone</Table.HeadCell>
              <Table.HeadCell>Status</Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y divide-border dark:divide-darkborder">
              {clients.map((client, index) => (
                <Table.Row key={index}>
                  <Table.Cell>{client.name}</Table.Cell>
                  <Table.Cell>{client.email}</Table.Cell>
                  <Table.Cell>{client.phone}</Table.Cell>
                  <Table.Cell>
                    {client.is_verified ? (
                      <Badge color="success">Verified</Badge>
                    ) : (
                      <Badge color="warning">Not Verified</Badge>
                    )}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table.Body>
          </Table>
        </div>
      </SimpleBar>
    </div>
  );
};

export default RecentUsers;
