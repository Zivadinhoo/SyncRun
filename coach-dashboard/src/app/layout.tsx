import "./globals.css";
import Sidebar from "../components/ui/Sidebar";
import Header from "../components/ui/Header";

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
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
