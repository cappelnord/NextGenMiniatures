TestNGClient : OutputNGClient {
	
	classvar <>simulatePosition = true;
	classvar <>simulateSpeaker = true;
	classvar <>ampulitudeMul = 0.5;
	classvar <>numSimulationSpeakers = 2;
	
	classvar textViewWidth = 90;
	
	classvar nextServerPort = 57130;
	
	var ampMulNode, simPositionNode, simSpeakerNode;
	var frontNode;

	
	*new {|id, position|
		^super.new.init(id, position);
	}
	
	// wir wandeln in src um und zurŸck
	execute {|func|
		super.execute(func.cs.interpret);
	}
	
	init {|id, position|
		var testWindow = NGDirector.instance.testWindow;
		var posRect;
		
		this.initBase(id, position);
		
		server = Server(this.serverName, NetAddr("127.0.0.1", TestNGClient.getServerPort));
		server.boot;
		server.latency = nil;
		// server.makeWindow;
		
		posRect = Rect(
			position.x * NGDirector.testWindowWidth + 50 - (textViewWidth/2),
			position.y * NGDirector.testWindowHeight + 50 - (textViewWidth/2),
			textViewWidth,
			textViewWidth
		);
		
		posRect.postln;
		
		view = StaticText(testWindow, posRect);
		view.string = id.asString;
		view.stringColor = Color(1,1,1,1);
		view.align = \center;
		
		this.color(0,0,0);
		
		{
			this.buildNodes;
		}.defer(3);
	}
	
	play {|defName, args, target, addAction|
		super.play(defName, args, target, addAction);
		
		{
			view.stringColor = Color(1,0,0,1);
			0.1.wait;
			view.stringColor = Color(1,1,1,1);
		}.fork(AppClock);
	}	
	
	*getServerPort {
		nextServerPort = nextServerPort + 1;
		^(nextServerPort - 1);	
	}

	// TODO: Anpassen an Testsituation
	defaultTarget {
		^frontNode;	
	}
	
	defaultAddAction {
		^\addBefore;	
	}
	
	buildNodes {
		
		var azPos = position.x * 2;
		
		(numSimulationSpeakers > 2).if ({
		// TODO: This should be implemented
			SynthDef(\ng_simpos, {
				var sig = Mix.ar(In.ar(0, 2)) / 2;
				ReplaceOut.ar(0, PanAz.ar(numSimulationSpeakers, sig, azPos, orientation:0));
			}).send(server);
		}, {
			SynthDef(\ng_simpos, {
				var sig = Mix.ar(In.ar(0, 2)) / 2;
				ReplaceOut.ar(0, Pan2.ar(sig, position.x * 2 -1));
			}).send(server);
		});
		
		// TODO: implement
		SynthDef(\ng_simspeaker, {
			ReplaceOut.ar(0, In.ar(0,2));
		}).send(server);
		
		SynthDef(\ng_ampmul, {
			ReplaceOut.ar(0, In.ar(0,2) * ampulitudeMul);
		}).send(server);
		
		{
		ampMulNode = Synth(\ng_ampmul, target: server, addAction: \addToTail);
		frontNode = ampMulNode;
		
		simulateSpeaker.if {
			simSpeakerNode = Synth(\ng_simspeaker, target: frontNode, addAction: \addBefore);
			frontNode = simSpeakerNode;
		};
		
		simulatePosition.if {
			simPositionNode = Synth(\ng_simpos, target: frontNode, addAction: \addBefore);
			frontNode = simPositionNode;
		};
		}.defer(0.5);

	}
}