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
};

type Client = {
  id: number;
  name: string;
  email: string;
  users_count: number;
  is_verified: boolean;
  users: User[];
  profile_image: string;
};

type Field = {
  id: number;
  template_id: number;
  label: string;
  type: string;
  options: string[];
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
  fields: Field[];
  tables: Table[];
  created_by: string;
  description: string;
  created_at: string;
  updated_at: string;
};

export type { Admin, Field, Table, Template, Client };
