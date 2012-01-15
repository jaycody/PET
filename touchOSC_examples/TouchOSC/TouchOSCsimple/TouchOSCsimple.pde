/**
 * TouchOSC
 * 
 * Example displaying all screens of "simple"
 * the "Simple" layout (all pages)
 * By Mike Cook
 * http://www.thebox.myzen.co.uk
 *
 */

import oscP5.*;
import netP5.*;
OscP5 oscP5;

int [] sliderStrip = new int [5];
float [] fader = new float [6];
boolean sliderNeedsRedraw = true;
boolean square4NeedsRedraw = true;
int [] square4 = new int [17]; 
int [] square4strip = new int [5];
boolean xyPadNeedsRedraw = true;
float xPad = 0.5, yPad = 0.5; 
int [] xyPadStrip = new int [5];
boolean square8NeedsRedraw = true;
int [][] square8 = new int [9][9]; 
int [] square8strip = new int [5];

void setup() {
  size(290,360);
  frameRate(25);
  background(0);
   fader[1] = 0.5;
  /* start oscP5, listening for incoming messages at port 8000 */
  oscP5 = new OscP5(this,8000);
}

void oscEvent(OscMessage theOscMessage) {

    String addr = theOscMessage.addrPattern();
    if(addr.indexOf("/1") !=-1){
    sliderNeedsRedraw = true;
   }
   if(addr.indexOf("/2") !=-1){
    square4NeedsRedraw = true;
   }
   if(addr.indexOf("/3") !=-1){
    xyPadNeedsRedraw = true;
   }
   if(addr.indexOf("/4") !=-1){
    square8NeedsRedraw = true;
   }
  //    println(addr);   // uncomment for seeing the raw message
   // float  val  = theOscMessage.get(0).floatValue();
   if(addr.indexOf("/1/fader") !=-1){ // one of the faders
       String list[] = split(addr,'/');
     int  xfader = int(list[2].charAt(5) - 0x30);
     fader[xfader]  = theOscMessage.get(0).floatValue();
 //   println(" x = "+fader[xfader]);  // uncomment to see x values
    sliderNeedsRedraw = true;
    }
    
       if(addr.indexOf("/1/toggle") !=-1){   // the strip at the bottom
      int i = int((addr.charAt(9) )) - 0x30;   // retrns the ASCII number so convert into a real number by subtracting 0x30
      sliderStrip[i]  = int(theOscMessage.get(0).floatValue());
//      println(" i = "+i);   // uncomment to see index value
      sliderNeedsRedraw = true;
   }
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
if(sliderNeedsRedraw == true) redrawSliders();  // only redraw the screen if we need to
if(square4NeedsRedraw == true) redrawSquare4();  // only redraw the screen if we need to
if(xyPadNeedsRedraw == true) redrawxyPad();  // only redraw the screen if we need to
if(square8NeedsRedraw == true) redrawSquare8();  // only redraw the screen if we need to
}

void redrawSliders() {
int x;
      background(0);
      // fader 5
    stroke(0, 196, 168); 
    fill(40,40,40); 
     rect(30,20,230,40); // outline
    // fader5
    fill(0, 196, 168);
    rect(30+fader[5]*220,20,10,40); // solid rectangle
    fill(0, 196, 168, 50);
    rect(30,20,fader[5]*220,40); // shaded rectangle
      
    // fader 1-4 outlines
     fill(40,40,40);
    stroke(255, 237, 0);
    for(  x = 1 ; x<5 ; x++){
    rect( x*60-30, 80, 50, 210);
     }
     
    // fader 1-4 fills
     for(  x = 1 ; x<5 ; x++){
     fill(255, 237, 0);
     rect( x*60-30, 80 + 200 - fader[x]*200 ,  50, 10); // solid bar 
     fill(255, 237, 0, 50);
     rect( x*60-30, 80 + 200 - fader[x]*200 ,  50, 10+ fader[x]*200 );
     }
    
  strokeWeight(2);
  // draw the strip at the bottom
  stroke(25,150,250);
  for(  x = 1 ; x<5 ; x++){
    fill(40,40,40);
    rect( x*60-30, 300, 50, 40);  // draw blank square
    if(sliderStrip[x] == 1){     // fill it in if that one is pressed
   fill(25,150,250);
    rect( x*60-20, 310, 30, 20);
    }
}
     sliderNeedsRedraw = false;  // we have now redrawn it, don't do it again until we have another OSC message

}
// Update the screen image
void redrawSquare4(){ // redraw the screen
  background(0);
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
// Update the screen image
void redrawxyPad(){ // redraw the screen
  background(0);
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
// Update the screen image
void redrawSquare8(){ // redraw the screen
  background(0);
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
