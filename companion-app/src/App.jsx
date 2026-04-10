import React from "react";
import { Settings, Shield, Activity, Package, Terminal, Database, Code, Cpu } from "lucide-react";

const App = () => {
  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 p-8 font-sans">
      <header className="mb-12">
        <h1 className="text-4xl font-bold bg-gradient-to-r from-teal-400 to-blue-500 bg-clip-text text-transparent">
          Keystone Companion
        </h1>
        <p className="text-slate-400 mt-2">Professional Developer Suite Control Center</p>
      </header>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <Card icon={<Activity className="text-teal-400" />} title="System Health" status="Optimized" />
        <Card icon={<Shield className="text-blue-400" />} title="Security" status="Standard" />
        <Card icon={<Cpu className="text-purple-400" />} title="AI Tools" status="Active" />
        <Card icon={<Database className="text-orange-400" />} title="Databases" status="Running" />
      </div>

      <main className="mt-12 grid grid-cols-1 lg:grid-cols-3 gap-8">
        <section className="lg:col-span-2 bg-slate-900/50 border border-slate-800 rounded-2xl p-6">
          <h2 className="text-xl font-semibold mb-6 flex items-center gap-2">
            <Code className="text-teal-400" /> Active Project Stack
          </h2>
          <div className="space-y-4">
            <ToolItem name="Gemini CLI" description="Isolated via UVX" status="Ready" />
            <ToolItem name="Ollama" description="Local LLM Engine" status="Online" />
            <ToolItem name="XAMPP" description="PHP Development" status="Ready" />
            <ToolItem name="SQLite" description="Lightweight Storage" status="Installed" />
          </div>
        </section>

        <aside className="bg-slate-900/50 border border-slate-800 rounded-2xl p-6">
          <h2 className="text-xl font-semibold mb-6 flex items-center gap-2">
            <Terminal className="text-blue-400" /> Quick Actions
          </h2>
          <div className="grid grid-cols-1 gap-3">
            <button className="w-full py-3 px-4 bg-teal-500/10 hover:bg-teal-500/20 text-teal-400 rounded-lg text-sm font-medium transition-colors text-left border border-teal-500/20">
              Backup System Profile
            </button>
            <button className="w-full py-3 px-4 bg-blue-500/10 hover:bg-blue-500/20 text-blue-400 rounded-lg text-sm font-medium transition-colors text-left border border-blue-500/20">
              Open VS Code
            </button>
            <button className="w-full py-3 px-4 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-lg text-sm font-medium transition-colors text-left border border-slate-700">
              Refresh Package Cache
            </button>
          </div>
        </aside>
      </main>
    </div>
  );
};

const Card = ({ icon, title, status }) => (
  <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 hover:border-slate-700 transition-colors shadow-xl">
    <div className="mb-4">{icon}</div>
    <h3 className="text-slate-400 text-xs font-bold uppercase tracking-wider mb-1">{title}</h3>
    <p className="text-xl font-semibold">{status}</p>
  </div>
);

const ToolItem = ({ name, description, status }) => (
  <div className="flex items-center justify-between p-4 bg-slate-950/50 rounded-xl border border-slate-800/50">
    <div>
      <h4 className="font-medium">{name}</h4>
      <p className="text-xs text-slate-500">{description}</p>
    </div>
    <span className="px-3 py-1 bg-teal-500/10 text-teal-400 text-[10px] font-bold uppercase tracking-tighter rounded-full border border-teal-500/20">
      {status}
    </span>
  </div>
);

export default App;
