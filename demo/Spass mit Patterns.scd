// Es ist nicht schwer eigene Event-Typen zu schreiben und damit
// auch easy mit Patterns spezielles Zeug zu machen.
// Hier mal Beispiele die sinnvoll sein könnten aber man kann auch
// anderes Zeug noch implementieren und so Stillvoll Daten und Logik
// miteinander trennen.

// Sollte noch ein NGDirector leben am besten mit Rekompilierung alles auf
// Null setzen (Sorry, sollte ich noch verbessern)

(
9.do {|i|
	var point = Point(i%3 * 0.5, (i/3).floor * 0.5);
	NGDirector.addTestClient(i, point);	
}
)

NGDirector.instance.testWindow.front;

(
Event.addEventType(\ng_color, {
	NGDirector.instance.at(~where).color(~red ? 0, ~green ? 0, ~blue ? 0);
});

Event.addEventType(\ng_blink, {
	NGDirector.instance.at(~where).blink(~red ? 0, ~green ? 0, ~blue ? 0, ~time ? 0.1);
});
)

// klappt natürlich auch ohne Pdef

(
Pdef(\ng_test, Pbind(
	\type, \ng_color,
	\dur, 0.25,
	\red, Pwhite(0.0, 1.0),
	\green, Pseq([0,1],inf),
	\blue, 0.5,
	\where, Prand((0..8),inf)
)).play;
)

(
Pdef(\ng_test2, Pbind(
	\dur, 1/8,
	\type, \ng_blink,
	[\red, \green, \blue], 1!3,
	\time, 0.1,
	\where, Pseq((0..8),inf) 
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