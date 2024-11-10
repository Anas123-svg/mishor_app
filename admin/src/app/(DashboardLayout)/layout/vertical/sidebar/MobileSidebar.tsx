"use client";
import React from "react";
import { Sidebar } from "flowbite-react";
import SidebarContent from "./Sidebaritems";
import NavItems from "./NavItems";
import NavCollapse from "./NavCollapse";
import SimpleBar from "simplebar-react";
import { Icon } from "@iconify/react";
import Logout from "@/app/components/logout";
const MobileSidebar = () => {
  return (
    <>
      <div className="flex">
        <Sidebar
          className="fixed menu-sidebar pt-6 bg-primary dark:bg-darkgray z-[10]"
          aria-label="Sidebar with multi-level dropdown example"
        >
          <h1 className="text-white text-2xl bg-primary pb-6 px-4">
            Admin Panel
          </h1>

          <SimpleBar className="h-[calc(100vh_-_150px)] bg-primary">
            <Sidebar.Items className="px-4">
              <Sidebar.ItemGroup className="sidebar-nav">
                {SidebarContent.map((item, index) => (
                  <React.Fragment key={index}>
                    <h5 className="text-white font-semibold text-sm caption">
                      <span className="hide-menu">{item.heading}</span>
                    </h5>
                    <Icon
                      icon="solar:menu-dots-bold"
                      className="text-ld block mx-auto mt-6 leading-6 dark:text-opacity-60 hide-icon"
                      height={18}
                    />

                    {item.children?.map((child, index) => (
                      <React.Fragment key={child.id && index}>
                        {child.children ? (
                          <div className="collpase-items">
                            <NavCollapse item={child} />
                          </div>
                        ) : (
                          <NavItems item={child} />
                        )}
                      </React.Fragment>
                    ))}
                  </React.Fragment>
                ))}
              </Sidebar.ItemGroup>
            </Sidebar.Items>
          </SimpleBar>
          <Logout />
        </Sidebar>
      </div>
    </>
  );
};

export default MobileSidebar;
