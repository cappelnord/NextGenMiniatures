/* 
	OutputNGClient enthält Ausgabelogik. NGClient und TestNGClient sagen WO etwas passiert
*/

OutputNGClient : AbstractNGClient {
	
	var task;
	
	var fadeTickRate = 0.05;
	
	// output objects
	var <>view;
	var <>server;
	
	var oldColor = nil;
	
	// Konstruktor der abgeleiteten Klassen müssen view und server erzeugen
	
	execute {|... args|
		var func = args[0];
		args[0] = this;
		func.value(*args);	
	}
	
	play {|defName, args, target, addAction|
		target = target ? this.defaultTarget;
		addAction = addAction ? this.defaultAddAction;
		^Synth(defName, args, target, addAction);
	}
	
	color {|red, green, blue|
		{
			this.resetTask;
			view.background = Color(red, green, blue, 1.0);
		}.defer;
	}
	
	fadeColor {|red, green, blue, time|
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
	
	blink {|red, green, blue, time|
		oldColor.isNil.if {
			oldColor = view.background;	
		};
		
		{
			view.background = Color(red, green, blue, 1.0);
			{
				oldColor.notNil.if {
					view.background = oldColor;
					oldColor = nil;
				};
			}.defer(time);
			
		}.defer;
	}
	
	resetTask {
		task.notNil.if {
			task.stop();
			task = nil;
		};
	}
	
	defaultTarget {
		^server;	
	}
	
	defaultAddAction {
		^\addToHead;	
	}
}