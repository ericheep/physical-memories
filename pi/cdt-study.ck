// cdt-study.ck
// Eric Heep

// Main logic of the piece, recieves OSC from a RPi over the
// wifi network and controls a different CDT in its left and right
// channel. Most of the controls have an easing functionality for
// smooth transitions throughout the piece.

false => int debug;
second/samp => float fs;

OscIn in;
OscMsg msg;

12345 => in.port;
in.listenAll();

CDT cdt[2];
WinFuncEnv win[2];
Gain g[2];

// ease gain parameters
float eGain[2];
float eGainInc[2];

// ease freq parameters
float eFreq[2];
float eFreqInc[2];

// ease ratio parameters
float eRatio[2];
float eRatioInc[2];

// ease envelope parameters
float eWindow[2];
float eWindowInc[2];
float currentWindow[2];

float minFreq[2];
float maxFreq[2];

dur maxWindow[2];
dur minWindow[2];

float minRatio[2];
float maxRatio[2];

5::ms => dur incrementRate;

// left/right channels, set incremental parameters
for (int i; i < 2; i++) {
    win[i].setBlackman();
    cdt[i] => win[i] => g[i] => dac.chan(i);
    g[i].gain(0.15);

    15::second => maxWindow[i];
    10::ms => minWindow[i];

    0.01 => eGainInc[i];
    0.03 => eFreqInc[i];
    0.00002 => eRatioInc[i];

    0.001 => eWindowInc[i];
    1.0 => eWindow[i];
    1.0 => currentWindow[i];

    1.1 => minRatio[i];
    1.9 => maxRatio[i];

    1024 => maxFreq[i];
    512 => minFreq[i];

    // set initial paramets
    0.0 => eGain[i];
    maxRatio[i] => eRatio[i];
    maxFreq[i] => eFreq[i];

    cdt[i].freq(maxFreq[i]);
    cdt[i].ratio(maxRatio[i]);
}

// controlled by changing eGain[idx]
fun void easingGain(int idx) {
    if (Math.fabs(eGain[idx] - cdt[idx].gain()) >= eGainInc[idx]) {
        if (eGain[idx] > cdt[idx].gain()) {
            cdt[idx].gain() + eGainInc[idx] => cdt[idx].gain;
        }
        else if (eGain[idx] < cdt[idx].gain()) {
            cdt[idx].gain() - eGainInc[idx] => cdt[idx].gain;
        }
    }
}

// controlled by changing eFreq[idx]
fun void easingFreq(int idx) {
    if (Math.fabs(eFreq[idx] - cdt[idx].freq()) >= eFreqInc[idx]) {
        if (eFreq[idx] > cdt[idx].freq()) {
            cdt[idx].freq() + eFreqInc[idx] => cdt[idx].freq;
        }
        else if (eFreq[idx] < cdt[idx].freq()) {
            cdt[idx].freq() - eFreqInc[idx] => cdt[idx].freq;
        }
    }
}

// controlled by changing eRatio[idx]
fun void easingRatio(int idx) {
    if (Math.fabs(eRatio[idx] - cdt[idx].ratio()) >= eRatioInc[idx]) {
        if (eRatio[idx] > cdt[idx].ratio()) {
            cdt[idx].ratio() + eRatioInc[idx] => cdt[idx].ratio;
        }
        else if (eRatio[idx] < cdt[idx].ratio()) {
            cdt[idx].ratio() - eRatioInc[idx] => cdt[idx].ratio;
        }
    }
}

// controlled by changing eWindow[idx]
fun void easingRatio(int idx) {
    if (Math.fabs(eRatio[idx] - cdt[idx].ratio()) >= eRatioInc[idx]) {
        if (eRatio[idx] > cdt[idx].ratio()) {
            cdt[idx].ratio() + eRatioInc[idx] => cdt[idx].ratio;
        }
        else if (eRatio[idx] < cdt[idx].ratio()) {
            cdt[idx].ratio() - eRatioInc[idx] => cdt[idx].ratio;
        }
    }
}

