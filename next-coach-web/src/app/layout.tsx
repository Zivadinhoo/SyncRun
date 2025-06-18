import "./globals.css";
import { ReactNode } from "react";
import ClientLayout from "@/app/components/ui/ClientLayout";

export const metadata = {
  title: "SyncRun Coach",
  description: "Dashboard for running coaches",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body>
        <ClientLayout>{children}</ClientLayout>
      </body>
    </html>
  );
}
