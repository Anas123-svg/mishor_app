import axios from "axios";

export const login = async (email: string, password: string) => {
  const { data } = await axios.post(
    `${process.env.NEXT_PUBLIC_API_URL}/client/login`,
    {
      email,
      password,
    }
  );
  localStorage.setItem("token", data.token);
  return data;
};

export const register = async (values: object) => {
  const { data } = await axios.post(
    `${process.env.NEXT_PUBLIC_API_URL}/client/register`,
    values
  );
  return data;
};

export const logout = async () => {
  await axios.post(
    `${process.env.NEXT_PUBLIC_API_URL}/client/logout`,
    {},
    {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("token")}`,
      },
    }
  );

  localStorage.removeItem("token");
  return null;
};

export const loginBack = async () => {
  const token = localStorage.getItem("token");
  if (!token) {
    return null;
  }

  const { data } = await axios.get(
    `${process.env.NEXT_PUBLIC_API_URL}/client/show`,
    {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    }
  );

  return { user: data, token };
};
