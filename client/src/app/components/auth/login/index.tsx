import React from "react";
import AuthLogin from "./AuthLogin";

const Login = ({
  setIsLogin,
}: {
  setIsLogin: React.Dispatch<React.SetStateAction<boolean>>;
}) => {
  return (
    <>
      <div className="relative overflow-hidden h-screen bg-muted dark:bg-dark">
        <div className="flex h-full justify-center items-center px-4">
          <div className="rounded-lg dark:shadow-dark-md shadow-md bg-white dark:bg-darkgray p-6 relative break-words md:w-[450px] w-full border-none ">
            <div className="flex h-full flex-col justify-center gap-2 p-0 w-full">
              <h2 className="text-2xl text-center text-dark my-3">
                Client Login
              </h2>
              <AuthLogin />
              <div className="mt-4 text-center">
                <p>
                  Don't have an account?{" "}
                  <button
                    onClick={() => setIsLogin(false)}
                    className="text-primary"
                  >
                    Register
                  </button>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Login;
