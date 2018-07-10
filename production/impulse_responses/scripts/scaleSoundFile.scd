
// scale and trim soundfiles
// used for impresp measurements as sox does not allow for clipping

// rumori 2014-07

f = { arg infile, outfile, scale = 1.0, cut = 0, sampleFormat;

	var sfi, sfo, size = 0, sig;

	sfi = SoundFile.openRead(infile);
	if (sfi.sampleFormat == "float", {
		size = sfi.numFrames * sfi.numChannels;
	});
	sig = Signal.newClear(size);
	sfi.readData(sig);
	if (cut > 0, {
		sig = sig.drop(cut * sfi.numChannels);
	});
	sig.scale(scale);
	sfo = SoundFile.new;
	sfo.headerFormat = "WAV";
	sfo.sampleFormat = (sampleFormat ? sfi.sampleFormat);
	sfo.sampleRate = sfi.sampleRate;
	sfo.numChannels = sfi.numChannels;
	sfo.openWrite(outfile);
	sfo.writeData(sig);
	sfo.close;
	sfi.close;
};

// sonic epistemologies irs 2016-01
p = "~/data/prj/ise_2016-04/ir/aliki/export/raw".standardizePath;
d = "~/data/prj/ise_2016-04/ir/aliki/export/base_48".standardizePath;
q = (p +/+ "se_*.wav").pathMatch;

q.do({ arg file, i;
	"%: %\n".postf(i, file);
	f.value(file, d +/+ "se_" ++ file.basename.drop(3),
		8.0, 2583);
});
