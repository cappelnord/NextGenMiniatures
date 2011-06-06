// kšnnte man wohl in OutputNGClient integrieren.

AbstractNGClient {
	
	var <position; // point, 0@0 ist oben links
	var <id; // integer
	var <dict;
		
	initBase {|a_id, a_position|
		position = a_position;
		id = a_id;
		
		dict = Dictionary.new;
	}
	
	// spielt ein Synth Objekt ab. Muss eigentlich nur
	// von und NetSend und Test implementiert werden.
	play {|defName, args, target, addAction|
		"play not implemented".warn;	
	}
	
	execute {|func|
		"execute not implemented".warn;	
	}
	
	color {|red, green, blue|
		"color not implemented".warn;
	}
	
	fadeColor {|red, green, blue, time|
		"fadeColor not implemented".warn;
	}
	
	serverName {
		^("ng_" ++ id.asString).asSymbol;	
	}
}