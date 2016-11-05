public class CDT extends Chubgraph {

    SinOsc f1 => outlet;
    SinOsc f2 => outlet;

    // initialize
    1.24 => float CDTRatio;
    440 => float CDTFreq;
    setCDT();

    // sets gain of f1
    fun void f1Gain(float f) {
        f1.gain(f);
    }

    // sets gain of f2
    fun void f2Gain(float f) {
        f2.gain(f);
    }

    // sets frequency of the CDT
    fun float freq(float f) {
        f => CDTFreq;
        setCDT();
    }

    // gets frequency of the CDT
    fun float freq() {
        return CDTFreq;
    }

    // sets the ratio of the two frequencies
    // must be exclusively between 1.0 and 2.0
    fun float ratio(float r) {
        if (r > 1.0 && r < 2.0) {
            r => CDTRatio;
            setCDT();
        }
        else {
            <<< "Ratio falls outside of expected range (1.0, 2.0)", "" >>>;
        }
    }

    // gets the ratio of the two frequencies
    fun float ratio() {
        return CDTRatio;
    }

    // internal function to set CDT after either
    // the ratio between f1 and f2 is changed,
    // or if the desired frequency of the CDT is changed
    fun void setCDT() {
        CDTFreq/(2.0 - CDTRatio) => f1.freq;
        2 * f1.freq() - CDTFreq => f2.freq;
    }
}
