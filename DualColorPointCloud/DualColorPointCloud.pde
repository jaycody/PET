/*jason stephens - BodyMechanics
 NewMexicoProject 4Jan2012
 From the SimpleNI MultiCameraTest
 
 TODO:
 _____enable and draw the point clouds
 _____possibly overlap the point clouds?  and synch them, somehow
 _____add realworldColor and pixel ovelap from rgb
 _____add peasy cam
 _____add ControlP5 and the ipad 
 _____add flyby, preset angles, xy 2D variable controls with iPad
 _____add touch OSC
 _____add hotboxes so the therapist can change their own perspective
 _____import the openGL library??
 _____create a camera class?
 _____manual controls of positioning will allow for easiest alignment
 _____first establish solid Kinect Location, then calibrate and lock into place.
 
 _____auto startup
 _____auto send to other screens
 _____auto update via push from github
 _____
 
 NOTES:
 */
import processing.opengl.*;
import SimpleOpenNI.*;
import peasy.*;

PeasyCam cam;

SimpleOpenNI  cam1;
SimpleOpenNI  cam2;

//lets get some navigation going
float        zoomF =0.3f;
float        rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis, 
// the data from openni comes upside down
float        rotY = radians(0);

//keeping track of which image is moving
int currentImage =1;

void setup()
{

  size(1024, 768, OPENGL);
  //size(640 * 2 + 10, 480 * 2 + 10, OPENGL); 

  // start OpenNI, loads the library
  SimpleOpenNI.start();

  // print all the cams 
  StrVector strList = new StrVector();
  SimpleOpenNI.deviceNames(strList);
  for (int i=0;i<strList.size();i++)
    println(i + ":" + strList.get(i));

  // init the cameras
  cam1 = new SimpleOpenNI(0, this);
  cam2 = new SimpleOpenNI(1, this);

  // disable mirror
  cam1.setMirror(false);


  // set the camera generators
  cam1.enableDepth();
  cam1.enableIR();


  cam2.enableDepth();
  cam2.enableIR();

  // access the color camera
  //cam1.enableRGB();
  //cam2.enableRGB();
  // tell OpenNI to line-up the color pixels
  // with the depth data
  // cam1.alternativeViewPointDepthToImage();
  //cam2.alternativeViewPointDepthToImage();

  //cam = new PeasyCam(this, 0, 0, 0, 1000);
  //background(10,200,20);

  stroke(255, 255, 255);
  smooth();
  perspective(radians(45), 
  float(width)/float(height), 
  10, 150000);
}

void draw()
{
  background(0);
  stroke(255);


  // update the cam
  SimpleOpenNI.updateAll();

  //cam1
  pushMatrix() ;
  //PImage cam1rgbImage = cam1.rgbImage();

  // try the switch-case way
  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);
  // prepare to draw centered in x-y
  // pull it 1000 pixels closer to z
  //  translate(0, height/2, -400);
  //  
  //  //flip the point cloud vertically since images come backwards
  //  rotateX(radians(180));
  //  
  //  //rotate about the x-axis using mouseX
  // // rotateX(radians(mouseY));
  //  
  //  //move center of rotation to inside point cloud
  translate(0, 0, 1000);
  //   
  //rotate about the y-axis using mouseY
  //rotateY(radians(mouseX));
  //rotateY(radians(rotation));
  //rotation++;


  PVector[] cam1DepthPoints = cam1.depthMapRealWorld();
  for (int i = 0; i < cam1DepthPoints.length; i+=3) {
    PVector currentPoint = cam1DepthPoints[i];
    //stroke(cam1rgbImage.pixels[i]);
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
  popMatrix();

  //cam2
  pushMatrix();
  //PImage cam2rgbImage = cam2.rgbImage();

  // prepare to draw centered in x-y
  // pull it 1000 pixels closer to z
  translate(width, height/2, -400);

  //flip the point cloud vertically since images come backwards
  rotateX(radians(180));

  //rotate about the x-axis using mouseX
  // rotateX(radians(mouseY));

  //move center of rotation to inside point cloud
  translate(0, 0, 1000);

  //rotate about the y-axis using mouseY
  rotateY(radians(mouseX + 50));
  //rotateY(radians(rotation));
  //rotation++;

  PVector[] cam2DepthPoints = cam2.depthMapRealWorld();
  for (int i = 0; i < cam2DepthPoints.length; i+=3) {
    PVector currentPoint = cam2DepthPoints[i];
    // stroke(cam2rgbImage.pixels[i]);
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
  popMatrix();

  // draw depthImageMap
  //image(cam1.depthImage(),0,0);
  //image(cam1.irImage(),0,480 + 10);

  // image(cam2.depthImage(),640 + 10,0);
  //image(cam2.irImage(),640 + 10,480 + 10);
}

//create a switch statement
//switch(currentImage) {  //determine which image is moving
  
//}


void keyPressed()
{
  switch(key)
  {
  case ' ':
    cam1.setMirror(!cam1.mirror());
    break;
  }

  switch(keyCode)
  {
  case LEFT:
    rotY += 0.1f;
    break;
  case RIGHT:
    // zoom out
    rotY -= 0.1f;
    break;
  case UP:
    if (keyEvent.isShiftDown())
      zoomF += 0.02f;
    else
      rotX += 0.1f;
    break;
  case DOWN:
    if (keyEvent.isShiftDown())
    {
      zoomF -= 0.02f;
      if (zoomF < 0.01)
        zoomF = 0.01;
    }
    else
      rotX -= 0.1f;
    break;
  }
}

void mousePressed () {  //create a counter to give us accees to one image at time
  //increase current image
  currentImage ++;
  //if it goes about 2
  if (currentImage > 2) {
    currentImage = 1;
  }
  println(currentImage);
}

