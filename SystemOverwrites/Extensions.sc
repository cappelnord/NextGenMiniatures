+ SynthDef {
	sendNG {
		NGDirector.instance.clients.do {|c|
			this.send(c.server);	
		}
	}
	
	add { arg libname, completionMsg, keepDef = true;
		var	servers, desc = this.asSynthDesc(libname ? \global, keepDef);
		if(libname.isNil) {
			servers = Server.allRunningServers
		} {
			servers = SynthDescLib.getLib(libname).servers
		};
		servers.do { |each|
			each.value.sendMsg("/d_recv", this.asBytes, completionMsg.value(each))
		}
	}
}

	