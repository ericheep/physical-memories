CDT cdt[2];

// parameters
float eGain[2];
dur eGainRate[2];
float eGainInc[2];

float eFreq[2];
dur eFreqRate[2];
float eFreqInc[2];

float eRatio[2];
dur eRatioRate[2];
float eRatioInc[2];

// left/right channels
for (int i; i < 2; i++) {
    cdt[i] => dac.chan(i);

    1.0 => eGain[i];
    1.2 => eRatio[i];

    // ease gain parameters
    1::ms => eGainRate[i];
    0.01 => eGainInc[i];

    // ease freq parameters
    1::ms => eFreqRate[i];
    0.01 => eFreqInc[i];

    // ease ratio parameters
    1::ms => eRatioRate[i];
    0.0001 => eRatioInc[i];
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
        eGainRate[idx] => now;
    }
}

// controlled by changing eGain[idx]
fun void easingFreq(int idx) {
    if (Math.fabs(eFreq[idx] - cdt[idx].freq()) >= eFreqInc[idx]) {
        if (eFreq[idx] > cdt[idx].freq()) {
            cdt[idx].freq() + eFreqInc[idx] => cdt[idx].freq;
        }
        else if (eFreq[idx] < cdt[idx].freq()) {
            cdt[idx].freq() - eFreqInc[idx] => cdt[idx].freq;
        }
        eFreqRate[idx] => now;
    }
}

// controlled by changing eGain[idx]
fun void easingRatio(int idx) {
    if (Math.fabs(eRatio[idx] - cdt[idx].ratio()) >= eRatioInc[idx]) {
        if (eRatio[idx] > cdt[idx].ratio()) {
            cdt[idx].ratio() + eRatioInc[idx] => cdt[idx].ratio;
        }
        else if (eRatio[idx] < cdt[idx].ratio()) {
            cdt[idx].ratio() - eRatioInc[idx] => cdt[idx].ratio;
        }
        eRatioRate[idx] => now;
    }
}

fun void easers() {
    while (true) {
        for (int i; i < 2; i++) {
            easingGain(i);
            easingFreq(i);
            easingRatio(i);
        }
    }
}

spork ~ easers();

5000 => eFreq[0];
1.5 => eRatio[0];

while (true) {
    <<< cdt[0].ratio() >>>;
    0.1::second => now;
}
