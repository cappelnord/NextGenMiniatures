// Es ist nicht schwer eigene Event-Typen zu schreiben und damit
// auch easy mit Patterns spezielles Zeug zu machen.
// Hier mal Beispiele die sinnvoll sein könnten aber man kann auch
// anderes Zeug noch implementieren und so Stillvoll Daten und Logik
// miteinander trennen.

// Sollte noch ein NGDirector leben am besten mit Rekompilierung alles auf
// Null setzen (Sorry, sollte ich noch verbessern)

// Ein GROSSES Problem: die Simulations Nodes werden nach Command Period wieder gelöscht.
// Sollten geskippjacked werden.

( // dauert lange!!
{
16.do {|i|
	var point = Point(i%4 * (1/3), (i/4).floor * (1/3));
	NGDirector.addTestClient(i, point);	
	1.wait; // wir hatten mit Grainface mal Probleme, wenn wir mehrere Server gleichzeitig starten
};
}.fork(AppClock);
)

NGDirector.instance.testWindow.front;

( // Dies sind Event Types. Wenn diese Klammer asugeführt wird gibt es neue Event/Pattern Typen
Event.addEventType(\ng_color, {
	NGDirector.instance.at(~where ? 0).color(~red ? 0, ~green ? 0, ~blue ? 0);
});

Event.addEventType(\ng_blink, {
	NGDirector.instance.at(~where ? 0).blink(~red ? 0, ~green ? 0, ~blue ? 0, ~time ? 0.1);
});

// dies umgeht die play Methode von NGClients, also wird's nicht automatisch im Testfenster angezeigt.
// visualPlayCue schafft abhilfe.
// auch sollte dies wohl eleganter gehen.
// auch sollte man das noch aufräumen, etc. blub. uneffizient
// man sollte mal die Republic Klasse schauen, wie das da funktioniert
Event.addEventType(\ng_sound, {
	var g = NGDirector.instance;
	(~x.notNil && ~y.notNil).if {
		~where = g.clients.indexOf(g.nearestClient(Point(~x, ~y)));
	};
	~where = ~where ? 0;
	~type = \grain;
	~server = g.at(~where).server;
	g.at(~where).visualPlayCue;
	~play.value();
});

)

(
SynthDef(\pling, {|freq=440, amp=0.2, release=0.4|
	var sig = SinOsc.ar(freq);
	sig = sig * EnvGen.kr(Env.perc(0.001, release), doneAction: 2);
	Out.ar(0, sig.dup * amp);
}).add; // wir müssen es auch adden, damit es in SynthDescLib geschrieben wird.

// man sieht an dem Panning, dass die Testknoten aktiv sind

Pdef(\ng_soundtest, Pbind(
	\type, \ng_sound,
	\instrument, \pling,
	\degree, 2,
	\where, Pseq((0..15),inf),
	// \x, Pwhite(0.0, 1.0, inf),
	// \y, Pwhite(0.0, 1.0, inf),
	\dur, 0.25,
	\amp, 0.1
)).play;
)

Pdef(\ng_soundtest).clear

// klappt natürlich auch ohne Pdef

(
Pdef(\ng_test, Pbind(
	\type, \ng_color,
	\dur, 0.25,
	\red, Pwhite(0.0, 1.0),
	\green, Pseq([0,1],inf),
	\blue, 0.5,
	\where, Prand((0..15),inf)
)).play;
)

(
Pdef(\ng_test2, Pbind(
	\dur, 1/8,
	\type, \ng_blink,
	[\red, \green, \blue], 1!3,
	\time, 0.1,
	\where, Pseq((0..15),inf) 
)).play;
)

// und ohne Pbind
(
(
	type: \ng_blink,
	time: 0.5,
	where: 4
).play;
)