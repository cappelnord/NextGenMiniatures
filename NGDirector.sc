NGDirector {
	classvar instance_obj;
	classvar <testWindowWidth = 600;
	classvar <testWindowHeight = 600;
	
	var testWindow;
	var <clients;
	
	*new {
		^super.new.init();
	}
	
	init {
		clients = List.new;	
	}
	
	*instance {
		instance_obj.isNil.if {
			instance_obj = NGDirector();
		};
		^instance_obj;
	}
	
	*addTestClient {|id, position|
		this.instance.addTestClient(id, position);	
	}
	
	*addNetClient {|id, position, host|
		this.instance.addNetClient(id, position, host);
	}
	
	addTestClient {|id, position|
		clients = clients.add(TestNGClient(id, position));
	}
	
	addNetClient {|id, position, host|
		clients = clients.add(NetSendNGClient(id, position, host));
	}
	
	testWindow {
		testWindow.isNil.if {
			testWindow = Window.new("NG Test", Rect(100,100, testWindowWidth + 100, testWindowHeight + 100), false);
			// testWindow.front;
		};
		^testWindow;	
	}
	
	at {|where|
		^clients[where];	
	}
	
	
	// these methods are not well programmed
	nearestClient {|location|
		var distance = inf;
		var myDistance;
		var client;
		clients.do {|c|
			myDistance = c.position.dist(location);
			(myDistance < distance).if {
				distance = myDistance;
				client = 	c;
			};
		}
		^client;
	}
}