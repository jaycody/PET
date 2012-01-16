import processing.opengl.*;

import oscP5.*;
import netP5.*;
import damkjer.ocd.*;

import processing.video.*;

MovieMaker mm;

boolean recording = false;

int recordBegin = 0;

float thisD = 0;
float lastD = 0;

Camera cam;

OscP5 oscP5;

int ballSize = 6;
Hashtable<Integer, Skeleton> skels = new Hashtable<Integer, Skeleton>();

void setup() {
    size(screen.height*4/3/2, screen.height/2, OPENGL); //Keep 4/3 aspect ratio, since it matches the kinect's.
    oscP5 = new OscP5(this, "127.0.0.1", 7110);
    hint(ENABLE_OPENGL_4X_SMOOTH);
    noStroke();
    
    mm = new MovieMaker(this, width, height, "drawing.mov",
                       30, MovieMaker.ANIMATION, MovieMaker.BEST);
   

  cam = new Camera(this, 200, -300, 300);
}




/* incoming osc message are forwarded to the oscEvent method. */
// Here you can easily see the format of the OSC messages sent. For each user, the joints are named with 
// the joint named followed by user ID (head0, neck0 .... r_foot0; head1, neck1.....)
void oscEvent(OscMessage msg) {
  //msg.print();
  
  if (msg.checkAddrPattern("/joint") && msg.checkTypetag("sifff")) {
    // We have received joint coordinates, let's find out which skeleton/joint and save the values ;)
    Integer id = msg.get(1).intValue();
    Skeleton s = skels.get(id);
    if (s == null) {
      s = new Skeleton(id);
      skels.put(id, s);
    }
    if (msg.get(0).stringValue().equals("head")) {
      s.headCoords[0] = msg.get(2).floatValue();
      s.headCoords[1] = msg.get(3).floatValue();
      s.headCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("neck")) {
      s.neckCoords[0] = msg.get(2).floatValue();
      s.neckCoords[1] = msg.get(3).floatValue();
      s.neckCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_collar")) {
      s.rCollarCoords[0] = msg.get(2).floatValue();
      s.rCollarCoords[1] = msg.get(3).floatValue();
      s.rCollarCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_shoulder")) {
      s.rShoulderCoords[0] = msg.get(2).floatValue();
      s.rShoulderCoords[1] = msg.get(3).floatValue();
      s.rShoulderCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_elbow")) {
      s.rElbowCoords[0] = msg.get(2).floatValue();
      s.rElbowCoords[1] = msg.get(3).floatValue();
      s.rElbowCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_wrist")) {
      s.rWristCoords[0] = msg.get(2).floatValue();
      s.rWristCoords[1] = msg.get(3).floatValue();
      s.rWristCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_hand")) {
      s.rHandCoords[0] = msg.get(2).floatValue();
      s.rHandCoords[1] = msg.get(3).floatValue();
      s.rHandCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_finger")) {
      s.rFingerCoords[0] = msg.get(2).floatValue();
      s.rFingerCoords[1] = msg.get(3).floatValue();
      s.rFingerCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_collar")) {
      s.lCollarCoords[0] = msg.get(2).floatValue();
      s.lCollarCoords[1] = msg.get(3).floatValue();
      s.lCollarCoords[2] = msg.get(4).floatValue();
    }  
    else if (msg.get(0).stringValue().equals("l_shoulder")) {
      s.lShoulderCoords[0] = msg.get(2).floatValue();
      s.lShoulderCoords[1] = msg.get(3).floatValue();
      s.lShoulderCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("l_elbow")) {
      s.lElbowCoords[0] = msg.get(2).floatValue();
      s.lElbowCoords[1] = msg.get(3).floatValue();
      s.lElbowCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("l_wrist")) {
      s.lWristCoords[0] = msg.get(2).floatValue();
      s.lWristCoords[1] = msg.get(3).floatValue();
      s.lWristCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("l_hand")) {
      s.lHandCoords[0] = msg.get(2).floatValue();
      s.lHandCoords[1] = msg.get(3).floatValue();
      s.lHandCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("l_finger")) {
      s.lFingerCoords[0] = msg.get(2).floatValue();
      s.lFingerCoords[1] = msg.get(3).floatValue();
      s.lFingerCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("torso")) {
      s.torsoCoords[0] = msg.get(2).floatValue();
      s.torsoCoords[1] = msg.get(3).floatValue();
      s.torsoCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_hip")) {
      s.rHipCoords[0] = msg.get(2).floatValue();
      s.rHipCoords[1] = msg.get(3).floatValue();
      s.rHipCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("r_knee")) {
      s.rKneeCoords[0] = msg.get(2).floatValue();
      s.rKneeCoords[1] = msg.get(3).floatValue();
      s.rKneeCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("r_ankle")) {
      s.rAnkleCoords[0] = msg.get(2).floatValue();
      s.rAnkleCoords[1] = msg.get(3).floatValue();
      s.rAnkleCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("r_foot")) {
      s.rFootCoords[0] = msg.get(2).floatValue();
      s.rFootCoords[1] = msg.get(3).floatValue();
      s.rFootCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("l_hip")) {
      s.lHipCoords[0] = msg.get(2).floatValue();
      s.lHipCoords[1] = msg.get(3).floatValue();
      s.lHipCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("l_knee")) {
      s.lKneeCoords[0] = msg.get(2).floatValue();
      s.lKneeCoords[1] = msg.get(3).floatValue();
      s.lKneeCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("l_ankle")) {
      s.lAnkleCoords[0] = msg.get(2).floatValue();
      s.lAnkleCoords[1] = msg.get(3).floatValue();
      s.lAnkleCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("l_foot")) {
      s.lFootCoords[0] = msg.get(2).floatValue();
      s.lFootCoords[1] = msg.get(3).floatValue();
      s.lFootCoords[2] = msg.get(4).floatValue();
    } 
  }
  else if (msg.checkAddrPattern("/new_user") && msg.checkTypetag("i")) {
    // A new user is in front of the kinect... Tell him to do the calibration pose!
    println("New user with ID = " + msg.get(0).intValue());
  }
  else if(msg.checkAddrPattern("/new_skel") && msg.checkTypetag("i")) {
    //New skeleton calibrated! Lets create it!
    Integer id = msg.get(0).intValue();
    Skeleton s = new Skeleton(id);
    skels.put(id, s);
  }
  else if(msg.checkAddrPattern("/lost_user") && msg.checkTypetag("i")) {
    //Lost user/skeleton
    Integer id = msg.get(0).intValue();
    println("Lost user " + id);
    skels.remove(id);
  }
}

