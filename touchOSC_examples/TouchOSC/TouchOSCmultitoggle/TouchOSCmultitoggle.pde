/**
 * TouchOSCmultitoggle
 * 
 * Example displaying values received from
 * the "Simple" layout (Page4) multitoggle
 * By Mike Cook
 * http://www.thebox.myzen.co.uk
 *
 */

import oscP5.*;
import netP5.*;
OscP5 oscP5;

boolean square8NeedsRedraw = true;
int [][] square8 = new int [9][9]; 
int [] square8strip = new int [5];

void setup() {
  size(290,360);
  frameRate(25);
  background(0);
  /* start oscP5, listening for incoming messages at port 8000 */
  oscP5 = new OscP5(this,8000);
}

void oscEvent(OscMessage theOscMessage) {
    String addr = theOscMessage.addrPattern();     
    println(addr);   // uncomment for seeing the raw message
    
    if(addr.indexOf("/4/multitoggle/") !=-1){ // the 8 by 8 square
      String list[] = split(addr,'/');
     int x = int(list[3]);
     int y = int(list[4]);
    square8[x][y]  = int(theOscMessage.get(0).floatValue());
 //   println(" x = "+x+" y = "+y);  // uncomment to see x & Y values
    square8NeedsRedraw = true;
    }
    if(addr.indexOf("/4/toggle") !=-1){   // the strip at the bottom
      int i = int((addr.charAt(9) )) - 0x30;   // retrns the ASCII number so convert into a real number by subtracting 0x30
      square8strip[i]  = int(theOscMessage.get(0).floatValue());
//      println(" i = "+i);   // uncomment to see index value
      square8NeedsRedraw = true;
   }
}

void draw() {
if(square8NeedsRedraw == true) redrawSquare8();  // only redraw the screen if we need to
}

// Update the screen image
void redrawSquare8(){ // redraw the screen
  strokeWeight(2);
  noFill();
  stroke(250,250,0);
  rect(15, 15, 260, 260);  // yellow outline
  noStroke();
  for(int y=1 ; y<9 ; y++){  // draw the matrix
  for(int x=1 ; x<9 ; x++){
    fill(40,40,40);
    rect( x*30-4, y*30-4, 28, 28);   // blank rectangle
        if(square8[x][y] == 1){ 
        fill(250,250,0);
        rect( x*30, y*30, 20, 20);  // fill it in if needed
        }
      }
    }
  strokeWeight(2);
  // draw the strip at the bottom
  stroke(25,150,250);
for( int x = 1 ; x<5 ; x++){
    fill(40,40,40);
    rect( x*60-30, 300, 50, 40);  // draw blank square
    if(square8strip[x] == 1){     // fill it in if that one is pressed
   fill(25,150,250);
    rect( x*60-20, 310, 30, 20);
    }
}
     square8NeedsRedraw = false;  // we have now redrawn it, don't do it again until we have another OSC message
}
