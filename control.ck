NanoKontrol2 nano;

OscOut out[2];

["127.0.0.1", "198.167.1.11"] @=> string IP[];
12345 => int OUT_PORT;

// pitches
float tonic[4];
512 => tonic[0];
tonic[0] * 3.0/2.0 => tonic[1];
tonic[0] * 2.0/1.0 => tonic[2];
tonic[2] * 5.0/4.0 => tonic[3];

float dom[4];
tonic[0] * 3.0/2.0 => dom[0];
dom[0] * 2.0/1.0 => dom[1];
dom[1] * 5.0/4.0 => dom[2];
dom[1] * 7.0/4.0 => dom[3];

float tonicRatio[4];
5.0/4.0 => tonicRatio[0];
5.0/4.0 => tonicRatio[1];
7.0/6.0 => tonicRatio[2];
10.0/9.0 => tonicRatio[3];

float domRatio[4];
5.0/4.0 => domRatio[0];
5.0/4.0 => domRatio[1];
5.0/4.0 => domRatio[2];
6.0/5.0 => domRatio[3];

<<< "Tonic:", tonic[0], tonic[1], tonic[2], tonic[3], "" >>>;
<<< "Dominant", dom[0], dom[1], dom[2], dom[3], "" >>>;

int chordState;
1 => int whichChord;

for (0 => int i; i < 2; i++) {
    out[i].dest(IP[i], OUT_PORT);
}

4 => int NUM_TYPES;

[0, 2, 4, 6] @=> int ratioKnob[];
[1, 3, 5, 7] @=> int windowKnob[];

int ratioMIDI[4];
int windowMIDI[4];

[0, 2, 4, 6] @=> int freqSlider[];
[1, 3, 5, 7] @=> int gainSlider[];

int freqMIDI[4];
int gainMIDI[4];

[1, 3, 5, 7] @=> int AMButton[];
int AMState[4];

int prevRatioMIDI[4];
int prevWindowMIDI[4];
int prevFreqMIDI[4];
int prevGainMIDI[4];

fun void control() {
    for(0 => int i; i < NUM_TYPES; i++) {
        nano.knob[ratioKnob[i]] => ratioMIDI[i];
        nano.knob[windowKnob[i]] => windowMIDI[i];
        nano.slider[freqSlider[i]] => freqMIDI[i];
        nano.slider[windowKnob[i]] => gainMIDI[i];
    }

    for(0 => int i; i < NUM_TYPES; i++) {
        if (nano.rec[AMButton[i]] > 0 && AMState[i] == 0) {
            1 => AMState[i];
            AMSend(i);
        }
        if (nano.rec[AMButton[i]] == 0 && AMState[i] == 1) {
            0 => AMState[i];
        }
    }

    if (nano.record > 0 && chordState == 0) {
        1 => chordState;
        (whichChord + 1) % 2 => whichChord;
        switchChord(whichChord);
    }
    if (nano.record < 127 && chordState == 1) {
        0 => chordState;
    };
    checkForChange();
}


fun void checkForChange() {
    for (0 => int i; i < NUM_TYPES; i++) {
        if (ratioMIDI[i] != prevRatioMIDI[i]) {
            ratioMIDI[i] => prevRatioMIDI[i];
            send("/r", i, ratioMIDI[i]);
        }
        if (windowMIDI[i] != prevWindowMIDI[i]) {
            windowMIDI[i] => prevWindowMIDI[i];
            send("/w", i, windowMIDI[i]);
        }
        if (freqMIDI[i] != prevFreqMIDI[i]) {
            freqMIDI[i] => prevFreqMIDI[i];
            send("/f", i, freqMIDI[i]);

        }
        if (gainMIDI[i] != prevGainMIDI[i]) {
            gainMIDI[i] => prevGainMIDI[i];
            send("/g", i, gainMIDI[i]);
        }
    }
}

fun void switchChord(int whichChord) {
    if (whichChord == 0) {
        for (int i; i < NUM_TYPES; i++) {
            sendFloat("/minFreq", i, tonic[i]);
            sendFloat("/minRatio", i, tonicRatio[i]);
        }
        <<< "Tonic", "" >>>;
    }
    else if (whichChord == 1) {
        for (int i; i < NUM_TYPES; i++) {
            sendFloat("/minFreq", i, dom[i]);
            sendFloat("/minRatio", i, domRatio[i]);
        }
        <<< "Dominant", "" >>>;
    }
}

fun void AMSend(int idx) {
    if (whichChord == 0) {
        for (int i; i < NUM_TYPES; i++) {
            sendFloat("/minWindow", i, tonic[idx]);
        }
    }
    else if (whichChord == 1) {
        for (int i; i < NUM_TYPES; i++) {
            sendFloat("/minWindow", i, dom[idx]);
        }
    }
}

fun void sendFloat(string addr, int idx, float val) {
    int whichPi;
    if (idx < 2) {
        0 => whichPi;
    }
    else {
        1 => whichPi;
    }

    out[whichPi].start(addr);
    out[whichPi].add(idx % 2);
    out[whichPi].add(val);
    out[whichPi].send();

}

fun void send(string addr, int idx, int val) {
    int whichPi;
    if (idx < 2) {
        0 => whichPi;
    }
    else {
        1 => whichPi;
    }

    out[whichPi].start(addr);
    out[whichPi].add(idx % 2);
    out[whichPi].add(val);
    out[whichPi].send();
    // <<< whichPi, idx % 2, addr, val >>>;
}

while (true) {
    control();
    1::ms => now;
}
