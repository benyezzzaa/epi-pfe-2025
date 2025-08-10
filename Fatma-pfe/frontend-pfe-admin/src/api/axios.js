// 📁 src/api/axios.js

import axios from "axios";

const instance = axios.create({
  baseURL: "http://localhost:4000", // URL directe du backend
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  }
});

instance.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default instance;
