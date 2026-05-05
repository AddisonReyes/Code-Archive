async function getCourses() {
  const res = await fetch("https://localhost:3001/courses", {
    next: { revalidate: 60 }, //  Regenerate every 60 seconds => ISR (Incremental Static Regeneration)
    // cache: "force-cache", // SSG (Static Site Generation)
  });
  return res.json();
}

export default function CoursesPage() {
  return <h1>Courses</h1>;
}
