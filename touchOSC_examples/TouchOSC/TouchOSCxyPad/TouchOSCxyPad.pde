/**
 * TouchOSCxyPad
 * 
 * Example displaying values received from
 * the "Simple" layout (Page3) xyPad
 * By Mike Cook
 * http://www.thebox.myzen.co.uk
 *
 */

import oscP5.*;
import netP5.*;
OscP5 oscP5;

boolean xyPadNeedsRedraw = true;
float xPad = 120, yPad = 120; 
int [] xyPadStrip = new int [5];

void setup() {
  size(290,360);
  frameRate(25);
  background(0);
  /* start oscP5, listening for incoming messages at port 8000 */
  oscP5 = new OscP5(this,8000);
}

void oscEvent(OscMessage theOscMessage) {
    String addr = theOscMessage.addrPattern();     
 //   println(addr);   // uncomment for seeing the raw message
    
    if(addr.indexOf("/3/xy") !=-1){ // the 8 X Y area
    xPad =  (theOscMessage.get(0).floatValue());
    yPad =  (theOscMessage.get(1).floatValue());
//    println(" x = "+xPad+" y = "+yPad);  // uncomment to see x & Y values
    xyPadNeedsRedraw = true;
    }
    if(addr.indexOf("/3/toggle") !=-1){   // the strip at the bottom
      int i = int((addr.charAt(9) )) - 0x30;   // retrns the ASCII number so convert into a real number by subtracting 0x30
      xyPadStrip[i]  = int(theOscMessage.get(0).floatValue());
//      println(" i = "+i);   // uncomment to see index value
      xyPadNeedsRedraw = true;
   }
}

void draw() {
if(xyPadNeedsRedraw == true) redrawxyPad();  // only redraw the screen if we need to
}

// Update the screen image
void redrawxyPad(){ // redraw the screen
  strokeWeight(2);
  fill(40,40,40);
  stroke(250,250,0);
  rect(15, 15, 260, 260);  // yellow outline
  noStroke(); 
   int x1 =  int(xPad*240)+15;
   int y1 =  int(yPad*240)+15;
        fill(250,250,0);
        rect( x1, y1, 20, 20);  // draw square
        stroke(250,250,0);
        strokeWeight(1);
        line(x1+10,15,x1+10,275);
        line(15,y1+10,275,y1+10);
  strokeWeight(2);
  // draw the strip at the bottom
  stroke(25,150,250);
for( int x = 1 ; x<5 ; x++){
    fill(40,40,40);
    rect( x*60-30, 300, 50, 40);  // draw blank square
    if(xyPadStrip[x] == 1){     // fill it in if that one is pressed
   fill(25,150,250);
    rect( x*60-20, 310, 30, 20);
    }
}
     xyPadNeedsRedraw = false;  // we have now redrawn it, don't do it again until we have another OSC message
}
