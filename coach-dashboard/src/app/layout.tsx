import "./globals.css";
import Sidebar from "./components/ui/Sidebar";
import Header from "./components/ui/Header";
import { ReactNode } from "react";

export const metadata = {
  title: "SyncRun Coach",
  description: "Dashboard for running coaches",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <head />
      <body className="flex">
        <Sidebar />
        <div className="flex-1 flex flex-col">
          <Header />
          <main className="p-6">{children}</main>
        </div>
      </body>
    </html>
  );
}
