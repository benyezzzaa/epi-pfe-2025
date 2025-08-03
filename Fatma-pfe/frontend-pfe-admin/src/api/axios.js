// 📁 src/api/axios.js

import axios from "axios";

const instance = axios.create({
  baseURL: "http://localhost:4000", // ton backend NestJS
  
});

instance.interceptors.request.use((config) => {
  const token = localStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default instance;
