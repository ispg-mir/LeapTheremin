import de.voidplus.leapmotion.*;
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

// ======================================================
// Table of Contents:
// ├─ 1. Callbacks
// ├─ 2. Hand
// ├─ 3. Arms
// ├─ 4. Fingers
// ├─ 5. Bones
// ├─ 6. Tools
// └─ 7. Devices
// ======================================================

LeapMotion leap;
PVector leftPosition=new PVector(0,0,0);
PVector rightPosition=new PVector(0,0,0);
PVector leftRotation=new PVector(0,0,0);
PVector rightRotation=new PVector(0,0,0);
boolean leftFound=false;
boolean rightFound=false;
float leftGrab=0.0;
float rightGrab=0.0;
//SinOsc[] sineWaves;  
//float[] sineFreq;
//float[] sineVolumes;
//int numSines=1;


//void createSound(){
//  sineWaves = new SinOsc[numSines]; // Initialize the oscillators
//  sineFreq = new float[numSines]; // Initialize array for Frequencies
//  sineVolumes = new float[numSines]; // Initialize array for Frequencies
  
//  for (int i = 0; i < numSines; i++) {
//    sineVolumes[i] = (1.0 / numSines) / (2*i + 1);    
//    sineWaves[i] = new SinOsc(this);
//    sineWaves[i].play();    
//    sineWaves[i].freq(150*(i+1));
//    sineWaves[i].amp(sineVolumes[i]*0);
//  }
//}
//void modifySound(float freq, float amp){
//  for (int i = 0; i < numSines; i++) { 
//    int freq_=(int)freq*(i+1);
//    float amp_=amp*sineVolumes[i];
//  //  println(freq_);
//  //  println(amp_);
//    sineWaves[i].freq(freq_);    
//    sineWaves[i].amp(amp_);
//  }
//}; 

void getLeapInfo(){
  leftFound=false;
  rightFound=false;
  for (Hand hand : leap.getHands ()) {
    PVector handPosition      = hand.getPosition();
    float   handRoll           = hand.getRoll();
    float   handPitch          = hand.getPitch();
    float   handYaw            = hand.getYaw();
    PVector handRotation       = new PVector(handRoll, handPitch, handYaw);
    boolean handIsLeft         = hand.isLeft();
    boolean handIsRight        = hand.isRight();
    float handGrab= hand.getGrabStrength();
    
    String hand_string="";
    if (handIsLeft){
       hand_string="Left Hand";
       leftPosition=handPosition;
       leftRotation=handRotation;
       leftGrab=handGrab;
       leftFound=true;
    }
    if (handIsRight){
      hand_string="Right Hand";
      rightPosition=handPosition;
      rightRotation=handRotation;
      rightFound=true;
      rightGrab=handGrab;
    }
    hand.draw();
    
//    println("Position of: " +hand_string+": "+handPosition.toString());
//    println("Rotation of: " +hand_string+": "+handRotation.toString());
    
  }
}


OscMessage buildHandMessage(OscMessage handMessage, boolean found, PVector position, PVector rotation){  
  handMessage.add(int(found));
  float[] pos=position.array();
  float P0=map(pos[0], 0, 1200, 0, 1);
  float P1=map(pos[1], 100, 800, 1, 0);
  float P2=map(pos[2], 15, 70, 0, 1);
  float[] P={P0,P1,P2};
  for (int i=0; i<3; i++){
    float p=P[i];
    if(P[i]<0 ){p=0;}
     if(P[i]>1 ){p=1;}
     handMessage.add(p);
  }
  float[] rot= rotation.array();
  float fact=0.8;
  for (int i=0; i<3; i++){    
    float r=map(rot[i],-90,90,-1,1);
     if(r<-fact){r=-fact;}
     if(r>fact ){r=fact;}
     handMessage.add(r/fact);
  }
  return handMessage;
  
}


OscMessage addGrab(OscMessage handMessage, float leftGrab, float rightGrab){  
  handMessage.add(leftGrab);
  handMessage.add(rightGrab);
  return handMessage;
  
}

void draw() {
//  frameRate(leap.getFrameRate());
  background(255);
  
  getLeapInfo();
  OscMessage handMessage = new OscMessage("/hand");
  handMessage = buildHandMessage(handMessage, leftFound, leftPosition, leftRotation);
  handMessage = buildHandMessage(handMessage, rightFound, rightPosition, rightRotation);
  handMessage= addGrab(handMessage, leftGrab, rightGrab);
  handMessage.print();  
  oscP5.send(handMessage, myRemoteLocation);
  
}
void setup() {
  size(1600 , 800);
  background(255);
  // ...
//  createSound();
  leap = new LeapMotion(this);
  frameRate(25);
  oscP5 = new OscP5(this,55000);
  myRemoteLocation = new NetAddress("127.0.0.1",57120);
}


 



 //incoming osc message are forwarded to the oscEvent method.
void oscEvent(OscMessage theOscMessage) {
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  print("found? "+ str(theOscMessage.get(1).floatValue()));
}
 

//void whatever() {
//  //Map mouseY from 0 to 1
//  background(255);
//  float yoffset = map(mouseX, 0, width, 0, 1);
  
//  //Map mouseY logarithmically to 150 - 1150 to create a base frequency range
//  float frequency = pow(1000, yoffset) + 150;
//  //Use mouseX mapped from -0.5 to 0.5 as a detune argument
//  float amp = map(mouseY, 0, height, 0.99, 0);
//  if(amp<0 || amp>1 || yoffset<0 || yoffset>1){frequency =440; amp=0;}
  
//  ellipseMode(CENTER);
//  fill(0,0,0);
//  ellipse(mouseX, mouseY, 20,20);
//  modifySound(frequency, amp);
//}





// ======================================================
// 1. Callbacks

void leapOnInit() {
  // println("Leap Motion Init");
}
void leapOnConnect() {
  // println("Leap Motion Connect");
}
void leapOnFrame() {
  // println("Leap Motion Frame");
}
void leapOnDisconnect() {
  // println("Leap Motion Disconnect");
}
void leapOnExit() {
  // println("Leap Motion Exit");
}