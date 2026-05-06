// ============================================================================
// MY BEST FRIEND IS A GUITAR - Complete Song
// By The Menshevik
// Copyright © 2026
// 
// Full arrangement with Intro, Verses, Choruses, and Outro
// Based on tablature rhythm and chord progressions
// ============================================================================

// ============================================================================
// AUDIO SETUP
// ============================================================================
Mandolin mando => JCRev reverb => dac;
0.1 => reverb.mix;

// ============================================================================
// TEMPO AND RHYTHM SETUP (120 BPM in 4/4 time)
// ============================================================================
120.0 => float BPM;
(60.0 / BPM) * 1000::ms => dur quarterNote;  // 500ms
quarterNote / 2 => dur eighthNote;           // 250ms

// ============================================================================
// GUITAR STRING TUNING (Standard: E A D G B E)
// ============================================================================
[40, 45, 50, 55, 59, 64] @=> int openStrings[];

fun int fretToMidi(int stringNum, int fret) {
    if (fret < 0) return -1;
    return openStrings[stringNum] + fret;
}

// ============================================================================
// CHORD PLAYING FUNCTION
// ============================================================================
fun void playChord(int e6, int a5, int d4, int g3, int b2, int e1) {
    5::ms => dur strumDelay;
    0.7 => mando.pluckPos;
    
    fretToMidi(0, e6) => int noteE6;
    fretToMidi(1, a5) => int noteA5;
    fretToMidi(2, d4) => int noteD4;
    fretToMidi(3, g3) => int noteG3;
    fretToMidi(4, b2) => int noteB2;
    fretToMidi(5, e1) => int noteE1;
    
    if (noteE6 >= 0) {
        Std.mtof(noteE6) => mando.freq;
        0.6 => mando.pluck;
        strumDelay => now;
    }
    if (noteA5 >= 0) {
        Std.mtof(noteA5) => mando.freq;
        0.6 => mando.pluck;
        strumDelay => now;
    }
    if (noteD4 >= 0) {
        Std.mtof(noteD4) => mando.freq;
        0.6 => mando.pluck;
        strumDelay => now;
    }
    if (noteG3 >= 0) {
        Std.mtof(noteG3) => mando.freq;
        0.6 => mando.pluck;
        strumDelay => now;
    }
    if (noteB2 >= 0) {
        Std.mtof(noteB2) => mando.freq;
        0.6 => mando.pluck;
        strumDelay => now;
    }
    if (noteE1 >= 0) {
        Std.mtof(noteE1) => mando.freq;
        0.6 => mando.pluck;
        strumDelay => now;
    }
}

fun void playAndWait(int e6, int a5, int d4, int g3, int b2, int e1, dur waitTime) {
    playChord(e6, a5, d4, g3, b2, e1);
    waitTime => now;
}

// ============================================================================
// CHORD DEFINITIONS (from tablature)
// Format: [lowE, A, D, G, B, highE]
// ============================================================================
[3, 2, 0, 0, 0, 1] @=> int G7[];      // G7 chord
[3, 2, 0, 0, 0, 3] @=> int GM[];      // G major (high voicing)
[-1, 3, 2, 0, 1, 0] @=> int CM[];     // C major
[-1, 3, 2, 3, 1, 0] @=> int C7[];     // C7
[-1, -1, 0, 2, 3, 1] @=> int Dm[];    // D minor
[-1, -1, 0, 2, 1, 1] @=> int Dm7[];   // D minor 7
[-1, 0, 2, 0, 1, 0] @=> int Am7[];    // A minor 7

// ============================================================================
// RHYTHM PATTERN FUNCTIONS
// Based on tablature spacing: Q-E-Q-E-E-E = Quarter-Eighth-Quarter-Eighth-Eighth-Eighth
// ============================================================================

// PATTERN A: Standard 6-note measure (Q-E-Q-E-E-E)
// Example from tab: --1-----1--1-----3--3--3----|
fun void playPattern_QEQEEE(int c1[], int c2[], int c3[], int c4[], int c5[], int c6[]) {
    playAndWait(c1[0], c1[1], c1[2], c1[3], c1[4], c1[5], quarterNote);
    playAndWait(c2[0], c2[1], c2[2], c2[3], c2[4], c2[5], eighthNote);
    playAndWait(c3[0], c3[1], c3[2], c3[3], c3[4], c3[5], quarterNote);
    playAndWait(c4[0], c4[1], c4[2], c4[3], c4[4], c4[5], eighthNote);
    playAndWait(c5[0], c5[1], c5[2], c5[3], c5[4], c5[5], eighthNote);
    playAndWait(c6[0], c6[1], c6[2], c6[3], c6[4], c6[5], eighthNote);
}

