public class PiSine extends Chubgraph {
    inlet => SinOsc s => WinFuncEnv e => outlet;
    
    fun void pulse (dur d) {
        e.keyOn();
        d/2.0 => now;
        e.keyOff();
        d/2.0 => now;
    }
}

PiSine s => dac;
s.pulse(1::second);