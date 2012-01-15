/**
 * TouchOSCmultitoggle
 * 
 * Example displaying values received from
 * the "Simple" layout (Page2) 4 by 4 push
 * By Mike Cook
 * http://www.thebox.myzen.co.uk
 *
 */

import oscP5.*;
import netP5.*;
OscP5 oscP5;

boolean square4NeedsRedraw = true;
int [] square4 = new int [17]; 
int [] square4strip = new int [5];

void setup() {
  size(290,360);
  frameRate(25);
  background(0);
  /* start oscP5, listening for incoming messages at port 8000 */
  oscP5 = new OscP5(this,8000);
}

void oscEvent(OscMessage theOscMessage) {
    String addr = theOscMessage.addrPattern();     
  //  println(addr);   // uncomment for seeing the raw message
    
    if(addr.indexOf("/2/push") !=-1){ // the 4 by 4 square
       String list[] = split(addr,'/');
     int xPush =0;
     if( list[2].length() == 5){
       xPush = int(list[2].charAt(4) - 0x30);
     }
     else {
       xPush = int(list[2].charAt(5) - 0x30 + 10);
    }
    square4[xPush]  = int(theOscMessage.get(0).floatValue());
  //  println(" x = "+xPush);  // uncomment to see x values
    square4NeedsRedraw = true;
    }
    if(addr.indexOf("/2/toggle") !=-1){   // the strip at the bottom
      int i = int((addr.charAt(9) )) - 0x30;   // retrns the ASCII number so convert into a real number by subtracting 0x30
      square4strip[i]  = int(theOscMessage.get(0).floatValue());
//      println(" i = "+i);   // uncomment to see index value
      square4NeedsRedraw = true;
   }
}

void draw() {
if(square4NeedsRedraw == true) redrawSquare4();  // only redraw the screen if we need to
}

// Update the screen image
void redrawSquare4(){ // redraw the screen
  noStroke();
  for(int y=1 ; y<5 ; y++){  // draw the matrix
  for(int x=1 ; x<5 ; x++){
    fill(40,40,10);
    rect( x*60-32, y*60-32, 48, 48);   // blank rectangle
        if(square4[x+((y-1)*4)] == 1){ 
        fill(250,250,0);
        rect( x*60-28, y*60-28, 40, 40);  // fill it in if needed
        }
      }
    }
  strokeWeight(2);
  // draw the strip at the bottom
  stroke(25,150,250);
for( int x = 1 ; x<5 ; x++){
    fill(40,40,40);
    rect( x*60-30, 300, 50, 40);  // draw blank square
    if(square4strip[x] == 1){     // fill it in if that one is pressed
   fill(25,150,250);
    rect( x*60-20, 310, 30, 20);
    }
}
     square4NeedsRedraw = false;  // we have now redrawn it, don't do it again until we have another OSC message
}
