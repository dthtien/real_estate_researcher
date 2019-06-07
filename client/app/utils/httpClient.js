/* eslint-disable quotes */
import axios from "axios";
require("dotenv").config();
const httpClient = () => {
  const instance = axios.create({
    baseURL:
      process.env.REACT_APP_API_URL +
      `/api/${process.env.REACT_APP_API_VERSION}`
  });

  instance.interceptors.request.use(
    config => {
      config.headers = {
        Authorization: window.localStorage.getItem("app.Authorization")
      };
      return config;
    },
    error => Promise.reject(error)
  );

  return instance;
};

export default httpClient;
