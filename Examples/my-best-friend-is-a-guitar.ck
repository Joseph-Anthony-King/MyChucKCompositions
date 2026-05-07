// ============================================================================
// My Best Friend is a Guitar
// By The Menshevik
// ChucK Script - Mandolin Version
// ============================================================================
// TEMPO: 120 BPM
// KEY: G Mixolydian
// TIME SIGNATURE: 4/4
// ============================================================================

// ----------------------------------------------------------------------------
// SETUP SECTION
// ----------------------------------------------------------------------------

// Define tempo (120 BPM = 500ms per quarter note)
120 => int BPM;
60000.0 / BPM => float quarterNote;  // Duration of quarter note in milliseconds
quarterNote / 2.0 => float eighthNote;  // Duration of eighth note

// Create mandolin instrument using STK (Synthesis ToolKit)
// Mandolin is a plucked string instrument similar to guitar but with different timbre
Mandolin mando => NRev reverb => dac;

// Configure reverb for more realistic sound
0.05 => reverb.mix;  // 5% reverb mix (subtle room ambiance)

// Set default mandolin parameters
0.8 => mando.gain;  // Volume level (0.0 to 1.0)
0.5 => mando.stringDamping;  // How quickly strings stop vibrating
0.3 => mando.stringDetune;  // Slight detuning for realistic chorus effect
0.9 => mando.bodySize;  // Size of instrument body (affects resonance)

// ----------------------------------------------------------------------------
// GUITAR TO MIDI NOTE CONVERSION
// ----------------------------------------------------------------------------
// Standard guitar tuning (low to high string):
// String 6 (E): E2 = MIDI 40
// String 5 (A): A2 = MIDI 45  
// String 4 (D): D3 = MIDI 50
// String 3 (G): G3 = MIDI 55
// String 2 (B): B3 = MIDI 59
// String 1 (E): E4 = MIDI 64
//
// Each fret adds 1 semitone (1 MIDI note)
// Example: String 6, Fret 3 = E2 + 3 = G2 = MIDI 43

// Function to convert guitar tab to MIDI note
// Parameters: string (1-6, where 6 is low E), fret number (0-24)
// Returns: MIDI note number
fun int tabToMidi(int guitarString, int fret) {
    // Define open string MIDI notes (standard guitar tuning)
    [64, 59, 55, 50, 45, 40] @=> int openStrings[];  // E B G D A E (high to low)
    
    // Calculate MIDI note: open string + fret number
    return openStrings[guitarString - 1] + fret;
}

// ----------------------------------------------------------------------------
// NOTE PLAYING FUNCTIONS
// ----------------------------------------------------------------------------

// Play a single note with specified duration
// Parameters: MIDI note number, duration in milliseconds, velocity (0.0-1.0)
fun void playNote(int midiNote, float duration, float velocity) {
    // Convert MIDI note to frequency: f = 440 * 2^((n-69)/12)
    Std.mtof(midiNote) => float frequency;
    
    // Set frequency and pluck the string
    frequency => mando.freq;
    velocity => mando.pluck;
    
    // Wait for the specified duration
    duration::ms => now;
}

// Play a chord (multiple notes together)
// Parameters: array of MIDI notes, duration, velocity
fun void playChord(int notes[], float duration, float velocity) {
    // Pluck all strings in the chord rapidly (strumming effect)
    for (0 => int i; i < notes.size(); i++) {
        if (notes[i] > 0) {  // Only play if note exists (not muted)
            Std.mtof(notes[i]) => mando.freq;
            velocity => mando.pluck;
            3::ms => now;  // Small delay between strings for strum effect
        }
    }
    
    // Let the chord ring for remaining duration
    (duration - (notes.size() * 3))::ms => now;
}

// ----------------------------------------------------------------------------
// CHORD DEFINITIONS - UPDATED BASED ON TABLATURE
// ----------------------------------------------------------------------------
// Each chord is defined as an array of MIDI notes
// Based on the chord diagrams in the tablature file

