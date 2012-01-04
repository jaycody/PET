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

void setup()
{
  size(640 * 2 + 10, 480 * 2 + 10, OPENGL); 

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

  // set the camera generators
  cam1.enableDepth();
  cam1.enableIR();


  cam2.enableDepth();
  cam2.enableIR();

  // access the color camera
  cam1.enableRGB();
  cam2.enableRGB();
  // tell OpenNI to line-up the color pixels
  // with the depth data
  cam1.alternativeViewPointDepthToImage();
  cam2.alternativeViewPointDepthToImage();

  cam = new PeasyCam(this, 0, 0, 0, 1000);
  //background(10,200,20);
}

void draw()
{
  background(0);
  // update the cam
  SimpleOpenNI.updateAll();
//cam1
  pushMatrix() ;
  PImage cam1rgbImage = cam1.rgbImage();
  translate(width/2, height/2, -250);
  rotateX(radians(180));
  translate(0, 0, 1000);
  //rotateY(radians(rotation));
  rotateY(radians(mouseY));
  //rotation++;
  PVector[] cam1DepthPoints = cam1.depthMapRealWorld();
  for (int i = 0; i < cam1DepthPoints.length; i+=3) {
    PVector currentPoint = cam1DepthPoints[i];
    stroke(cam1rgbImage.pixels[i]);
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
  popMatrix();
//cam2
  pushMatrix();
  PImage cam2rgbImage = cam2.rgbImage();
  translate(width/2, height/2, -250);
  rotateX(radians(180));
  translate(0, 0, 1000);
  //rotateY(radians(rotation));
  rotateY(radians(mouseY));
  //rotation++;
  PVector[] cam2DepthPoints = cam2.depthMapRealWorld();
  for (int i = 0; i < cam2DepthPoints.length; i+=3) {
    PVector currentPoint = cam2DepthPoints[i];
    stroke(cam2rgbImage.pixels[i]);
    point(currentPoint.x, currentPoint.y, currentPoint.z);
  }
  popMatrix();

  // draw depthImageMap
  //image(cam1.depthImage(),0,0);
  //image(cam1.irImage(),0,480 + 10);

  // image(cam2.depthImage(),640 + 10,0);
  //image(cam2.irImage(),640 + 10,480 + 10);
}

