import axios from 'axios'
require('dotenv').config()
export const httpClient = () => {
  let instance = axios.create({
    baseURL: process.env.REACT_APP_API_URL + `/api/${process.env.REACT_APP_API_VERSION}`,
    
  })

  instance.interceptors.request.use(
    config => {
      config.headers = { Authorization: window.localStorage.getItem('app.Authorization') }
      return config
    },
    error => {
      return Promise.reject(error)
    },
  )

  return instance
}