// G7 chord (E=1, B=0, G=0, D=0, A=2, E=3)
fun int[] chordG7() {
    int notes[6];
    tabToMidi(1, 1) => notes[0];  // String 1: fret 1 = F4
    tabToMidi(2, 0) => notes[1];  // String 2: open = B3
    tabToMidi(3, 0) => notes[2];  // String 3: open = G3
    tabToMidi(4, 0) => notes[3];  // String 4: open = D3
    tabToMidi(5, 2) => notes[4];  // String 5: fret 2 = B2
    tabToMidi(6, 3) => notes[5];  // String 6: fret 3 = G2
    return notes;
}

// GM (G Major) chord with variation (E=3, B=0, G=0, D=0, A=2, E=3)
fun int[] chordGM() {
    int notes[6];
    tabToMidi(1, 3) => notes[0];  // String 1: fret 3 = G4
    tabToMidi(2, 0) => notes[1];  // String 2: open = B3
    tabToMidi(3, 0) => notes[2];  // String 3: open = G3
    tabToMidi(4, 0) => notes[3];  // String 4: open = D3
    tabToMidi(5, 2) => notes[4];  // String 5: fret 2 = B2
    tabToMidi(6, 3) => notes[5];  // String 6: fret 3 = G2
    return notes;
}

// CM (C Major) chord (E=0, B=1, G=0, D=2, A=3, E=X)
fun int[] chordCM() {
    int notes[5];
    tabToMidi(1, 0) => notes[0];  // String 1: open = E4
    tabToMidi(2, 1) => notes[1];  // String 2: fret 1 = C4
    tabToMidi(3, 0) => notes[2];  // String 3: open = G3
    tabToMidi(4, 2) => notes[3];  // String 4: fret 2 = E3
    tabToMidi(5, 3) => notes[4];  // String 5: fret 3 = C3
    return notes;
}

// CM with high G (E=0, B=1, G=3, D=2, A=3, E=X)
fun int[] chordC7() {
    int notes[5];
    tabToMidi(1, 0) => notes[0];  // String 1: open = E4
    tabToMidi(2, 1) => notes[1];  // String 2: fret 1 = C4
    tabToMidi(3, 3) => notes[2];  // String 3: fret 3 = Bb3
    tabToMidi(4, 2) => notes[3];  // String 4: fret 2 = E3
    tabToMidi(5, 3) => notes[4];  // String 5: fret 3 = C3
    return notes;
}

// Am chord (E=0, B=1, G=0, D=2, A=0, E=X)
fun int[] chordAm() {
    int notes[5];
    tabToMidi(1, 0) => notes[0];  // String 1: open = E4
    tabToMidi(2, 1) => notes[1];  // String 2: fret 1 = C4
    tabToMidi(3, 0) => notes[2];  // String 3: open = G3
    tabToMidi(4, 2) => notes[3];  // String 4: fret 2 = E3
    tabToMidi(5, 0) => notes[4];  // String 5: open = A2
    return notes;
}

// Am with high G (E=0, B=1, G=2, D=2, A=0, E=X)
fun int[] chordAm7() {
    int notes[5];
    tabToMidi(1, 0) => notes[0];  // String 1: open = E4
    tabToMidi(2, 1) => notes[1];  // String 2: fret 1 = C4
    tabToMidi(3, 2) => notes[2];  // String 3: fret 2 = A3
    tabToMidi(4, 2) => notes[3];  // String 4: fret 2 = E3
    tabToMidi(5, 0) => notes[4];  // String 5: open = A2
    return notes;
}

// Dm chord (E=1, B=1, G=2, D=0, A=X, E=X)
fun int[] chordDm7() {
    int notes[4];
    tabToMidi(1, 1) => notes[0];  // String 1: fret 1 = F4
    tabToMidi(2, 1) => notes[1];  // String 2: fret 1 = C4
    tabToMidi(3, 2) => notes[2];  // String 3: fret 2 = A3
    tabToMidi(4, 0) => notes[3];  // String 4: open = D3
    return notes;
}

