NGClient : OutputNGClient {

	var window;

	*new {|fullscreen=false|
		^super.new.init(fullscreen);
	}
	
	init {|fullscreen|
		window = Window.new("NGClient", Rect(100, 100, 500, 500), false);
		this.view = window.view;
		
		this.color(0,0,0);
		
		window.front;
	
		// ToDo: implement Fullscreen	
	}

	play {|synth|
		// Dies ist für das lokale Server Interface.	
	}
}