// PATTERN B: 5-note measure (Q-E-Q-E-E + rest)
// Example from tab: --1-----1--1-----1--1-------|
fun void playPattern_QEQEE(int c1[], int c2[], int c3[], int c4[], int c5[]) {
    playAndWait(c1[0], c1[1], c1[2], c1[3], c1[4], c1[5], quarterNote);
    playAndWait(c2[0], c2[1], c2[2], c2[3], c2[4], c2[5], eighthNote);
    playAndWait(c3[0], c3[1], c3[2], c3[3], c3[4], c3[5], quarterNote);
    playAndWait(c4[0], c4[1], c4[2], c4[3], c4[4], c4[5], eighthNote);
    playAndWait(c5[0], c5[1], c5[2], c5[3], c5[4], c5[5], eighthNote);
    eighthNote => now;  // Rest
}

// PATTERN C: 4-note ending (Q-E-E-E + rest)
// Example from tab: --3-----3--3--3-------------|
fun void playPattern_QEEE(int c1[], int c2[], int c3[], int c4[]) {
    playAndWait(c1[0], c1[1], c1[2], c1[3], c1[4], c1[5], quarterNote);
    playAndWait(c2[0], c2[1], c2[2], c2[3], c2[4], c2[5], eighthNote);
    playAndWait(c3[0], c3[1], c3[2], c3[3], c3[4], c3[5], eighthNote);
    playAndWait(c4[0], c4[1], c4[2], c4[3], c4[4], c4[5], eighthNote);
    quarterNote + eighthNote => now;  // Rest (1.5 beats)
}

// ============================================================================
// SONG SECTIONS BASED ON CHORD PROGRESSION AND TABLATURE
// ============================================================================

// MEASURE PAIR 1: G7→GM to CM→C7→CM (from measures 1-2 of tab)
fun void playMeasures_G_to_C() {
    // Measure 1: G7→G7→G7→GM→GM→GM
    playPattern_QEQEEE(G7, G7, G7, GM, GM, GM);
    // Measure 2: CM→C7→C7→C7→C7→CM
    playPattern_QEQEEE(CM, C7, C7, C7, C7, CM);
}

// MEASURE PAIR 2: G7→GM to CM→Dm7→Dm (from measures 3-4 of tab)
fun void playMeasures_G_to_Dm() {
    // Measure 3: G7→G7→G7→GM→GM→GM
    playPattern_QEQEEE(G7, G7, G7, GM, GM, GM);
    // Measure 4: CM→CM→CM→Dm→Dm→Dm (or Dm7→Dm7→Dm7→Dm→Dm→Dm based on context)
    playPattern_QEQEEE(Dm7, Dm7, Dm7, Dm, Dm, Dm);
}

// MEASURE PAIR 3: G7→GM to CM (sustained) - from measures 5-6 of tab
fun void playMeasures_G_to_C_sustained() {
    // Measure 5: G7→G7→G7→GM→GM→GM
    playPattern_QEQEEE(G7, G7, G7, GM, GM, GM);
    // Measure 6: CM sustained (all same chord)
    playPattern_QEQEEE(CM, CM, CM, CM, CM, CM);
}

// MEASURE PAIR 4: G7→GM to Am7→GM (ending phrase) - from measures 7-8 of tab
fun void playMeasures_G_to_Am_ending() {
    // Measure 7: G7→G7→G7→Am7→Am7→Am7
    playPattern_QEQEEE(G7, G7, G7, Am7, Am7, Am7);
    // Measure 8: GM ending (4 notes then rest)
    playPattern_QEEE(GM, GM, GM, GM);
}

// ============================================================================
// INTRO/OUTRO SECTION
// Chord progression: G7→GM→CM→C7→CM→G7→GM→CM→Dm7→Dm→G7→GM→CM→C7→CM→G7→Am7→GM
// This is 2 complete verse patterns
// ============================================================================
fun void playIntroOutro() {
    // First half: G7→GM→CM→C7→CM→G7→GM→CM→Dm7→Dm
    playMeasures_G_to_C();      // G7→GM→CM→C7→CM (2 measures)
    playMeasures_G_to_Dm();     // G7→GM→Dm7→Dm (2 measures)
    
    // Second half: G7→GM→CM→C7→CM→G7→Am7→GM
    playMeasures_G_to_C();      // G7→GM→CM→C7→CM (2 measures)
    playMeasures_G_to_Am_ending(); // G7→Am7→GM (2 measures)
}

// ============================================================================
// VERSE SECTION
// Each verse has two complete progressions (4 lines of lyrics)
// Chord progression: (G7→GM→CM→C7→CM→G7→GM→CM→Dm7→Dm→G7→GM→CM→C7→CM→G7→Am7→GM) x2
// ============================================================================
fun void playVerse() {
    // First half of verse (first 2 lines of lyrics)
    playMeasures_G_to_C();      // G7→GM→CM→C7→CM
    playMeasures_G_to_Dm();     // G7→GM→Dm7→Dm
    playMeasures_G_to_C();      // G7→GM→CM→C7→CM
    playMeasures_G_to_Am_ending(); // G7→Am7→GM
    
    // Second half of verse (second 2 lines of lyrics)
    playMeasures_G_to_C();      // G7→GM→CM→C7→CM
    playMeasures_G_to_Dm();     // G7→GM→Dm7→Dm
    playMeasures_G_to_C();      // G7→GM→CM→C7→CM
    playMeasures_G_to_Am_ending(); // G7→Am7→GM
}

