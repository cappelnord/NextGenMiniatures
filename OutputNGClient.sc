/* 
	OutputNGClient enthält Ausgabelogik. NGClient und TestNGClient sagen WO etwas passiert
*/

OutputNGClient : AbstractNGClient {
	
	var <>view;
	var task;
	
	var fadeTickRate = 0.05;
	
	// Konstruktor der abgeleiteten Klassen müssen view erzeugen
	
	// play muss von der abgeleiteten Klasse implementiert werden

	
	/* execute {|source|
		// implement	
	} */
	
	color {|red, green, blue|
		this.resetTask();
		view.background = Color(red, green, blue, 1.0);
	}
	
	colorFade {|red, green, blue, time|
		var color = view.background;
		var targetColor = [red, green, blue];
		var startColor = [color.red, color.green, color.blue];
		var curColor = startColor;
		var deltaColor = targetColor - startColor;
		var steps = time / fadeTickRate;
		var stepColor = deltaColor / steps;
		
		this.resetTask();
		
		task = Task({
			steps.do {
				view.background = Color(curColor[0], curColor[1], curColor[2], 1.0);
				curColor = curColor + stepColor;
				fadeTickRate.wait;
			};
			view.background = Color(red, green, blue, 1.0);
		}, AppClock).play();	
	}
	
	resetTask {
		task.notNil.if {
			task.stop();
			task = nil;
		};
	}
}