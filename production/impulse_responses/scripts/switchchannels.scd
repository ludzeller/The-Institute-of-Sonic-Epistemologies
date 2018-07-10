// switchchannels.sc
// 2011-02-28 rumori/virtual mumuth/the choreography of sound
// use in conjunction with aliki's trigger/reset commands

// execute block in parentheses with C-M-x (Control-Alt-x)
(

s.waitForBoot({

	d = Pseq((0..11) ++ (16..17), inf).asStream;
	c = d.next;

	x = { arg out = c, in = 0, gain = 1.0; Out.ar(out, SoundIn.ar(in, mul: gain)) }.play;

	OSCresponder.new(nil, "/switch", { arg time, resp, msg;
		c = d.next; x.set(\out, c);
		"switched to channel %".format(c).postln;
	}).add;
	OSCresponder.new(nil, "/sreset", { arg time, resp, msg;
		d.reset; c = d.next; x.set(\out, c);
		"reset to channel 0".postln;
	}).add;

	"sclang listening on port %\n".postf(NetAddr.langPort);
});

)

// EOF