float[] vertexFromJoint(float[] jointValues){
  float[] r = {jointValues[0] * width, jointValues[1] *height, -jointValues[2] * 300};
  return r;
}

float distanceBetweenJoints(float[] j1, float[] j2){
  float r = sqrt(sq(j1[0] - j2[0]) + sq(j1[1] - j2[1]) + sq(j1[2] - j2[2]));
  return r;
}

void draw()
{
  background(0);  
  ambientLight(64, 64, 64);
  lightSpecular(255,255,255);
  directionalLight(224,224,224, .5, 1, -1);

  for (Skeleton s: skels.values()) {
    fill(s.colors[0], s.colors[1], s.colors[2]);
    for (float[] j: s.allCoords) {
      pushMatrix();
      translate(j[0]*width, j[1]*height, -j[2]*300);
      sphere(2 * ballSize/j[2]);
      popMatrix();
    }

    //headCoords, neckCoords, rCollarCoords, rShoulderCoords, rElbowCoords, rWristCoords,
    //                   rHandCoords, rFingerCoords, lCollarCoords, lShoulderCoords, lElbowCoords, lWristCoords,
    //                   lHandCoords, lFingerCoords, torsoCoords, rHipCoords, rKneeCoords, rAnkleCoords,
    //                   rFootCoords, lHipCoords, lKneeCoords, lAnkleCoords, lFootCoords
    //    head
    //     |
    //    neck -- rCollar -- rShoulder -- rElbow -- rWrist -- rHand - rFinger
    //     |
    //    torso
    //     /\
    // lHip  rHip
   //          |
   //          rKnee
   //          |
   //          rAnkle
   //          |
   //          rFoot
   
       float[] headVerts = vertexFromJoint(s.headCoords);
       float[] neckVerts = vertexFromJoint(s.neckCoords);
       float[] rCollarVerts = vertexFromJoint(s.rCollarCoords);
       float[] lCollarVerts = vertexFromJoint(s.lCollarCoords);
       float[] rShoulderVerts = vertexFromJoint(s.rShoulderCoords);
       float[] lShoulderVerts = vertexFromJoint(s.lShoulderCoords);
       float[] rElbowVerts = vertexFromJoint(s.rElbowCoords);
      float[] lElbowVerts = vertexFromJoint(s.lElbowCoords);
       float[] rWristVerts = vertexFromJoint(s.rWristCoords);
       float[] rHandVerts = vertexFromJoint(s.rHandCoords);
        float[] lHandVerts = vertexFromJoint(s.lHandCoords);
      float[] torsoVerts = vertexFromJoint(s.torsoCoords);
      
            float[] rHipVerts = vertexFromJoint(s.rHipCoords);
            float[] lHipVerts = vertexFromJoint(s.lHipCoords);
            
            float[] rKneeVerts = vertexFromJoint(s.rKneeCoords);
            float[] lKneeVerts = vertexFromJoint(s.lKneeCoords);
           
            float[] rFootVerts = vertexFromJoint(s.rFootCoords);
            float[] lFootVerts = vertexFromJoint(s.lFootCoords);
              
    stroke(0,255,0);
    strokeWeight(3);

    beginShape(LINES);
      vertex(headVerts[0], headVerts[1], headVerts[2]);
      vertex(neckVerts[0], neckVerts[1], neckVerts[2]);
      
      vertex(neckVerts[0], neckVerts[1], neckVerts[2]);
      vertex(rShoulderVerts[0], rShoulderVerts[1], rShoulderVerts[2]);      
     
      vertex(neckVerts[0], neckVerts[1], neckVerts[2]);
      vertex(lShoulderVerts[0], lShoulderVerts[1], lShoulderVerts[2]);      
      
      vertex(rShoulderVerts[0], rShoulderVerts[1], rShoulderVerts[2]);      
      vertex(rElbowVerts[0], rElbowVerts[1], rElbowVerts[2]);
      
      vertex(lShoulderVerts[0], lShoulderVerts[1], lShoulderVerts[2]);      
      vertex(lElbowVerts[0], lElbowVerts[1], lElbowVerts[2]);


      vertex(rElbowVerts[0], rElbowVerts[1], rElbowVerts[2]);
      vertex(rHandVerts[0], rHandVerts[1], rHandVerts[2]);
      
      vertex(lElbowVerts[0], lElbowVerts[1], lElbowVerts[2]);
      vertex(lHandVerts[0], lHandVerts[1], lHandVerts[2]);
      
      vertex(neckVerts[0], neckVerts[1], neckVerts[2]);
      vertex(torsoVerts[0], torsoVerts[1], torsoVerts[2]);  
      
      vertex(torsoVerts[0], torsoVerts[1], torsoVerts[2]);  
      vertex(rHipVerts[0], rHipVerts[1], rHipVerts[2]);  
                  
      vertex(torsoVerts[0], torsoVerts[1], torsoVerts[2]);  
      vertex(lHipVerts[0], lHipVerts[1], lHipVerts[2]);  
      

      vertex(lHipVerts[0], lHipVerts[1], lHipVerts[2]);  
      vertex(lKneeVerts[0], lKneeVerts[1], lKneeVerts[2]); 
     
       vertex(rHipVerts[0], rHipVerts[1], rHipVerts[2]);  
      vertex(rKneeVerts[0], rKneeVerts[1], rKneeVerts[2]);  
      

      vertex(rKneeVerts[0], rKneeVerts[1], rKneeVerts[2]);  
     vertex(rFootVerts[0], rFootVerts[1], rFootVerts[2]); 
    
      vertex(lKneeVerts[0], lKneeVerts[1], lKneeVerts[2]);  
     vertex(lFootVerts[0], lFootVerts[1], lFootVerts[2]);  

    endShape();
   noStroke(); 
   
    
    float thisD = distanceBetweenJoints(rHandVerts, lHandVerts);
    
    float delta = abs(thisD - lastD);
    
   // println(delta);
    
    
    
    if(delta > 1.2){
      float speed = map(delta, 0, 10, 0, 0.125);  
      if(thisD > lastD){
        cam.zoom(speed);
      } if(lastD > thisD) {
        cam.zoom(-speed);
      }
    }
    
   // println("r: " + rHandVerts[1] + "\tl: " + lHandVerts[1] + "\tt: " + torsoVerts[1]);
    
    if(rHandVerts[1] > headVerts[1] && lHandVerts[1] > headVerts[1] ){
      
      cam.circle(0.1);
    }
    
    if(rHandVerts[1] < lHipVerts[1] && lHandVerts[1] < lHipVerts[1] ){

      cam.circle(-0.1);
    }
    
    lastD = thisD;
    
    //println("this: " + thisD + " last: " + lastD);
    cam.aim(rHandVerts[0], rHandVerts[1], rHandVerts[2]);

  }
  
  cam.feed();
  if(recording){
    mm.addFrame();
  } 
}

void keyPressed() {
  if(key == ' ' && !recording){
    println("begin recording");
    recordBegin = millis();
    recording = true;
  }
  
  if (key == ' ' && recording && (millis() - recordBegin) > 1000) {
    mm.finish();  // Finish the movie if space bar is pressed!
        println("stop recording");
    recording = false;
  }
}