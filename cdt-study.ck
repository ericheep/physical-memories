CDT cdt[2];

float eGain[2];
float eIncrement[2];

// parameters
dur eGainRate[2];
dur eGainInc[2];

// left/right channels
for (int i; i < 2; i++) {
    cdt[i] => dac.chan(i);
    1::ms => eGainRate[i];
    0.01 => eGainInc[i];
}

// ease gain
fun void easeGain(int idx, float g) {

}

fun void easingGain(int idx, float g) {
    if (Math.fabs(eGain[idx] - cdt[idx].gain() {
        if (eGain[idx] > cdt[idx].gain()) {
            cdt[idx].gain() + eGainInc => cdt[idx].gain;
        }
        else if (eGain[idx] < cdt[idx].gain()) {
            cdt[idx].gain() - eGainInc => cdt[idx].gain;
        }
        eGainRate => now;
    }

}

for (int i; i < 2; i++) {
    spork ~ easingGain();
}

while (true) {
    1::second => now;
}
