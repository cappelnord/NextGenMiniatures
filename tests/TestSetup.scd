(
[0@0, 1@0, 0.5@0.5, 0@1, 1@1].do {|v, i|
	NGDirector.addTestClient(i, v);
};
)

// Director Instanz sei g
g = NGDirector.instance

// Fenster f�r Screen Tests anzeigen
g.testWindow.front;

// Serverfenster f�r alle Clients
g.clients.do {|c| c.server.makeWindow;};

// Einen SynthDef hinzuf�gen (im Window sollte die Anzal steigen)
(
SynthDef(\ngtest, {|freq=50|
	var sig = Dust2.ar(freq!2) * EnvGen.ar(Env.perc(0.001,0.2), doneAction: 2);
	Out.ar(0, sig);
}).sendNG();
)

g[1].play(\ngtest, [freq: 5000])
g[1].color(0,0,1)

// position test
g.nearestClient(0@0).play(\ngtest, [freq:5000]);
g.nearestClient(1@0).play(\ngtest, [freq:5000]);


// Ausf�hren von Code auf einem Client
// Funktion wird hierbei als String geschickt und erh�lt ein Argument, den ausf�hrenden Client.
// �ber c.server k�nnte man den zust�ndigen SCSynth bekommen.
(
g.clients.do {|c|
c.execute({|c| fork { 10.do { c.color(1.0.rand, 1.0.rand, 1.0.rand);0.5.wait};};})
};
)

g.nearestClient(0.2@0.2).color(1,0,0)
g.nearestClient(0.6@0.5).fadeColor(0,1,1, 5)