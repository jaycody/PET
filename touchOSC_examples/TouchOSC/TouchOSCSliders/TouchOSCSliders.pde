/**
 * TouchOSC
 * 
 * Example displaying sliders
 * the "Simple" layout (Page1) sliders
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
      println(addr);   // uncomment for seeing the raw message
   // float  val  = theOscMessage.get(0).floatValue();
   if(addr.indexOf("/1/fader") !=-1){ // one of the faders
       String list[] = split(addr,'/');
     int  xfader = int(list[2].charAt(5) - 0x30);
     fader[xfader]  = theOscMessage.get(0).floatValue();
    println(" x = "+fader[xfader]);  // uncomment to see x values
    sliderNeedsRedraw = true;
    }
    
       if(addr.indexOf("/1/toggle") !=-1){   // the strip at the bottom
      int i = int((addr.charAt(9) )) - 0x30;   // retrns the ASCII number so convert into a real number by subtracting 0x30
      sliderStrip[i]  = int(theOscMessage.get(0).floatValue());
//      println(" i = "+i);   // uncomment to see index value
      sliderNeedsRedraw = true;
   }
    
}

void draw() {
if(sliderNeedsRedraw == true) redrawSliders();  // only redraw the screen if we need to
}

void redrawSliders() {
int x;
  //    background(0);
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
