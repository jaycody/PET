
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
 
 NOTES:
 
 
 TODO:
 Done____Begin Peasy
 Done____draw simple point cloud
 Done____create and control one peasy variable
 ___Start the Touch OSC
 ___Tutorial for Touch OSC
 
 
 ____hotspot class
 ____kinect class
 ____drawCam with kinect.drawCamFrustum()
 ____draw the floor (see UserScene3D example)
 ____color user separate from background (see UserScene3D)
 ____remove background leaving only user and massage table.
 ____incorporate iPad control using touch OSC and ControlP5
 ____create Kinect switching
 ____hotspot above therpists head
 ____where toggling between Kinects, return to previous camera angle
 
 ____share PET via DropBox rather than push git updates
 */


import processing.opengl.*;
import SimpleOpenNI.*;
import peasy.*;

PeasyCam pCam;
SimpleOpenNI kinect1;


void setup () {
  size (1024, 768, OPENGL);
  pCam = new PeasyCam(this,0,0,0,1000);
  kinect1 = new SimpleOpenNI (this);
  kinect1.enableDepth();
}

void draw() {
  background (0);
  kinect1.update();
  rotateX(PI); //rotate along the xPole 180 degrees
  stroke(255);
  
  //peasy controls
  float rotateYPoleMouseX = map (mouseX,width/2-width/2*.5, width/2+width/2*.5,-1, 1);
  rotateY(rotateYPoleMouseX);
  println (rotateYPoleMouseX);
  
   float rotateXPoleMouseY = map (mouseY,height/2-height/2*.5, height/2+height/2*.5,-1, 1);
  rotateX(rotateXPoleMouseY);
  println (rotateXPoleMouseY);
 
 
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
void init() { 
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}
//then in draw add:  frame.setLocation(0,0); // to place an undecorated screen at origin
//or in the case of second monitor (1024, 768) if my primary screen is (1024,768)
