// Dieses Dokument zeigt die Interface Demo mit OSC Clients
// einer davon ist der Localhost. Ein anderer kann noch hinzugefŸgt werden.

(
NGDirector.addNetClient(0, 0.25@0.5, "127.0.0.1");
NGDirector.addNetClient(1, 0.75@0.5, "192.168.2.100");
)

// Damit's easy bleibt holen wir uns die Instanz in eine globale Variable
g = NGDirector.instance;

NGClient(false); // dies fŸgt den lokalen Client hinzu. true wŸrde fullscreen erzeugen


// SynthDefs an alle Server kšnnen wir mit sendNG schicken
// MacBooks haben Stereo Lautsprecher, also SynthDefs auch Stereo machen
// Panning macht natŸrlich nur begrenzt Sinn (aber ist schon wahrnehmbar)
(
SynthDef(\pling, {|freq=440, amp=0.2, release=0.4|
	var sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(Env.perc(0.001, release), doneAction: 2);
	Out.ar(0, sig.dup * amp);
}).sendNG();

SynthDef(\krch, {|amp = 0.2|
	var sig = Dust2.ar(400);
	sig = sig * EnvGen.kr(Env.perc(0.001, 0.2), doneAction: 2);
	Out.ar(0, sig.dup * amp);
}).sendNG();
)

// Wie abgesprochen kšnnen Synths natŸrlich MouseX und MouseY nutzen

// die Play Methode ist von Synth Ÿbernommen.
g[0].play(\pling, [freq: 800]);
g[1].play(\pling, [freq: 1200]); // man beachte die spatialisiernug

// es kšnnten noch viele weitere Sachen implementiert werden.
// ich habe mal eine nearestClient Methode implementiert.
// wer etwas tolles implementiert kann es ja schicken oder so.
g.nearestClient(0.25@0.0).play(\krch)

// die color Methode setzt eine Farbe.
// die 3 Werte sind RGB von 0 bis 1
g.at(g.clients.size.rand).color(1,0,0)

// die fadeColor Methode macht einen FarbŸbergang von der aktuellen Farbe in x Sekunden
g.at(0).fadeColor(0,0,1,10)

// schlie§lich gibt es noch die execute Methode. Sie schickt SC Quelltext per OSC
// an den anderen Rechner, baut eine Funktion und Ÿbergibt den lokalen Client als
// Argument.

// Die Funktionen mŸssen natŸrlich in sich geschlossen sein, sonst klappt das umwandeln
// in einen String nicht.

// Wenn der execute Methode weitere Argumente Ÿbergeben werden, werden sie mit der Funktion mitgeschickt
// und hinter dem Client Objekt der Funktion Ÿbergeben
(
g.clients.do {|c|
	c.execute({|c| fork { 5.do { c.color(1.0.rand, 1.0.rand, 1.0.rand); 1.0.rand.wait };};}, i);
};
)

// Will man Daten auf einem Client lokal speichern kann man c.dict als Dictionary nutzen

// NatŸrlich ist es immer die Farbe, ob es notwendig ist Quelltext auf dem Client auszufŸhren.
// Es geht zumindest. Der lokale Client sollte gleich aggieren wie ein remote Client

// Ich habe auch Angefangen ein paar Event Types zu implementieren.
// --> siehe Patterns und Events.scd
