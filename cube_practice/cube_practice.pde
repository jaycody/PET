/*jason stephens - more practice
 New Mexico Project
 Cube Interface in Point Cloud.
 
 */

import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect1;

float rotation = 0;

//cube's size is an interger and location is a PVector
//set the box size
int boxSize = 150;
//set a vector holding the center of the box
PVector boxCenter = new PVector(0, 0, 1000);
// z=600 will put the cube closer to the kinect in front of the point cloud

//add zooming variable
float s = 1;

void setup() {
  size (1024, 768, OPENGL);
  kinect1 = new SimpleOpenNI (this);
  kinect1.enableDepth();
}

void draw() {
  background (0);
  kinect1.update();

  //move to center, push it out a bit then turn it right side up
  translate (width/2, height/2, -1000);
  rotateX(radians(180));//flip this thing right side up

  translate(0, 0, 1400);// then move it back after rotating right side up?
  rotateY(map(mouseX, 0, width, 0, 8*PI));//

  //make everything bigger (ie zoom in)
  translate(0, 0, s*-1000); //this repositions the point cloud relative to the increasing scale
  scale (s);
  //since scale is a percentage where 1.5 is an increase of 50%, we use small increments.
  //however, small increments won't be registered if the same variable is used to translate.
  //s must be scaled up by multiplying by a scalar quantity

  println(s);

  stroke (255);

  PVector [] depthPoints1 = kinect1.depthMapRealWorld(); //returns array of PVectors

  //initialize a variable for storing the total points we find inside the box during this frame
  int depthPointsInBox = 0;

  for (int i = 0; i<depthPoints1.length; i+=10) {
    PVector currentPoint1 = depthPoints1 [i];// along the way through array of PVector, use each current

    //now for some if-statement boundary conditions inside our for loop
    if (currentPoint1.x > boxCenter.x -boxSize/2 && currentPoint1.x < boxCenter.x +boxSize/2) {
      if (currentPoint1.y > boxCenter.y - boxSize/2 && currentPoint1.y< boxCenter.y+boxSize/2) {
        if (currentPoint1.z > boxCenter.z -boxSize/2 && currentPoint1.z < boxCenter.z+boxSize/2) {

          //if these if statements boundary conditions are met, then add that point to the # INSIDE the box
          depthPointsInBox ++;
        }
      }
    }
    point(currentPoint1.x, currentPoint1.y, currentPoint1.z); //create the point cloud
  }

  println(depthPointsInBox); //let me know how many we got inside there

  //set the box's color transparency
  //0 is transparent, 1000 points is fully opaque red
  float boxAlpha = map(depthPointsInBox, 0, 1000, 0, 255);// that's genius!  as we get closer to 1000 to color goes up

  //now draw the cube
  //first move the cordinate system to the box center
  translate (boxCenter.x, boxCenter.y, boxCenter.z);

  //the fourth argument to "fill" is alpha
  fill(255, 0, 0, boxAlpha);
  //set the line color to red
  stroke (255, 0, 0);

  //draw the box
  box(boxSize);
}

//.now use the keys to control zooom
//up arraow zooms IN, down arrow zooms OUT, "s" gets passed to global variable "scale"
void keyPressed() {
  if (keyCode == 38) {
    s =s+.01;
  }

  if (keyCode == 40) {
    s=s-.01;
  }
}


//add mousePressed function
void mousePressed() {
 save ("touchedPoint.png"); 
  
}
