const courses = [
  {
    id: 1,
    title: "React 19 Mastery - From zero to hero",
    description: "Learn React 19 from scratch to advanced level.",
  },
  {
    id: 2,
    title: "The complete JavaScript Developer Course",
    description: "Master the fundamentals of modern JavaScript.",
  },
  {
    id: 3,
    title: "The complete Node.js Developer Course",
    description: "Build backend APIs with Node.js and Express.",
  },
  {
    id: 4,
    title: "The complete Python Developer Course",
    description: "Learn Python from scratch to advanced level.",
  },
  {
    id: 5,
    title: "The complete Java Developer Course",
    description: "Learn Java from scratch to advanced level.",
  },
  {
    id: 6,
    title: "The complete C++ Developer Course",
    description: "Learn C++ from scratch to advanced level.",
  },
  {
    id: 7,
    title: "Rust from zero to hero in 30 days",
    description: "Learn Rust from scratch to advanced level.",
  },
];

export async function GET(request) {
  return Response.json(courses);
}
