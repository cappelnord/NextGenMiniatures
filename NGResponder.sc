/*
	EmpfŠngt OSC Nachrichten und leitet sie an einen Client weiter
*/

NGResponder {
	
	var <client;
	
	var responders;
	
	*new {|client|
		^super.new.init(client);
	}
	
	init {|a_client|
		client = a_client;
		
		responders = List.new;
		
		responders.add(OSCresponder(nil, "/execute", {|time, resp, msg|
			client.execute(msg[1].interpret);
		}).add);
		
		responders.add(OSCresponder(nil, "/color", {|time, resp, msg|
			client.color(msg[1].asFloat, msg[2].asFloat, msg[3].asFloat);
		}).add);
		
		responders.add(OSCresponder(nil, "/fadeColor", {|time, resp, msg|
			client.color(msg[1].asFloat, msg[2].asFloat, msg[3].asFloat, msg[4].asFloat);
		}).add);
	}
	
	clear {
		responders.do {|r|
			r.remove;	
		};
		
		responders = nil;
	}
}