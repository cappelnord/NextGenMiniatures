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
		
		responders = responders.add(OSCresponder(nil, "/execute", {|time, resp, msg|
			msg = msg[1..];
			msg[0] = msg[0].asString.interpret;
			client.execute(*msg);
		}).add);
		
		responders =responders.add(OSCresponder(nil, "/color", {|time, resp, msg|
			client.color(msg[1].asFloat, msg[2].asFloat, msg[3].asFloat);
		}).add);
		
		responders = responders.add(OSCresponder(nil, "/fadeColor", {|time, resp, msg|
			client.fadeColor(msg[1].asFloat, msg[2].asFloat, msg[3].asFloat, msg[4].asFloat);
		}).add);
		
		responders = responders.add(OSCresponder(nil, "/blink", {|time, resp, msg|
			client.blink(msg[1].asFloat, msg[2].asFloat, msg[3].asFloat, msg[4].asFloat);
		}).add);
	}
	
	clear {
		responders.do {|r|
			r.remove;	
		};
		
		responders = nil;
	}
}