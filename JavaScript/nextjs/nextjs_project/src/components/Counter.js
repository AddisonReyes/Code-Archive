"use client";

import { useState } from "react";

export default function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div className="p-4">
      <button
        onClick={() => setCount(count + 1)}
        className="border px-3 py-1 mr-1 rounded"
      >
        Increment
      </button>
      <button
        onClick={() => setCount(count - 1)}
        className="border px-3 py-1 mr-2 rounded"
      >
        Decrement
      </button>
      Count: {count}
    </div>
  );
}