// Dm with high B (E=1, B=3, G=2, D=0, A=X, E=X) - used in some measures
fun int[] chordDm() {
    int notes[4];
    tabToMidi(1, 1) => notes[0];  // String 1: fret 1 = F4
    tabToMidi(2, 3) => notes[1];  // String 2: fret 3 = D4
    tabToMidi(3, 2) => notes[2];  // String 3: fret 2 = A3
    tabToMidi(4, 0) => notes[3];  // String 4: open = D3
    return notes;
}

// ----------------------------------------------------------------------------
// RHYTHM PATTERN FUNCTIONS (FROM FIXED VERSION)
// ----------------------------------------------------------------------------
// These functions implement the specific rhythm patterns from the tablature
// Counting notation: 1 & 2 & 3 & 4 &
// Each number is a quarter note beat, each & is an eighth note offbeat

// Pattern 1: Quarter, eighth, quarter, eighth eighth eighth
// Counting: 1   2 &   & 4 &
// Used in measures 1-6, 9-14, etc.
fun void playPattern1(int chord1[], int chord2[]) {
    // Beat 1: Quarter note
    playChord(chord1, quarterNote, 0.8);
    
    // Beat 2: Eighth note
    playChord(chord1, eighthNote, 0.7);
    
    // Beat 2&: Quarter note
    playChord(chord1, quarterNote, 0.8);
    
    // Beat 3&: Eighth note
    playChord(chord2, eighthNote, 0.7);
    
    // Beat 4: Eighth note
    playChord(chord2, eighthNote, 0.7);
    
    // Beat 4&: Eighth note
    playChord(chord2, eighthNote, 0.7);
}

// Pattern 2: Quarter, eighth, eighth, quarter, eighth eighth
// Counting: 1   2 & 3   4 &
// Used in measures 7-8, 15-16, etc.
fun void playPattern2(int chord1[], int chord2[]) {
    // Beat 1: Quarter note
    playChord(chord1, quarterNote, 0.8);
    
    // Beat 2: Eighth note
    playChord(chord1, eighthNote, 0.7);
    
    // Beat 2&: Eighth note
    playChord(chord1, eighthNote, 0.7);
    
    // Beat 3: Quarter note
    playChord(chord2, quarterNote, 0.8);
    
    // Beat 4: Eighth note
    playChord(chord2, eighthNote, 0.7);
    
    // Beat 4&: Eighth note
    playChord(chord2, eighthNote, 0.7);
}

// Pattern 3: Quarter, eighth, quarter, eighth eighth (no final eighth)
// Counting: 1   2 &   & 4
// Used in measures 25-30 (chorus sections)
fun void playPattern3(int chord1[]) {
    // Beat 1: Quarter note
    playChord(chord1, quarterNote, 0.8);
    
    // Beat 2: Eighth note
    playChord(chord1, eighthNote, 0.7);
    
    // Beat 2&: Quarter note
    playChord(chord1, quarterNote, 0.8);
    
    // Beat 3&: Eighth note
    playChord(chord1, eighthNote, 0.7);
    
    // Beat 4: Eighth note
    playChord(chord1, eighthNote, 0.7);
}

// ----------------------------------------------------------------------------
// SONG SECTION FUNCTIONS - UPDATED CHORD PROGRESSIONS
// ----------------------------------------------------------------------------

// Play the Intro (Measures 1-8)
fun void playIntro() {
    <<< "Playing Intro (Measures 1-8)..." >>>;
    
    // Measures 1: G7 → GM
    playPattern1(chordG7(), chordGM());
    
    // Measures 2: CM → C7
    playPattern1(chordCM(), chordC7());
    
    // Measures 3: G7 → GM
    playPattern1(chordG7(), chordGM());

    // Measures 4: Dm7 → Dm
    playPattern1(chordDm7(), chordDm());

    // Measures 5: G7 → GM
    playPattern1(chordG7(), chordGM());
    
    // Measures 6: Am7 → Am
    playPattern1(chordAm7(), chordAm());
    
    // Measures 7-8: G7/Am → G7
    playPattern2(chordG7(), chordAm());
    playPattern3(chordGM());
}

