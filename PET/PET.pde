
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
____create hotspot class
____establish edge detection with iPad input
____add hotspots toggle to see in in 3D
____create LookAt with Peasy
____enable camera controls (gimble)
____map gimble controls to z values of iPad?
____Look at Center of Gravity
____toggle vectors to camera
____creat a 3D place holder for table as reference.


____fix zoom
____add snapshot
  ____draw the floor (see UserScene3D example)
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

PeasyDragHandler ZoomDragHandler;

Hotspot hotspotF; //front
Hotspot hotspotFR;
Hotspot hotspotMR;
Hotspot hotspotBR;
Hotspot hotspotB;  //back
Hotspot hotspotBL;// front left
Hotspot hotspotML; //middle left
Hotspot hotspotFL; //backleft

//iPad recepticles
//controls peasy.rotateY
float lookLR = 0; //  Look Left/Right = /1/lookLR :  range 0-1 incoming 
float pLookLR =0; // previous val, so that Peasy aint flying around
float rcvLookLR = 0; //takes the value directly from the oscP5 event
//controls peasy.rotateX
float lookUD = 0; // Look up down.  gonna change incoming range to -6,6 (or close to -2PI,2PI)
float pLookUD = 0;
float rcvLookUD = 0; //need a repository from incoming osc messages
//controls peasy.rotateZ
float tiltLR = 0;
float pTiltLR = 0;
float rcvTiltLR = 0;

float zoomIO = 0; //
float pZoomIO = 0;
float rcvZoomIO = 0;
float pAmountZoomIO = 0;

float moveLR = 0;
float pMoveLR = 0;
float rcvMoveLR = 0;

float moveUD = 0;
float pMoveUD = 0;
float rcvMoveUD = 0;

float reset = 0;
float pCamReset = 0;

boolean setMirror = false;
boolean pSetMirror= false;

float swCam = 0; //DEBOUNCING !!
float pSwCam = 0;
boolean wasOn = true;
boolean isOn = true;

color[]      userColors = { color(255,0,0), color(0,255,0), color(255,255,100), color(255,255,0), color(255,0,255), color(250,200,255) };
color[]      userCoMColors = { color(255,100,100), color(100,255,100), color(255,100,255), color(255,255,100), color(255,100,255), color(100,255,255) };



void setup () {
  size (1024, 768, OPENGL);

  //start oscP5 listening for incoming messages at port 8000
  oscP5 = new OscP5(this, 8000);
  pCam = new PeasyCam(this, 0, 0, -1000,300); //initialize peasy
  ZoomDragHandler = pCam.getZoomDragHandler();//getting control of zoom action
  pCam.setWheelScale(1);
  pCam.setMinimumDistance(0);
  pCam.setMaximumDistance(6000);

  kinect1 = new SimpleOpenNI (this);  //initialize 1 kinect
  kinect1.setMirror(true);//disable mirror and renable with set mirror button
  kinect1.enableDepth();
  
    // enable skeleton generation for all joints
  kinect1.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
  
  // enable the scene, to get the floor
  kinect1.enableScene();
  
  //for color alignment
  //kinect1.enableRGB();
  //kinect1.alternativeViewPointDepthToImage();
  
  smooth();
}

// create function to recv and parse oscP5 messages
void oscEvent (OscMessage theOscMessage) {

  String addr = theOscMessage.addrPattern();  //never did fully understand string syntaxxx
  float val = theOscMessage.get(0).floatValue(); // this is returning the get float from bellow

  if (addr.equals("/1/lookLR")) {  //remove the if statement and put it in draw
    rcvLookLR = val; //assign received value.  then call function in draw to pass parameter
  }
  else if (addr.equals("/1/lookUD")) {
    rcvLookUD = val;// assigned receive val. prepare to pass parameter in called function: end of draw
  }
  else if (addr.equals("/1/tiltLR")) {
    rcvTiltLR = val;// assigned received val from tilt and prepare to pass in function
  }
  else if (addr.equals("/1/zoomIO")) {
    rcvZoomIO = val;
  }
  else if (addr.equals("/1/moveLR")) {
    rcvMoveLR = val;
  }
  else if (addr.equals("/1/moveUD")) {
    rcvMoveUD= val;
  }
  else if (addr.equals("/1/reset")) {
    reset = val;
  }
  else if (addr.equals("/1/setMirror")) {
    setMirror = true;
  }
  else if (addr.equals("/1/showCamera")) {
    swCam = val;
  }
}

