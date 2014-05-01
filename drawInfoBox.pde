 void drawInfoBox(){
   rectMode(CORNER);
   strokeWeight(10);
   stroke(220,200,200);
   fill(0,0,0);
   rect(0,0,width,height/2 + 10);
   /////TITLE/////
   pushMatrix();
   translate(10,10);
   textFont(font,32);
   textAlign(LEFT,TOP);
   fill(0,0,255);
   text("Re-Tuner",0,0);
   popMatrix();
   /////SUBTITLE/////
   pushMatrix();
   translate(10,50);
   textFont(font,16);
   fill(0,0,255);
   text("a frequency adjuster",0,0);
   popMatrix();
   /////CONTROL LIST/////
   pushMatrix();
   translate(10,80);
   textFont(font,16);
   colorMode(RGB);
   fill(255,255,0);
   text("Controls",0,0);
   translate(0,25);
   fill(255);
   text("---------------------------",0,0);
   textFont(font,14);
   translate(0,25);
   text("a - ' >>> the white keys...",0,0);
   translate(0,25);
   text("1/2   >>> retuning OFF/ON",0,0);
   translate(0,25);
   text("Space >>> silly effect",0,0);
   translate(0,25);
   text("/     >>> kill sounds",0,0);
   translate(0,25);
   text("</>   >>> snap radius DWN/UP",0,0);
   translate(0,25);
   text("n/m   >>> strength DWN/UP",0,0);
   translate(0,25);
   text("v/b   >>> base frequency DWN/UP",0,0);
   translate(0,25);
   text("x/c   >>> wobble DWN/UP",0,0);
   translate(0,25);
   text("-/+   >>> trail decay DWN/UP",0,0);
   popMatrix();
   /////STATUS HEADINGS/////
   pushMatrix();
   translate(500,80);
   textFont(font,16);
   colorMode(RGB);
   fill(255,255,0);
   text("Status",0,0);
   translate(0,25);
   fill(255);
   text("------------",0,0);
   textFont(font,14);
   translate(0,25);
   text("Fundamental >>>",0,0);
   translate(0,25);
   text("Retuning    >>>",0,0);
   translate(0,25);
   text("Silly?      >>>",0,0);
   translate(0,25);
   text("Notes       >>>",0,0);
   translate(0,25);
   text("Snap radius >>>",0,0);
   translate(0,25);
   text("Strength    >>>",0,0);
   translate(0,25);
   text("Base freq.  >>>",0,0);
   translate(0,25);
   text("Wobble limit>>>",0,0);
   translate(0,25);
   text("Trail decay >>>",0,0);
   popMatrix();
   
   /////STATUS INDICATORS/////
   pushMatrix();
   translate(720,80);
   colorMode(RGB);
   translate(0,25);
   fill(255);
   textFont(font,14);
   translate(0,25);
   if(liveNotes>0){
     for(int i = 0; i < noteList.size(); i++){
       Note thatNote = (Note) noteList.get(i);
       if(!thatNote.fade){
         colorMode(HSB);
         thatNote.freq = round(thatNote.freq*1000);
         thatNote.freq = thatNote.freq/1000;
         fill((255*(thatNote.freq/220))%255,255,255);
         text(thatNote.freq + " Hz",0,0);
         colorMode(RGB);
         break;
       }
      }
     } else {
    
    fill(255,0,0);
    text("NONE",0,0);
   } 
   translate(0,25);
   if(adjustMode){
     fill(0,255,0);
     text("ON",0,0);
     } else {
    fill(255,0,0);
    text("OFF",0,0);
   } 
   translate(0,25);
   if(downKeys[32]){
     fill(0,255,0);
     text("YEP",0,0);
     } else {
    fill(255,0,0);
    text("NOPE",0,0);
   } 
   translate(0,25);
   if(liveNotes > 0){
     fill(0,255,0);
     text(liveNotes,0,0);
     } else {
    fill(255,0,0);
    text("NONE",0,0);
   }
   translate(0,25);
   colorMode(HSB);
   fill((25500*snapRadius)%255,255,255);
   text(snapRadius,0,0);
   translate(0,25);
   colorMode(HSB);
   fill((2550*pullFactor)%255,255,255);
   text(pullFactor,0,0);
   translate(0,25);
   colorMode(HSB);
   fill((255*(baseFrequency/220))%255,255,255);
   text(baseFrequency + " Hz",0,0);
   translate(0,25);
   colorMode(RGB);
   fill(255,255,0);
   text(wobble + "Hz",0,0);
   translate(0,25);
   fill(255,255,0);
   text(fadeFactor,0,0);
   popMatrix();
   
   /////MISC/////
   pushMatrix();
   translate(width-10, 10);
   textAlign(RIGHT,TOP);
   textFont(font,14);
   colorMode(RGB);
   fill(0,255,255);
   text("some kinda Leo - Tristan thing 2014",0,0);
   translate(0,25);
   fill(random(0,255),random(0,255),random(0,255));
   text("make sure caps lock is off!",0,0);
   popMatrix();
 }
