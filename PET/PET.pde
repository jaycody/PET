
/*jason stephens
 Proprioception Enhancement Tool (PET)
 ABQ School of Massage and Health Sciences
 2012.01
 
 PET:  a system and method for improving proprioception
 and encouraging healthy body mechanics in massage therapists.
 
 SETUP:  2 Kinects placed 20 feet apart are attached to a drop ceiling 10 feet
 above the ground.  The kinects face a massage tables positioned on the floor half way between
 the two kinects.  A Mac Mini running Processing and the SimpleOpenNI Library processes
 the incoming data from the kinects.  A depth image is then created allowing a therapist in training
 the opportunity for realtime self evaluaiton of his/her body mechanics.  
 
 NOTES:  Issues with Multiple Kinects on MacMini.  Possibly due to usb bus issues.  
 Tried every usb connection variation between the 2 kinects to insure Kinects were not on 
 same bus.  Also possibly due to low memory.  MacMini had 2 gigs.  Bumped to max at 8gig.
 Problem persisted.  Rare cases found on SimpleOpenNI forum.  They're working on it.  
 
 
 TODO:
 Done____Begin Peasy
 Done____draw simple point cloud
 Done____create and control one peasy variable
 
 DONE____create and control one peasy variable with ipad
 ____add remainder of variables for standard movements
 ____then switch to ABQ computer and begin pCam hotspots
 
 ____drawCam with kinect.drawCamFrustum()
 ____draw the floor (see UserScene3D example)
 ____color user separate from background (see UserScene3D)
 ____remove background leaving only user and massage table.
 
  ____share PET via DropBox rather than push git updates
 
 FUTURE FUNCTIONALITY:
 ____create Kinect switching
 ____hotspot above therpists head
 ____where toggling between Kinects, return to previous camera angle
 
 */


import processing.opengl.*;
import SimpleOpenNI.*;
import peasy.*;
import oscP5.*;  // ipad action
import netP5.*;



SimpleOpenNI kinect1;
PeasyCam pCam;
OscP5 oscP5;

//iPad control variables
float lookLR = 0; //  Look Left/Right = /1/lookLR :  range 0-1 incoming 


void setup () {
  size (1024, 768, OPENGL);

  //start oscP5 listening for incoming messages at port 8000
  oscP5 = new OscP5(this, 8000);

  pCam = new PeasyCam(this, 0, 0, 0, 1000); //initialize peasy  
  kinect1 = new SimpleOpenNI (this);  //initialize 1 kinect
  kinect1.enableDepth();
}

// create function to recv and parse oscP5 messages
void oscEvent (OscMessage theOscMessage) {

  String addr = theOscMessage.addrPattern();  //never did fully understand string syntaxxx
  float val = theOscMessage.get(0).floatValue(); // this is returning the get float from bellow

  if (addr.equals("/1/lookLR")) {
    lookLR = map(val, 0, 1, -2*PI, 2*PI);//this SHOULD give us one full rotation in eachdirection
  }
}



void draw() {
  //2nd part of Shiffman's suggestion for starting up full screen in second monitor
  //frame.setLocation(0, 0);  //set this to -1024 if secondary monitor is on the left
  //or set it to 1920 if secodary monitor is on the right.

  background (0);
  kinect1.update();
  rotateX(PI); //rotate along the xPole 180 degrees
  stroke(255);

  //peasy controls
  //  float rotateYPoleMouseX = map (mouseX, width/2-width/2*.5, width/2+width/2*.5, -1, 1);
  //  rotateY(rotateYPoleMouseX);
  //  println (rotateYPoleMouseX);

  //receiving from iPad
  rotateY(lookLR);
  println(lookLR);



  //utility methods to permit use of heads up display (great for Touch OSC)
  pCam.beginHUD();
  // now draw things that you want relative to the camera's position and orientation
  pCam.endHUD(); // always


  PVector [] depthPoints1 = kinect1.depthMapRealWorld(); //returns an array loads array

  for (int i = 0; i<depthPoints1.length; i+=5) {
    PVector currentPoint = depthPoints1 [i]; //extract PVector from this location and store it locally
    point (currentPoint.x, currentPoint.y, currentPoint.z);
  }
}

//Shiffman's advice for starting full screen undecorated windows in second monitor
//void init() { 
//  frame.removeNotify();
//  frame.setUndecorated(true);
//  frame.addNotify();
//  super.init();
//}
//then in draw add:  frame.setLocation(0,0); // to place an undecorated screen at origin
//or in the case of second monitor (1024, 0) if my primary screen is (1024,768)

