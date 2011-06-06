NGClient : OutputNGClient {

	var window;
	var <responder;

	*new {|fullscreen=false, osc=true|
		^super.new.init(fullscreen, osc);
	}
	
	init {|fullscreen, osc|
		
		window = Window.new("NGClient", Rect(100, 100, 500, 500), false, fullscreen.not);
		view = window.view;
		
		view.keyDownAction_({ |b, char, modifiers, unicode, keycode|
			(char.toUpper == $E).if {
				this.closeWindow;
			};
		});
		
		this.color(0,0,0);
		
		server = Server.local;
		server.boot;
		server.latency = nil;
		
		fullscreen.if {
			window.fullScreen;
		};
		
		window.front;
		
		osc.ifÊ{
			responder = NGResponder(this);	
		};
	}
	
	closeWindow {
		// eventuell noch weiterer cleanup
		window.close;
		responder.clear;
	}
}