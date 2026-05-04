// connect sine oscillator to D/A convertor (sound card)
SinOsc s => dac;

// set frequency to 440Hz 
440 => s.freq; 

// allow 2 seconds to pass
2::second => now;

<<< "Hello World!" >>>;