// controlled by changing eWindow[idx]
fun void easingWindow(int idx) {
    if (Math.fabs(eWindow[idx] - currentWindow[idx]) >= eWindowInc[idx]) {
        if (eWindow[idx] > currentWindow[idx]) {
            eWindowInc[idx] +=> currentWindow[idx];
        }
        else if (eWindow[idx] < currentWindow[idx]) {
            eWindowInc[idx] -=> currentWindow[idx];
        }
    }
}

fun void easers() {
    while (true) {
        for (int i; i < 2; i++) {
            easingGain(i);
            easingFreq(i);
            easingRatio(i);
            easingWindow(i);
        }
        incrementRate => now;
    }
}

spork ~ easers();

fun void pulse(int idx, dur d) {
    d/2.0 => dur env;

    win[idx].attack(env);
    win[idx].release(env);

    win[idx].keyOn();
    env => now;
    win[idx].keyOff();
    env => now;
}

fun void pulsing(int idx) {
    while (true) {
        currentWindow[idx] * maxWindow[idx] + minWindow[idx] => dur d;
        pulse(idx, d);
    }
}

spork ~ pulsing(0);
spork ~ pulsing(1);

// osc receive
while (true) {
    in => now;
    while (in.recv(msg)) {
        if (msg.address == "/g") {
            msg.getInt(0) => int idx;
            msg.getInt(1) => int midiValue;
            translateGain(midiValue) => eGain[idx];
            if (debug) {
                <<< "/g", idx, midiValue, eGain[idx] >>>;
            }
        }
        if (msg.address == "/f") {
            msg.getInt(0) => int idx;
            msg.getInt(1) => int midiValue;
            translateFreq(idx, midiValue) => eFreq[idx];
            if (debug) {
                <<< "/f", idx, midiValue, eFreq[idx] >>>;
            }
        }
        if (msg.address == "/r") {
            msg.getInt(0) => int idx;
            msg.getInt(1) => int midiValue;
            translateRatio(idx, midiValue) => eRatio[idx];
            if (debug) {
                <<< "/r", idx, midiValue, eRatio[idx] >>>;
            }
        }
        if (msg.address == "/w") {
            msg.getInt(0) => int idx;
            msg.getInt(1) => int midiValue;
            translateWindow(midiValue) => eWindow[idx];
            if (debug) {
                <<< "/w", idx, midiValue, eWindow[idx] >>>;
            }
        }
        if (msg.address == "/minRatio") {
            msg.getInt(0) => int idx;
            msg.getFloat(1) => minRatio[idx];
            minRatio[idx] => eRatio[idx] => cdt[idx].ratio;

            if (debug) {
                <<< "/minRatio", idx, minRatio[idx] >>>;
            }
        }
        if (msg.address == "/minFreq") {
            msg.getInt(0) => int idx;
            msg.getFloat(1) => minFreq[idx];
            minFreq[idx] => eFreq[idx] => cdt[idx].freq;

            if (debug) {
                <<< "/minFreq", idx, minFreq[idx] >>>;
            }
        }
        if (msg.address == "/minWindow") {
            msg.getInt(0) => int idx;
            second/msg.getFloat(1) => minWindow[idx];
            if (debug) {
                <<< "/minWindow", idx, minWindow[idx] >>>;
            }
        }
    }
}

// exp^2 [0.0, 1.0]
fun float translateGain(int midiValue) {
    return (midiValue/127.0) * midiValue/127.0;
}

// exp^3 [minFreq, maxFreq]
fun float translateFreq(int idx, int midiValue) {
    midiValue/127.0 => float scaled;
    scaled * scaled * scaled => float exp;
    return exp * (maxFreq[idx] - minFreq[idx]) + minFreq[idx];
}

// exp^3 (1.0, 2.0)
fun float translateRatio(int idx, int midiValue) {
    midiValue/127.0 => float scaled;
    scaled * scaled * scaled => float exp;
    return exp * (maxRatio[idx] - minRatio[idx]) + minRatio[idx];
}

// exp^2 [0.0, 1.0]
fun float translateWindow(int midiValue) {
    return (midiValue/127.0) * midiValue/127.0;
}

