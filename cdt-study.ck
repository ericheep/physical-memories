// cdt-study.ck
// Eric Heep

// Main logic of the piece, recieves OSC from a RPi over the
// wifi network and controls a different CDT in its left and right
// channel. Most of the controls have an easing functionality for
// smooth transitions throughout the piece.

OscIn in;
OscMsg msg;

12345 => in.port;
in.listenAll();

CDT cdt[2];
WinFuncEnv win[2];

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

dur maxWindow[2];
dur minWindow[2];

5::ms => dur incrementRate;

// left/right channels, set incremental parameters
for (int i; i < 2; i++) {
    win[i].setBlackman();
    cdt[i] => win[i] => dac.chan(i);

    1.0 => eGain[i];
    1.2 => eRatio[i];

    10::second => maxWindow[i];
    10::ms => minWindow[i];

    0.01 => eGainInc[i];
    0.0001 => eFreqInc[i];
    0.00001 => eRatioInc[i];

    0.001 => eWindowInc[i];
    1.0 => eWindow[i];
    1.0 => currentWindow[i];
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

5000 => eFreq[0];
1.5 => eRatio[0];
1.0 => eWindow[0];

// loop it
while (true) {
    in => now;
    while (in.recv(msg)) {
        if (msg.address == "/g") {
            msg.getInt(0) => int idx;
            msg.getFloat(1) => eGain[idx];
        }
        if (msg.address == "/f") {
            msg.getInt(0) => int idx;
            msg.getFloat(1) => eFreq[idx];
        }
        if (msg.address == "/r") {
            msg.getInt(0) => int idx;
            msg.getFloat(1) => eRatio[idx];
        }
        if (msg.address == "/w") {
            msg.getInt(0) => int idx;
            msg.getFloat(1) => eWindow[idx];
        }
    }
}