void draw() {
  //2nd part of Shiffman's suggestion for starting up full screen in second monitor
  //frame.setLocation(0, 0);  //set this to -1024 if secondary monitor is on the left

  background (0);
  kinect1.update();
  
 //now load the color image
// PImage rgbImage = kinect1.rgbImage();

  rotateX(PI); //rotate along the xPole 180 degrees
  //stroke(255);

////  //____DRAW POINT CLOUD____
//  PVector [] depthPoints1 = kinect1.depthMapRealWorld(); //returns an array loads array
//  for (int i = 0; i<depthPoints1.length; i+=3) {
//    PVector currentPoint = depthPoints1 [i]; //extract PVector from this location and store it locally
//    point (currentPoint.x, currentPoint.y, currentPoint.z);
//  }

// Draw RealWorld Depth Map
//PVector[] depthPoints = kinect1.depthMapRealWorld();
//  // don't skip any depth points
//  for (int i = 0; i < depthPoints.length; i+=2) {
//    //original increment of for loop counter set to 1
//    PVector currentPoint = depthPoints[i];
//    // set the stroke color based on the color pixel
//    stroke(rgbImage.pixels[i]);
//    point(currentPoint.x, currentPoint.y, currentPoint.z);
//  }

//____DRAW USERS

  int[]   depthMap = kinect1.depthMap();
  int     steps   = 3;  // to speed up the drawing, draw every third point
  int     index;
  PVector realWorldPoint;
  
int userCount = kinect1.getNumberOfUsers();
  int[] userMap = null;
  if(userCount > 0)
  {
    userMap = kinect1.getUsersPixels(SimpleOpenNI.USERS_ALL);
  }
  
  for(int y=0;y < kinect1.depthHeight();y+=steps)
  {
    for(int x=0;x < kinect1.depthWidth();x+=steps)
    {
      index = x + y * kinect1.depthWidth();
      if(depthMap[index] > 0)
      { 
        // get the realworld points
        realWorldPoint = kinect1.depthMapRealWorld()[index];
        
        // check if there is a user
        if(userMap != null && userMap[index] != 0)
        {  // calc the user color
          int colorIndex = userMap[index] % userColors.length;
          stroke(userColors[colorIndex]); 
        }
        else
          // default color
          stroke(50); 
          
        point(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);
      }
    } 
  } 
  
  // draw the center of mass
  PVector pos = new PVector();
  pushStyle();
    strokeWeight(15);
    for(int userId=1;userId <= userCount;userId++)
    {
      kinect1.getCoM(userId,pos);
   
      stroke(userCoMColors[userId % userCoMColors.length]);
      point(pos.x,pos.y,pos.z);
    }  
  popStyle();
  


  //___TOGGLE SWITCHES
  //___________________
  //SET MIRROR DEBOUNCED TOGGLR:  if setMirror goes HIGH, then toggle mirror  
  if (setMirror !=pSetMirror) {
    if (setMirror) {
      kinect1.setMirror(!kinect1.mirror());
    }
  }
  pSetMirror = setMirror;
  setMirror = false;  //clear the boolean
  //_________________

  //_______
  //SHOW CAMERA DEBOUNCE TOGGLE:  
  //Please take picture of these few lines of code (3 hours easy);
  //4 variables needed to debounce a pushbutton used to toggle...
  if (swCam==1 && (swCam != pSwCam)) {
    if (wasOn) {
      isOn = false;
      wasOn =isOn;
    }
    else if (wasOn == false) {
      isOn = true;
      wasOn = isOn;
    }
  }
  pSwCam = swCam;

  if (isOn) {
    kinect1.drawCamFrustum();
  }
  //__________________
  //________________
  //"RESET CAMERA" PUSH BUTTON
  //ahhhh, this debounce works.  placed after the formation of the point cloud
  //also made a difference with the flicker
  //reset cam position but only if we need to
  if (reset != pCamReset) {
    if (reset == 1) {
      pCam.reset(2000); //only move cam if we need to
    }
  }
  pCamReset = reset;
  //________________

  //++CALL FUNCTIONS++++++++_____________________________________
  peasyVectors(); //function to get PVector info for position and look at.



  calcLookLR(rcvLookLR);
  calcLookUD(rcvLookUD);
  calcTiltLR(rcvTiltLR);
  
  calcZoomIO(rcvZoomIO);  //going to the drag Handler
  
  calcMoveLR(rcvMoveLR);
  calcMoveUD(rcvMoveUD);

  print("rcvLookLR = " + rcvLookLR);
  print(" rcvLookUD = " + rcvLookUD);
  println(" rcvTiltLR = " + rcvTiltLR);
  print("rcvZoomIO = " + rcvZoomIO);
  print(" rcvMoveLR = " + rcvMoveLR);
  println(" rcvMoveUD = " + rcvMoveUD);
  
}//end draw

