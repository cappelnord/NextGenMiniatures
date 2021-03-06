// F�r die TestClients gibt's ein paar Variablen:

TestNGClient.simulatePosition = true; // ob die Position
TestNGClient.simulateSpeaker = true; // Speaker Simulation (not yet implemented)
TestNGClient.ampulitudeMul = 0.5; // Damit nicht gleich alles �bersteuert
TestNGClient.numSimulationSpeakers = 2; // f�r PanAz (to implement)

// Wir bauen hier erstmal unseren Director mit einer 4x4 Matrix
// Wir nutzen nur TestClients. In der Performance sollte man dies
// theoretisch einfach mit NetSendClients austauschen k�nnen.

// Ein GROSSES Problem: die Simulations Nodes werden nach Command Period wieder gel�scht.
// Sollten geskippjacked werden.

( // dauert lange!!
{
16.do {|i|
	var point = Point(i%4 * (1/3), (i/4).floor * (1/3));
	NGDirector.addTestClient(i, point);	
	1.wait; // wir hatten mit Grainface mal Probleme, wenn wir mehrere Server gleichzeitig starten
};
}.fork(AppClock);
) // Danach warten bis der letze (ng_15) ready ist

// jeder TestClient hat seinen eigenen Server. Damit k�nnen MultiCores
// besser genutzt werden und es ist n�her am "Original" dran.

// Damit's easy bleibt holen wir uns die Instanz in eine globale Variable
g = NGDirector.instance;

// wir wollen etwas sehen, daher das Testfenster
g.testWindow.front

// Wenn wir wollen k�nnen wir uns die einzelnen Testserver anschauen.
g.clients.do {|c| c.server.makeWindow } // passen halt net alle drauf

// SynthDefs werdne scheinbar durch add an alle laufenden Server geschickt
// MacBooks haben Stereo Lautsprecher, also SynthDefs auch Stereo machen
// Panning macht nat�rlich nur begrenzt Sinn (aber ist schon wahrnehmbar)
(
SynthDef(\pling, {|freq=440, amp=0.2, release=0.4|
	var sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(Env.perc(0.001, release), doneAction: 2);
	Out.ar(0, sig.dup * amp);
}).add();

SynthDef(\krch, {|amp = 0.2|
	var sig = Dust2.ar(400);
	sig = sig * EnvGen.kr(Env.perc(0.001, 0.2), doneAction: 2);
	Out.ar(0, sig.dup * amp);
}).add();
)

// Wie abgesprochen k�nnen Synths nat�rlich MouseX und MouseY nutzen

// die Play Methode ist von Synth �bernommen.
g[0].play(\pling, [freq: 800]);
g[2].play(\pling, [freq: 1200]); // man beachte die spatialisiernug

// es k�nnten noch viele weitere Sachen implementiert werden.
// ich habe mal eine nearestClient Methode implementiert.
// wer etwas tolles implementiert kann es ja schicken oder so.
g.nearestClient(0.7@0.5).play(\krch)

// die color Methode setzt eine Farbe.
// die 3 Werte sind RGB von 0 bis 1
g.at(g.clients.size.rand).color(1,0,0)

// die fadeColor Methode macht einen Farb�bergang von der aktuellen Farbe in x Sekunden
g.at(4).fadeColor(0,1,1,10)

// blink geht auch!
g[4].blink(1,0,0,0.1)

// schlie�lich gibt es noch die execute Methode. Sie schickt SC Quelltext per OSC
// an den anderen Rechner, baut eine Funktion und �bergibt den lokalen Client als
// Argument.

// Die Funktionen m�ssen nat�rlich in sich geschlossen sein, sonst klappt das umwandeln
// in einen String nicht.

// Wenn der execute Methode weitere Argumente �bergeben werden, werden sie mit der Funktion mitgeschickt
// und hinter dem Client Objekt der Funktion �bergeben
(
g.clients.do {|c, i|
	c.execute({|c, i| fork { (i*2).do { c.color(1.0.rand, 1.0.rand, 1.0.rand); 1.0.rand.wait };};}, i);
};
)

// Will man Daten auf einem Client lokal speichern kann man c.dict als Dictionary nutzen

// Nat�rlich ist es immer die Farbe, ob es notwendig ist Quelltext auf dem Client auszuf�hren.
// Es geht zumindest. Der lokale Client sollte gleich aggieren wie ein remote Client

// Ich habe auch Angefangen ein paar Event Types zu implementieren.
// --> siehe Patterns und Events.scd
