// FŸr die TestClients gibt's ein paar Variablen:

TestNGClient.simulatePosition = true; // ob die Position
TestNGClient.simulateSpeaker = true; // Speaker Simulation (not yet implemented)
TestNGClient.ampulitudeMul = 0.5; // Damit nicht gleich alles Ÿbersteuert
TestNGClient.numSimulationSpeakers = 2; // fŸr PanAz (to implement)

// Wir bauen hier erstmal unseren Director mit einer 3x3 Matrix
// Wir nutzen nur TestClients. In der Performance sollte man dies
// theoretisch einfach mit NetSendClients austauschen kšnnen.

(
{
9.do {|i|
	var point = Point(i%3 * 0.5, (i/3).floor * 0.5);
	NGDirector.addTestClient(i, point);	
	1.wait; // wir hatten mit Grainface mal Probleme, wenn wir mehrere Server gleichzeitig starten
};
}.fork(AppClock);
)

// jeder TestClient hat seinen eigenen Server. Damit kšnnen MultiCores
// besser genutzt werden und es ist nŠher am "Original" dran.

// Damit's easy bleibt holen wir uns die Instanz in eine globale Variable
g = NGDirector.instance;

// wir wollen etwas sehen, daher das Testfenster
g.testWindow.front

// Wenn wir wollen kšnnen wir uns die einzelnen Testserver anschauen.
g.clients.do {|c| c.server.makeWindow } // passen halt net alle drauf

// SynthDefs werdne scheinbar durch add an alle laufenden Server geschickt
// MacBooks haben Stereo Lautsprecher, also SynthDefs auch Stereo machen
// Panning macht natŸrlich nur begrenzt Sinn (aber ist schon wahrnehmbar)
(
SynthDef(\plong, {|freq=440, amp=0.2, release=0.4|
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

// Wie abgesprochen kšnnen Synths natŸrlich MouseX und MouseY nutzen

// die Play Methode ist von Synth Ÿbernommen.
g[0].play(\pling, [freq: 800]);
g[2].play(\pling, [freq: 1200]); // man beachte die spatialisiernug

// es kšnnten noch viele weitere Sachen implementiert werden.
// ich habe mal eine nearestClient Methode implementiert.
// wer etwas tolles implementiert kann es ja schicken oder so.
g.nearestClient(0.7@0.5).play(\krch)

// die color Methode setzt eine Farbe.
// die 3 Werte sind RGB von 0 bis 1
g.at(g.clients.size.rand).color(1,0,0)

// die fadeColor Methode macht einen FarbŸbergang von der aktuellen Farbe in x Sekunden
g.at(4).fadeColor(0,1,1,10)

// blink geht auch!
g[4].blink(1,0,0,0.1)

// schlie§lich gibt es noch die execute Methode. Sie schickt SC Quelltext per OSC
// an den anderen Rechner, baut eine Funktion und Ÿbergibt den lokalen Client als
// Argument.

// Die Funktionen mŸssen natŸrlich in sich geschlossen sein, sonst klappt das umwandeln
// in einen String nicht.

// Wenn der execute Methode weitere Argumente Ÿbergeben werden, werden sie mit der Funktion mitgeschickt
// und hinter dem Client Objekt der Funktion Ÿbergeben
(
g.clients.do {|c, i|
	c.execute({|c, i| fork { (i*2).do { c.color(1.0.rand, 1.0.rand, 1.0.rand); 1.0.rand.wait };};}, i);
};
)

// Will man Daten auf einem Client lokal speichern kann man c.dict als Dictionary nutzen

// NatŸrlich ist es immer die Farbe, ob es notwendig ist Quelltext auf dem Client auszufŸhren.
// Es geht zumindest. Der lokale Client sollte gleich aggieren wie ein remote Client

// Ich habe auch Angefangen ein paar Event Types zu implementieren.
// --> siehe Patterns und Events.scd
