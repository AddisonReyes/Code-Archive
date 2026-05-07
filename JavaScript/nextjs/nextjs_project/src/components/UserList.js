"use client";

export default function UserList({ users }) {
  return (
    <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
      {users.map((user) => (
        <div
          key={user.id}
          className="p-6 border border-slate-200 rounded-2xl bg-white shadow-sm"
        >
          <h2 className="text-xl font-bold text-slate-800">{user.name}</h2>
          <p className="text-blue-600 text-sm font-medium mb-4">
            @{user.username}
          </p>

          <div className="space-y-2 text-sm text-slate-500">
            <p>{user.email}</p>
            <p>{user.company.name}</p>
            <p>{user.address.city}</p>
          </div>
        </div>
      ))}
    </div>
  );
}
