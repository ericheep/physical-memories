public class Easer {

}

fun void pulse (dur d) {
    d/2.0 => dur ar;

    env.attack(ar);
    env.release(ar);

    env.keyOn();
    ar => now;
    env.keyOff();
    ar => now;
}


fun dur easeGainRate(dur r) {
    r => eGainRate;
    return r;
}

fun float easeGainIncrement(float e) {
    e => eGainIncrement;
    return e;
}

fun float easingGain() {
    while (true) {
        if (Math.fabs(eGain - env.gain()) >= eGainIncrement) {
            if (eGain > env.gain()) {
                env.gain() + eGainIncrement => env.gain;
            }
            else if (eGain < env.gain()) {
                env.gain() - eGainIncrement => env.gain;
            }
        }
        eGainRate => now;
    }
}

// functions that modify how the CDT slowly changes
fun float easeFreq(float v) {
    v => eFreq;
    return v;
}

fun dur easeFreqRate(dur r) {
    r => eFreqRate;
    return r;
}

fun float easeFreqIncrement(float i) {
    i => eFreqIncrement;
    return i;
}

fun float easingFreq() {
    while (true) {
        if (Math.fabs(eFreq - CDTFreq) >= eFreqIncrement) {
            if (eFreq > CDTFreq) {
                eFreq + eFreqIncrement => eFreq;
            }
            else if (eFreq < CDTFreq) {
                eFreq - eFreqIncrement => eFreq;
            }
            ratio(CDTRatio);
        }
        else if (eFreq != CDTFreq) {
            eFreq => CDTFreq;
        }
        eFreqRate => now;
    }
}

