NanoKontrol2 nano;

OscOut out[2];

["127.0.0.1", "198.167.1.11"] @=> string IP[];
12345 => int OUT_PORT;

// one to rule them all
float tonic => 1000;

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