// Play a Verse (Measures 9-24, or 33-48, or 57-72)
fun void playVerse(string verseName) {
    <<< "Playing", verseName, "(16 measures)..." >>>;
    
    // First 8 measures (9-16 or 33-40 or 57-64)
    // Measures 1-2: G7 → GM
    playPattern1(chordG7(), chordGM());
    
    // Measures 3-4: CM → C7
    playPattern1(chordCM(), chordC7());
    
    // Measures 5-6: G7 → GM
    playPattern1(chordG7(), chordGM());

    // Measures 4: Dm7 → Dm
    playPattern1(chordDm7(), chordDm());

    // Measures 5: G7 → GM
    playPattern1(chordG7(), chordGM());
    
    // Measures 6: Am7 → Am
    playPattern1(chordAm7(), chordAm());
    
    // Measures 7-8: G7/Am → G7
    playPattern2(chordG7(), chordAm());
    playPattern3(chordGM());
    
    // Second 8 measures (17-24 or 41-48 or 65-72)
    // Measures 1-2: G7 → GM
    playPattern1(chordG7(), chordGM());
    
    // Measures 3-4: CM → C7
    playPattern1(chordCM(), chordC7());
    
    // Measures 5-6: G7 → GM
    playPattern1(chordG7(), chordGM());

    // Measures 4: Dm7 → Dm
    playPattern1(chordDm7(), chordDm());

    // Measures 5: G7 → GM
    playPattern1(chordG7(), chordGM());
    
    // Measures 6: Am7 → Am
    playPattern1(chordAm7(), chordAm());    

    // Measures 7-8: G7/Am → G7
    playPattern2(chordG7(), chordAm());
    playPattern3(chordGM());
}

// Play a Chorus (Measures 25-32, or 49-56, or 73-80)
fun void playChorus() {
    <<< "Playing Chorus (8 measures)..." >>>;
    
    // Measures 1-2: G7 → Am
    playPattern3(chordG7());
    playPattern3(chordAm());
    
    // Measures 3-4: Dm7 → Am
    playPattern3(chordDm7());
    playPattern3(chordAm());
    
    // Measures 5-6: G7 → Am
    playPattern3(chordG7());
    playPattern3(chordAm());
    
    // Measures 7-8: G7/Am → GM
    playPattern2(chordG7(), chordAm());
    playPattern3(chordGM());
}

// Play the Outro (Measures 81-88)
fun void playOutro() {
    <<< "Playing Outro (Measures 81-88)..." >>>;
    
    // Measures 81: G7 → GM
    playPattern1(chordG7(), chordGM());
    
    // Measures 82: CM → C7
    playPattern1(chordCM(), chordC7());
    
    // Measures 83: G7 → GM
    playPattern1(chordG7(), chordGM());

    // Measures 84: Dm7 → Dm
    playPattern1(chordDm7(), chordDm());

    // Measures 85: G7 → GM
    playPattern1(chordG7(), chordGM());
    
    // Measures 86: Am7 → Am
    playPattern1(chordAm7(), chordAm());
    
    // Measures 87: G7/Am → G7
    playPattern2(chordG7(), chordAm());
    
    // Final chord - let it ring
    <<< "Final chord - letting it ring..." >>>;
    playChord(chordGM(), quarterNote * 4, 0.9);  // Whole note with sustain
}

// ----------------------------------------------------------------------------
// MAIN PROGRAM
// ----------------------------------------------------------------------------

<<< "============================================" >>>;
<<< "My Best Friend is a Guitar - Version 2" >>>;
<<< "By The Menshevik" >>>;
<<< "Performed on Mandolin" >>>;
<<< "Updated Chord Progressions" >>>;
<<< "Tempo: 120 BPM | Key: G Mixolydian" >>>;
<<< "============================================" >>>;
<<< "" >>>;

// Song Structure: Intro → Verse → Chorus → Verse → Chorus → Verse → Chorus → Outro

// Add a brief pause before starting
500::ms => now;

// Play the complete song
playIntro();
playVerse("Verse 1");
playChorus();
playVerse("Verse 2");
playChorus();
playVerse("Verse 3");
playChorus();
playOutro();

<<< "" >>>;
<<< "============================================" >>>;
<<< "Song Complete!" >>>;
<<< "============================================" >>>;

// Hold the final note a bit longer
1::second => now;
