/* eslint-disable quotes */
import axios from 'axios';

const httpClient = () => {
  const instance = axios.create({
    baseURL: `${process.env.API_URL}/api/${process.env.API_VERSION}`,
  });

  // instance.interceptors.request.use(
  //   config => {
  //     config.headers = {
  //       Authorization: window.localStorage.getItem('app.Authorization'),
  //     };
  //     return config;
  //   },
  //   error => Promise.reject(error),
  // );

  return instance;
};

export default httpClient;
