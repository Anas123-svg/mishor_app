type Admin = {
  id: number;
  name: string;
  email: string;
  role: string;
  profile_image: string;
  created_at: string;
  updated_at: string;
};

type User = {
  id: number;
  client_id: number;
  name: string;
  email: string;
  phone: string;
  is_verified: boolean;
};

type Client = {
  id: number;
  name: string;
  email: string;
  users_count: number;
  is_verified: boolean;
  users?: User[];
  client_template: [
    {
      template_id: number;
      template: {
        name: string;
      };
    }
  ];
  profile_image: string;
  created_at: string;
  updated_at: string;
};

type Field = {
  id: number;
  template_id: number;
  label: string;
  type: string;
  options: string[];
  value: string | string[];
  isFlagged: boolean;
  attributes: {
    placeholder: string;
    required: boolean;
  };
  created_at: string;
  updated_at: string;
};

type Table = {
  id: number;
  template_id: number;
  table_name: string;
  table_data: {
    table_name: string;
    columns: string[];
    rows: {
      [key: string]: {
        [key: string]: string;
      };
    };
  };
  created_at: string;
  updated_at: string;
};

type Template = {
  id: number;
  name: string;
  Reference: string;
  fields: Field[];
  tables: Table[];
  created_by: string;
  description: string;
  created_at: string;
  updated_at: string;
};

type Assessment = {
  id: number;
  user_id: number;
  user: User;
  assessment: Template;
  status: string;
  status_by_admin: string;
  submitted_to_admin: boolean;
  client_id: number;
  client: Client;
  template_id: number;
  site_images: string[];
  feedback_by_admin: string | null;
  complete_by_user: boolean;
  created_at: string;
  updated_at: string;
};

export type { Admin, Field, Table, Template, Client, User, Assessment };
