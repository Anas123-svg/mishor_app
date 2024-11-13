import React, { useState } from "react";
import Login from "./login";
import Register from "./register";

const Auth = () => {
  const [isLogin, setIsLogin] = useState(true);

  return isLogin ? (
    <Login setIsLogin={setIsLogin} />
  ) : (
    <Register setIsLogin={setIsLogin} />
  );
};

export default Auth;
