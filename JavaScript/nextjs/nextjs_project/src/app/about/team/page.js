import UserList from "@/components/UserList";
import { getBaseUrl } from "@/app/utils";

async function getUsers() {
  const url = await getBaseUrl();
  const res = await fetch(`${url}/api/users`, {
    next: { revalidate: 60 },
  });

  return res.json();
}

export default async function UsersPage() {
  const users = await getUsers();

  return (
    <section className="max-w-5xl mx-auto p-10">
      <header className="mb-10 text-center">
        <h1 className="text-4xl font-extrabold text-slate-900 mb-2">
          Our Team
        </h1>
        <p className="text-slate-600 font-medium">
          Connecting with our talented team
        </p>
        <UserList users={users} />
      </header>
    </section>
  );
}