// ============================================================================
// CHORUS SECTION
// Chord progression: G7→Am7→Dm7→Am7→G7→Am7→Dm7→Am7→G7→Am7→G7→Am7→GM
// From tablature measures 13-23 (bridge sections with 5-note patterns)
// ============================================================================
fun void playChorus() {
    // Line 1: G7→Am7→Dm7→Am7 (measures 13-16 of tab, 5-note patterns)
    playPattern_QEQEE(G7, G7, G7, G7, G7);      // G7
    playPattern_QEQEE(Am7, Am7, Am7, Am7, Am7); // Am7
    playPattern_QEQEE(Dm7, Dm7, Dm7, Dm7, Dm7); // Dm7
    playPattern_QEQEE(Am7, Am7, Am7, Am7, Am7); // Am7
    
    // Line 2: G7→Am7→Dm7→Am7 (measures 17-20 of tab, 5-note patterns)
    playPattern_QEQEE(G7, G7, G7, G7, G7);      // G7
    playPattern_QEQEE(Am7, Am7, Am7, Am7, Am7); // Am7
    playPattern_QEQEE(Dm7, Dm7, Dm7, Dm7, Dm7); // Dm7
    playPattern_QEQEE(Am7, Am7, Am7, Am7, Am7); // Am7
    
    // Line 3: G7→Am7→G7→Am7→GM (final resolution)
    playPattern_QEQEE(G7, G7, G7, G7, G7);      // G7
    playPattern_QEQEE(Am7, Am7, Am7, Am7, Am7); // Am7
    playPattern_QEQEE(G7, G7, G7, G7, G7);      // G7
    playPattern_QEQEE(Am7, Am7, Am7, Am7, Am7); // Am7
    playPattern_QEEE(GM, GM, GM, GM);           // GM ending
}

// ============================================================================
// MAIN SONG STRUCTURE
// Intro → Verse → Chorus → Verse → Chorus → Verse → Chorus → Outro
// ============================================================================

<<< "" >>>;
<<< "========================================" >>>;
<<< "MY BEST FRIEND IS A GUITAR" >>>;
<<< "By The Menshevik" >>>;
<<< "Copyright © 2026" >>>;
<<< "========================================" >>>;
<<< "Tempo: 120 BPM | Key: G Mixolydian" >>>;
<<< "Instrument: Mandolin" >>>;
<<< "========================================" >>>;
<<< "" >>>;

// INTRO
<<< "INTRO" >>>;
playIntroOutro();
1::second => now;  // Brief pause

// VERSE 1
<<< "VERSE 1" >>>;
<<< "  'Me and my guitar, I'll never be alone...'" >>>;
playVerse();
500::ms => now;  // Brief pause

// CHORUS 1
<<< "CHORUS 1" >>>;
<<< "  'My best friend is a guitar...'" >>>;
playChorus();
500::ms => now;

// VERSE 2
<<< "VERSE 2" >>>;
<<< "  'Me and my guitar, It's the best astrology...'" >>>;
playVerse();
500::ms => now;

// CHORUS 2
<<< "CHORUS 2" >>>;
<<< "  'My best friend is a guitar...'" >>>;
playChorus();
500::ms => now;

// VERSE 3
<<< "VERSE 3" >>>;
<<< "  'Me and my guitar, I don't need no job...'" >>>;
playVerse();
500::ms => now;

// CHORUS 3
<<< "CHORUS 3" >>>;
<<< "  'My best friend is a guitar...'" >>>;
playChorus();
500::ms => now;

// OUTRO
<<< "OUTRO" >>>;
playIntroOutro();

// Let final notes ring
2::second => now;

<<< "" >>>;
<<< "========================================" >>>;
<<< " COMPOSITION COMPLETE " >>>;
<<< "========================================" >>>;
<<< "" >>>;

// ============================================================================
// HOW THIS TRANSLATION WORKS:
// ============================================================================
// 
// 1. RHYTHM FROM TABLATURE:
//    - Character spacing in tab indicates timing
//    - --X-----X--X-----X--X--X----| = Q-E-Q-E-E-E rhythm
//    - --X-----X--X-----X--X-------| = Q-E-Q-E-E rhythm (+ rest)
//    - --X-----X--X--X-------------| = Q-E-E-E rhythm (+ rest)
//
// 2. CHORD READING:
//    - Each vertical slice in tab = one chord voicing
//    - Numbers indicate frets on each string
//    - Chords change where fret numbers change
//
// 3. SONG STRUCTURE:
//    - Intro/Outro: 16 measures (full verse pattern twice)
//    - Verse: 16 measures (8 chord changes × 2 measures each)
//    - Chorus: 13 measures (different rhythm, bridge-style)
//
// 4. MANDOLIN SIMULATION:
//    - STK Mandolin uses physical modeling
//    - .pluck parameter triggers string
//    - .freq sets pitch
//    - Strum delay creates realistic chord spread
// ============================================================================
