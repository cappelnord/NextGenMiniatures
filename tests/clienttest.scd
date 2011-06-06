// Tests

t = NGClient();

t.color(1, 0, 0);

t.colorFade(0,1,0.5,5);

t.colorFade(1,0,1,0.5);

// Fullscreen Test
(
t = NGClient(true); // e to exit
t.colorFade(1,0,0,10)
)

// Add a Test Net Client (our local NGClient should receive now via OSC)

NGDirector.addNetClient(0, 0@0, "127.0.0.1");
g = NGDirector.instance
g[0].color(1,0,0)
