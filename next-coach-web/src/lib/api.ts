import axios from "axios";

// Ovo koristiš u client-side komponentama
export const api = axios.create({
  baseURL: "/api",
  withCredentials: true,
});

// Ovo koristiš u server-side fajlovima kao što je page.tsx
export const serverApi = axios.create({
  baseURL: "http://localhost:3001",
  withCredentials: true,
});
