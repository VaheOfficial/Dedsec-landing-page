'use client';

import { useEffect, useState } from 'react';

export default function Home() {
  const [mounted, setMounted] = useState(false);
  const [terminalLines, setTerminalLines] = useState<string[]>([]);
  
  const bootSequence = [
    "INITIALIZING DEDSEC_AI_NETWORK...",
    "LOADING NEURAL_PATHWAYS...",
    "ESTABLISHING_SECURE_CONNECTION...",
    "AUTHENTICATING USER: RedactMe",
    "ACCESS_GRANTED >> WELCOME_TO_THE_NETWORK",
  ];

  useEffect(() => {
    setMounted(true);
    
    // Simulate boot sequence
    bootSequence.forEach((line, index) => {
      setTimeout(() => {
        setTerminalLines(prev => [...prev, line]);
      }, (index + 1) * 800);
    });
  }, []);

  if (!mounted) return null;

  return (
    <div className="min-h-screen relative">
      {/* Background Layers */}
      <div className="grid-pattern"></div>
      <div className="matrix-rain"></div>
      <div className="scanlines"></div>
      
      {/* Main Layout */}
      <div className="relative z-10 min-h-screen flex flex-col">
        
        {/* Header */}
        <header className="flex justify-between items-center p-6 lg:p-8">
          <div className="fade-in-up">
                         <div className="text-sm text-gray-400 mb-1">NEURAL_INTERFACE</div>
             <div className="text-[#00ff41] font-bold">v2.1.0</div>
          </div>
          <div className="fade-in-up delay-1 text-right">
                         <div className="text-sm text-gray-400 mb-1">OPERATOR</div>
             <div className="text-[#00d4ff] font-bold glitch-text" data-text="RedactMe">
               RedactMe
             </div>
          </div>
        </header>

        {/* Central Hero Section */}
        <main className="flex-1 flex items-center justify-center px-6 lg:px-8">
          <div className="max-w-6xl mx-auto text-center space-y-12">
            
            {/* Main Title */}
            <div className="space-y-8">
              <h1 className="fade-in-up delay-2">
                <div className="text-7xl lg:text-9xl font-bold mb-4">
                  <span className="glitch-text neon-text" data-text="DEDSEC">DEDSEC</span>
                </div>
                <div className="circuit-flow h-1 w-80 mx-auto mb-6"></div>
                                 <div className="text-4xl lg:text-6xl font-light text-[#00d4ff] tracking-[0.5em]">
                   AI
                 </div>
              </h1>
              
              <p className="fade-in-up delay-3 text-lg lg:text-xl text-gray-300 max-w-3xl mx-auto leading-relaxed">
                Neural Network Infiltration System • Advanced AI-Driven Cybersecurity Platform
              </p>
            </div>

            {/* Status Grid */}
            <div className="fade-in-up delay-4 grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
              
                             {/* System Status */}
               <div className="neon-border bg-[#0d1f0d] p-6 hover-glow transition-all duration-300">
                 <div className="flex items-center justify-between mb-4">
                   <h3 className="text-lg font-semibold text-[#00ff41]">SYSTEM STATUS</h3>
                   <span className="status-dot online"></span>
                 </div>
                 <div className="space-y-2 text-sm">
                   <div className="flex justify-between">
                     <span className="text-gray-400">Neural Core:</span>
                     <span className="text-[#00ff41]">ONLINE</span>
                   </div>
                   <div className="flex justify-between">
                     <span className="text-gray-400">Security:</span>
                     <span className="text-[#ff0844]">MAXIMUM</span>
                   </div>
                   <div className="flex justify-between">
                     <span className="text-gray-400">Encryption:</span>
                     <span className="text-[#00d4ff]">ACTIVE</span>
                   </div>
                 </div>
                 <div className="circuit-flow h-0.5 mt-4"></div>
               </div>

                             {/* Network Stats */}
               <div className="neon-border-cyan bg-[#0d1f0d] p-6 hover-glow transition-all duration-300">
                 <div className="flex items-center justify-between mb-4">
                   <h3 className="text-lg font-semibold text-[#00d4ff]">NETWORK STATS</h3>
                   <span className="status-dot warning"></span>
                 </div>
                 <div className="space-y-3">
                   <div>
                     <div className="flex justify-between text-sm mb-1">
                       <span className="text-gray-400">Intrusion Success</span>
                       <span className="text-[#00d4ff]">99.7%</span>
                     </div>
                     <div className="w-full bg-gray-700 h-2 rounded">
                       <div className="bg-[#00d4ff] h-2 rounded w-[99.7%]"></div>
                     </div>
                   </div>
                   <div>
                     <div className="flex justify-between text-sm mb-1">
                       <span className="text-gray-400">Neural Pathways</span>
                       <span className="text-[#00d4ff]">∞</span>
                     </div>
                     <div className="w-full bg-gray-700 h-2 rounded">
                       <div className="bg-[#00d4ff] h-2 rounded w-full animate-pulse"></div>
                     </div>
                   </div>
                 </div>
               </div>

                             {/* Security Panel */}
               <div className="neon-border-red bg-[#0d1f0d] p-6 hover-glow transition-all duration-300">
                 <div className="flex items-center justify-between mb-4">
                   <h3 className="text-lg font-semibold text-[#ff0844]">SECURITY</h3>
                   <span className="status-dot critical"></span>
                 </div>
                 <div className="space-y-2 text-sm">
                   <div className="flex justify-between">
                     <span className="text-gray-400">Firewall:</span>
                     <span className="text-[#ff0844]">BREACHED</span>
                   </div>
                   <div className="flex justify-between">
                     <span className="text-gray-400">Trace Block:</span>
                     <span className="text-[#00ff41]">ACTIVE</span>
                   </div>
                   <div className="flex justify-between">
                     <span className="text-gray-400">Anonymity:</span>
                     <span className="text-[#00ff41]">SECURED</span>
                   </div>
                 </div>
                 <div className="circuit-flow h-0.5 mt-4"></div>
               </div>
            </div>

                         {/* Terminal Window */}
             <div className="fade-in-up delay-5 max-w-4xl mx-auto">
               <div className="neon-border bg-[#050705]">
                 {/* Terminal Header */}
                 <div className="border-b border-[#00ff41] p-3 flex items-center space-x-2">
                   <div className="w-3 h-3 rounded-full bg-[#ff0844]"></div>
                   <div className="w-3 h-3 rounded-full bg-yellow-500"></div>
                   <div className="w-3 h-3 rounded-full bg-[#00ff41]"></div>
                   <div className="ml-4 text-sm text-gray-400">root@dedsec-ai:~</div>
                 </div>
                 
                 {/* Terminal Content */}
                 <div className="p-6 space-y-2 min-h-[200px]">
                   <div className="text-sm text-gray-400 mb-4">
                     DEDSEC_AI_TERMINAL v2.1.0 | Operator: <span className="text-[#00d4ff]">RedactMe</span>
                   </div>
                   
                   {terminalLines.map((line, index) => (
                     <div key={index} className="text-sm text-[#00ff41] typing-container">
                       <span className="text-gray-500">$ </span>
                       {line}
                     </div>
                   ))}
                   
                   {terminalLines.length >= bootSequence.length && (
                     <div className="text-sm text-[#00ff41] mt-4">
                       <span className="text-gray-500">root@dedsec:~$ </span>
                       <span className="cursor">█</span>
                     </div>
                   )}
                 </div>
               </div>
             </div>

          </div>
        </main>

        {/* Footer Info */}
        <footer className="p-6 lg:p-8">
          <div className="flex justify-between items-center text-xs text-gray-500">
            <div className="fade-in-up delay-1">
              <div>◇ NODE_ALPHA • STATUS: OPERATIONAL</div>
              <div>◇ LAST_SYNC: {new Date().toLocaleTimeString()}</div>
            </div>
            <div className="fade-in-up delay-2 text-right">
              <div>◈ ENCRYPTION: AES-256 • RSA-4096</div>
              <div>◈ NETWORK: DARK_WEB_GATEWAY</div>
            </div>
          </div>
        </footer>

      </div>

             {/* Floating UI Elements */}
       <div className="fixed top-1/2 left-4 transform -translate-y-1/2 space-y-4 z-20">
         <div className="w-1 h-16 bg-[#00ff41] opacity-50"></div>
         <div className="w-1 h-8 bg-[#00d4ff] opacity-30"></div>
         <div className="w-1 h-12 bg-[#ff0844] opacity-40"></div>
       </div>
       
       <div className="fixed top-1/2 right-4 transform -translate-y-1/2 space-y-4 z-20">
         <div className="w-1 h-12 bg-[#ff0844] opacity-40"></div>
         <div className="w-1 h-8 bg-[#00d4ff] opacity-30"></div>
         <div className="w-1 h-16 bg-[#00ff41] opacity-50"></div>
       </div>

    </div>
  );
}
