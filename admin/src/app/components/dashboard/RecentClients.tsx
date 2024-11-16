"use client";
import React from "react";
import { Badge, Table } from "flowbite-react";
import SimpleBar from "simplebar-react";
import { Client } from "@/types";
import Link from "next/link";

const RecentClients = ({ clients }: { clients: Client[] }) => {
  return (
    <div className="rounded-lg shadow-md bg-white dark:bg-darkgray py-6 w-full">
      <div className="flex justify-between items-center px-6">
        <div>
          <h5 className="card-title">Recent Clients</h5>
          <p className="card-subtitle">New client activity</p>
        </div>
        <Link
          href="/clients"
          className="text-primary hover:underline underline-offset-4"
        >
          View All
        </Link>
      </div>
      <SimpleBar className="max-h-[450px]">
        <div className="overflow-x-auto whitespace-nowrap">
          <Table hoverable>
            <Table.Head>
              <Table.HeadCell className="p-6">Profile Pic</Table.HeadCell>
              <Table.HeadCell>Name</Table.HeadCell>
              <Table.HeadCell>Email</Table.HeadCell>
              <Table.HeadCell>Status</Table.HeadCell>
              <Table.HeadCell>Team</Table.HeadCell>
            </Table.Head>
            <Table.Body className="divide-y divide-border dark:divide-darkborder">
              {clients.map((client, index) => (
                <Table.Row key={index}>
                  <Table.Cell className="ps-6">
                    <img
                      src={client.profile_image}
                      alt="Client Profile"
                      className="h-[50px] w-[50px] rounded-full"
                    />
                  </Table.Cell>
                  <Table.Cell>{client.name}</Table.Cell>
                  <Table.Cell>{client.email}</Table.Cell>
                  <Table.Cell>
                    {client.is_verified ? (
                      <Badge color="success">Verified</Badge>
                    ) : (
                      <Badge color="warning">Not Verified</Badge>
                    )}
                  </Table.Cell>
                  <Table.Cell>{client.users_count} Users</Table.Cell>
                </Table.Row>
              ))}
            </Table.Body>
          </Table>
          {clients.length === 0 && (
            <p className="text-center mt-5">No clients found</p>
          )}
        </div>
      </SimpleBar>
    </div>
  );
};

export default RecentClients;
