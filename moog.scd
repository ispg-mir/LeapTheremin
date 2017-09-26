// instrument definition
(
SynthDef("moog", {
	arg vibr=0.5, cutoff=0.5, freq=440, amp=0;
	var osc1, osc2, osc3, f0, vib_int, cutoff_freq, delay, fil_osc;
	vib_int=0.7;

	f0=exp(vibr*(0.05*vib_int))*freq;

	osc1=Saw.ar(f0*1.0013);
	osc2=Saw.ar(f0*0.998);
	osc3=Saw.ar(f0*0.5);


	cutoff_freq=((cutoff+0.5)*6)*freq;

	fil_osc=BLowPass.ar(in:osc1+osc2+osc3, freq:cutoff_freq);

	delay=DelayN.ar(in:fil_osc, delaytime:0.5)!2;

	Out.ar(0, amp*delay);}).add;
)

// offline test (skip when online)
(
var instr;
instr= Synth(\moog);
instr.set(\amp,1);
instr.set(\cutoff,0.9);

)



//set the server
NetAddr("127.0.0.1",57120);

// online use
(
var instr;
instr = Synth(\moog);

OSCdef('OSCreceiver',
	{
		arg msg;

		var lBool, lPosX, lPosY, lPosZ, lRotR, lRotP, lRotY;
		var rBool, rPosX, rPosY, rPosZ, rRotR, rRotP, rRotY;
		var lGrab, rGrab;
		var freq, cutoff;
		var pentatonic;
		pentatonic=[36, 38, 40, 43, 45, 48, 50, 52, 55, 57, 60, 62, 64, 67, 69, 72, 74, 76, 79, 81, 84];
		lBool=msg[1];
		lPosX=msg[2];
		lPosY=msg[3];
		lPosZ=msg[4];
		rRotR=msg[5];
		rRotP=msg[6];
		rRotY=msg[7];

		rBool=msg[8];
		rPosX=msg[9];
		rPosY=msg[10];
		rPosZ=msg[11];
		rRotR=msg[12];
		rRotP=msg[13];
		rRotY=msg[14];
		//rBool.postln;

		lGrab=msg[15];
		rGrab=msg[16];

		// not pentatonic
		//freq=(round((rPosX*48)+36)).midicps;

		// pentatonic
		freq=(pentatonic.at(rPosX*pentatonic.size)).midicps;
		cutoff=1;

		instr.set(\freq,freq, \cutoff,rPosZ, \vibr, rRotP, \amp,rPosY*rBool*(1-rGrab));
	},
	"/hand");
)

