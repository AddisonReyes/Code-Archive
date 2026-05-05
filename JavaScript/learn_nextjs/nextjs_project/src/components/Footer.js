export default function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="bg-slate-900 text-slate-300 py-6 mt-auto">
      <div className="container mx-auto px-4 text-center">
        <p className="text-sm font-medium">Copyright &copy; {currentYear}</p>
      </div>
    </footer>
  );
}
