NGDirector {
	classvar instance_obj;
	classvar <>testWindowWidth = 600;
	classvar <>testWindowHeight = 600;
	
	classvar <>compositionBaseDir = "~/";
	
	classvar <>preConcertDelay = 5;
	classvar <>concertPause = 5;
	
	var testWindow;
	
	var concertIterator;
	
	var <clients;
	var <compositions;
	
	*new {
		^super.new.init();
	}
	
	init {
		clients = List.new;
		compositions = List.new;
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
			testWindow.view.background = Color(0,0,0,1);
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
	
	clearCompositions {
		compositions = List.new;	
	}
	
	addComposition {|file|
		var func = this.compositionFile(file).load;
		func.notNil.if {
			compositions = compositions.add(func);
		};
	}
	
	playComposition {|file|
		var func = this.compositionFile(file).load;
		{
			func.value(this);
		}.fork;
	}
	
	compositionFile {|file|
		^(compositionBaseDir ++ file);
	}
	
	startConcert {
		concertIterator = compositions.iter;
		{
			"Concert started. Waiting for first piece".postln;
			preConcertDelay.wait;
			this.nextComposition(false);
		}.fork;
	}
	
	stopConcert {
		"Concert Stopped".postln;
		concertIterator = nil;	
	}
	
	finishComposition {
		concertIterator.notNil.if {
			this.nextComposition;	
		};
	}
	
	nextComposition {|wait=true|
		var next = concertIterator.next;
		
		this.safeBlack;
		
		next.isNil.if ({
			this.stopConcert;
		}, {
			{
				wait.if {
					"Waiting for next piece ...".postln;
					concertPause.wait;
				};
				"Piece started!".postln;
				next.value(this);
			}.fork;
		});	
	}
	
	safeBlack {
		fork {
			3.do {
				clients.do {|client|
					client.color(0,0,0);	
				}
			};
			0.5.wait;	
		};	
	}
}