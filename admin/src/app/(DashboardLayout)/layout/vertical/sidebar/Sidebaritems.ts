export interface ChildItem {
  id?: number | string;
  name?: string;
  icon?: any;
  children?: ChildItem[];
  item?: any;
  url?: any;
  color?: string;
}

export interface MenuItem {
  heading?: string;
  name?: string;
  icon?: any;
  id?: number;
  to?: string;
  items?: MenuItem[];
  children?: ChildItem[];
  url?: any;
}

import { uniqueId } from "lodash";

const SidebarContent: MenuItem[] = [
  {
    heading: "Menu",
    children: [
      {
        name: "Dashboard",
        icon: "solar:widget-add-line-duotone",
        id: uniqueId(),
        url: "/",
      },
      {
        name: "Templates",
        icon: "fluent:form-multiple-20-regular",
        id: uniqueId(),
        url: "/templates",
      },
      {
        name: "Clients",
        icon: "solar:users-group-two-rounded-line-duotone",
        id: uniqueId(),
        url: "/clients",
      },
      {
        name: "Assessments",
        icon: "solar:notes-line-duotone",
        id: uniqueId(),
        url: "/assessments",
      },
      {
        name: "Admins",
        icon: "solar:shield-user-line-duotone",
        id: uniqueId(),
        url: "/admins",
      },
      {
        name: "Settings",
        icon: "solar:settings-minimalistic-broken",
        id: uniqueId(),
        url: "/settings",
      },
    ],
  },
];

export default SidebarContent;
