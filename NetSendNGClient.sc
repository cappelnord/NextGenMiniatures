/* Leitet Signale via OSC weiter */

NetSendNGClient : OutputNGClient {
	
	var net;
	
	*new {|id, position, host|
		^super.new.init(id, position, host);	
	}
	
	init {|id, position, host|
		this.initBase(id, position);
		
		// the SC App Assumption
		net = NetAddr(host, 57120);
		
		server = Server(this.serverName, NetAddr(host, 57110));
		server.serverRunning_(true);
			
	}
	
	/* OutputNGClient
	play {|synthDef, arguments|
		// Spielt den Synth auf den Server aus 	
	} */
	
	execute {|func|
		net.sendMsg("/execute", func.cs);	
	}
	
	color {|red, green, blue|
		net.sendMsg("/color", red.asFloat, green.asFloat, blue.asFloat);
	}
	
	fadeColor {|red, green, blue, time|
		net.sendMsg("/fadeColor", red.asFloat, green.asFloat, blue.asFloat, time.asFloat);	
	}
}