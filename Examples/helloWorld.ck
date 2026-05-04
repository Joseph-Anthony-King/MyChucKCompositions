// connect sine oscillator to D/A convertor (sound card)
SinOsc s => dac;

// set frequency to 440Hz 
440 => s.freq; 

// set time to 2 seconds
2 => int sec;

// allow 2 seconds to pass
sec::second => now;

"Hello World! The tone you heard played at a frequency of " + 
    s.freq() + " Hz, which is equivalent to A4, for " + 
    sec + " seconds." => string message;

<<< message >>>;