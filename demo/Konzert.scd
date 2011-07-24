// Dies ist ein Konzertsetup.

// Erstmal ein paar Einstellungen treffen:

NGDirector.preConcertDelay = 5; // 5 Sekunden Pause bevor das Konzert losgeht
NGDirector.concertPause = 7; // 5 Sekunden Pause zwischen jedem Stück
NGDirector.compositionBaseDir = "/Users/patrick/Desktop/ng/final/"; // Pfad in denen die Kompositionen liegen


( // dauert lange!!
{
(50..65).do {|v,i|
	var point = Point(i%4 * (1/3), (i/4).floor * (1/3));
	NGDirector.addNetClient(i, point, "192.168.1." ++ v);	("192.168.1." ++ v).postln;
	
	0.25.wait; // wir hatten mit Grainface mal Probleme, wenn wir mehrere Server gleichzeitig starten
};
}.fork(AppClock);
)


// Wenn ihr nur einen Kompositionsfile abspielen wollt dann macht das hiermit:
NGDirector.instance.playComposition("bg.scd");

( // Hier laden wir die Kompositionen.
  // Zu diesem Zeitpunkt sollten alle Clients bereits gestartet haben
  
["dk.scd", "ja.scd", "bg.scd", "pb.scd", "hb.scd", "fs.scd", "ms.scd", "th.scd"].do {|file|
	NGDirector.instance.addComposition(file);	
};
)

// And BOOM goes the dynamite.
NGDirector.instance.startConcert;

