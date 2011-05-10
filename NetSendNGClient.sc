/* Leitet Signale via OSC weiter */

NetSendNGClient : AbstractNGClient {
	
	var net;
	var server;
	
	play {|synth|
		// Spielt den Synth auf den Server aus 	
	}
	
	execute {|source|
		net.sendMsg("/execute", source.asString);	
	}
	
	color {|red, green, blue|
		net.sendMsg("/color", red.asFloat, green.asFloat, blue.asFloat);
	}
	
	fadeColor {|red, green, blue, time|
		net.sendMsg("/fadeColor", red.asFloat, green.asFloat, blue.asFloat, time.asFloat);	
	}
}