/* Dient mehr der Dokumentation, bzw. zum Test ob alles vollständig
   implementiert ist
*/

AbstractNGClient {
	
	// spielt ein Synth Objekt ab. Muss eigentlich nur
	// von und NetSend und Test implementiert werden.
	play {|synth|
		"play not implemented".warn;	
	}
	
	execute {|source|
		"execute not implemented".warn;	
	}
	
	color {|red, green, blue|
		"color not implemented".warn;
	}
	
	fadeColor {|red, green, blue, time|
		"fadeColor not implemented".warn;
	}
}