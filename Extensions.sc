+ SynthDef {
	sendNG {
		NGDirector.instance.clients.do {|c|
			this.send(c.server);	
		}
	}	
}