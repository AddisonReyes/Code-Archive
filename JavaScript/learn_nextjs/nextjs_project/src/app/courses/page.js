export const metadata = {
  title: "Courses",
  description: "List of available courses",
};

async function getCourses() {
  const res = await fetch("http://localhost:3000/api/courses", {
    next: { revalidate: 60 },
  });
  return res.json();
}

export default async function CoursesPage() {
  const courses = await getCourses();

  return (
    <section className="max-w-3xl mx-auto p-8">
      <h1 className="text-2xl font-semibold mb-6">Available Courses</h1>
      <ul className="space-y-4">
        {courses.map((course) => (
          <li
            key={course.id}
            className="border rounded-lg p-4 hover:bg-gray-50 transition"
          >
            <h2 className="text-lg font-medium">{course.title}</h2>
            <p className="text-gray-600 text-sm mt-1">{course.description}</p>
          </li>
        ))}
      </ul>
    </section>
  );
}