//defining the functions for rotations around Y_Pole
void calcLookLR (float v) {
  lookLR = v;
  float amountLookLR = map(lookLR - pLookLR, -1, 1, -2*PI, 2*PI);
  pCam.rotateY (amountLookLR);
  print("aLookLR = " + amountLookLR);
  pLookLR = lookLR;
}
//+++++DEFINE FUNCTIONS FOR ROTATIONS around Z_Pole
void calcLookUD(float v) {  //receive from fucntion calling at end of draw
  lookUD = v;
  float amountLookUD = map(lookUD-pLookUD, -1, 1, -PI, PI);  //giving one rotation each direction
  pCam.rotateX(amountLookUD);
  print (" LookUD = " + amountLookUD);
  pLookUD = lookUD;// resetting the acceleration so it's not additive.  start at zero difference
}
//++++++DEFINE FUNCTION FOR TILT
void calcTiltLR (float v) {
  tiltLR = v;
  float amountTiltLR = map (tiltLR-pTiltLR, -1, 1, PI, -PI);
  pCam.rotateZ(amountTiltLR);
  println (" aTiltLR = " + amountTiltLR);
  pTiltLR = tiltLR;
}
//_____DEFINE FUNCTION FOR ZOOM
void calcZoomIO (float v) {
  zoomIO = v;
  float amountZoomIO = map (zoomIO, -1,1, -10,10); //ws zoomIO only and -10,10
  ZoomDragHandler.handleDrag(amountZoomIO,amountZoomIO); // (was amountZoomIo, zooomIo
  float pAmountZoomIO = amountZoomIO;
  pZoomIO=zoomIO;
  
  
  //pCam.setDistance(amountZoomIO); //distance from looked at point.  i think this distance no differen
  double d = pCam.getDistance();// how far away is look-at point
  print("dist_lookAt = " +d);
  print(" aZoomIO = " + amountZoomIO);
  println(" pAZoomIO = " + pAmountZoomIO);
   
}
void calcMoveLR (float v) {
 moveLR = v;
double amountMoveLR = map (moveLR-pMoveLR, -1,1,3000,-3000);  //camera.pan(double dx, double dy);
pCam.pan(amountMoveLR, 0);  // y =0 because we're only moving on the x-axis.
print(" aMoveLR = " + amountMoveLR);
pMoveLR = moveLR;
}

void calcMoveUD (float v) {
  moveUD = v;
  double amountMoveUD = map (moveUD-pMoveUD, -1,1, 3000,-3000);
  pCam.pan(0,amountMoveUD);
  pMoveUD = moveUD;
 println(" aMoveUD = " + amountMoveUD); 
}
  
  


void peasyVectors() {
  float[] pCamPosition; 
  float[] pCamLookAt;
  pCamPosition = pCam.getPosition(); 
  pCamLookAt = pCam.getLookAt(); 
  PVector pCamPos = new PVector(pCamPosition[0], pCamPosition[1], pCamPosition[2]);
  PVector pCamLook = new PVector(pCamLookAt[0], pCamLookAt[1], pCamLookAt[2]);
  print("pCamPos = " + pCamPos.x + " " + pCamPos.y + " " + pCamPos.z);
  println(" pCamLook = " + pCamLook.x +" " + pCamLook.y +" " + pCamLook.z);
}


// -----------------------------------------------------------------
// SimpleOpenNI user events

void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);  
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}



//Shiffman's advice for starting full screen undecorated windows in second monitor
//void init() { 
//  frame.removeNotify();
// frame.setUndecorated(true);
// frame.addNotify();
//  super.init();
//}
//then in draw add:  frame.setLocation(0,0); // to place an undecorated screen at origin
//or in the case of second monitor (1024, 0) if my primary screen is (1024,768)

