//RETUNER! prototype 1
//Tristan Miller 2014
/* concept from Leo Auri. Shifts frequencies of played notes to mutually
arrive at harmonic arrangement (shifting away from equal temperament tuning).

There is also some weird and fun stuff in there. Have fun with this ELECTRONIC TOY  
*/


import ddf.minim.Minim;
import ddf.minim.AudioOutput;
import ddf.minim.ugens.Oscil;
import ddf.minim.ugens.Waves;
import ddf.minim.ugens.Line;


Minim minim;
AudioOutput out;
PFont font;

//Global variables the user will want to modify!

float baseFrequency = 220; //Hz to assign to the "a" key (lowest keyboard frequency)
float baseFrequencyOld = 220;
int octavesBelow = 2;  //basically controls how far to generate the harmonics
int octavesAbove = 2;  //will also be used to scale the display!

float snapRadius = 1/850.; //the smaller the number, the closer the frequencies have to be in order to snap...can lead to some fun oscillations!
float pullFactor = 0.07; //how strongly the frequency pull is...if you want to see the frequencies gradually converge, set this much lower
float distortionProb = 0.05; //probability of patching existing notes to output (producing distortion), when the spacebar is pressed
float wobble = 1;          //limit of random frequency disturbance (Hz) induced either way by holding the spacebar
int fadeFactor = 27;         //relates to how quickly the trails fade away....

//Other global stuff
int maximumNotes = 12; //maximum number of notes to play simultaneously!
boolean adjustMode = false; //controls whether to adapt frequencies to just intonation or not! toggle with "1" and "2"

float frequencyRange;
float freqToPixels;    //these are concerned with the display of the harmonic series on screen

boolean[] downKeys = new boolean[256]; //declare an ARRAY of booleans, effectively a row of 256 switches that can be off or on
boolean[] downKeysOld = new boolean[256]; //this is for tracking the state of the keys in the last frame

float[] defaultTunings = new float[18]; //this stores the default 'equal temperament' tunings - could be derived from config file instead
float[] myTunings = new float[18]; //this will store the adjusted tunings on the fly

int[] pianoKeys = new int[18]; //array for mapping keyboard keys to piano layout

ArrayList noteList;  //declare a List (dynamic array) that will contain Note objects
int liveNotes = 0; //how many notes are still audible in the list?




void setup(){   //this is run once when the app is started

  size(900,700);
  background(0);
  font = loadFont("Amstrad-CPC464-48.vlw");
  frameRate(30);
  
  
  frequencyRange = baseFrequency*pow(2,2) - baseFrequency*pow(2,-1);
  freqToPixels = (frequencyRange - baseFrequency*pow(2,-octavesBelow))/width;
  
  //painstaking mapping of keyboard to be like a piano

  pianoKeys[0] = 97;    //a  A3
  pianoKeys[1] = 119;   //w  A#3
  pianoKeys[2] = 115;   //s  B3
  pianoKeys[3] = 100;   //d  C4
  pianoKeys[4] = 114;   //r  C#4
  pianoKeys[5] = 102;   //f  D4
  pianoKeys[6] = 116;   //t  D#4
  pianoKeys[7] = 103;   //g  E4
  pianoKeys[8] = 104;   //h  F4
  pianoKeys[9] = 117;   //u  F#4
  pianoKeys[10]= 106;   //j  G4
  pianoKeys[11] = 105;  //i  G#4
  pianoKeys[12] = 107;  //k  A4
  pianoKeys[13] = 111;  //o  A#4
  pianoKeys[14] = 108;  //l  B4
  pianoKeys[15] = 59;   //p  C5
  pianoKeys[16] = 91;   //;  C#5
  pianoKeys[17] = 39;   //'  D#5   
  




  
  minim = new Minim(this);     //instatiate a minim object
  out = minim.getLineOut(Minim.STEREO, 512);    //create a line for output direct to sound card



  noteList = new ArrayList(); //instantiate an empty ArrayList to contain the notes as they are created.


  for(int i = 0; i < downKeys.length; i++){  //initialise the arrays for tracking which keys are pressed.
    downKeys[i] = false;
    downKeysOld[i] = false;
  }


  redoTunings();
}

void draw(){  //this function cycles over and over, about 60 times per second if you're lucky.

 noStroke();            //draw a semitransparent rectangle over the lot...leads to nice motion blurring/trails
 rectMode(CORNER);
 fill(0,0,0,fadeFactor);
 rect(0,0,width,height);

 cleanupNotes();        //remove notes from the audio stream if they've faded already - then remove from memory (stops weird interference with zero amplitude waves)
 liveNotes = 0;         //reset count of how many living notes there are (dead ones can still be in the noteList
 for(int i = 0; i < noteList.size(); i++){
   Note thisNote = (Note) noteList.get(i);
   if(!thisNote.fade){
     liveNotes ++;
   }
   
 }
  
 if(noteList.size() > 1 && adjustMode){  //do frequency adjustment if this is active and enough notes are held
  adjustFrequencies();
 }

 checkControls();      //scan for user input


 //SILLINESS FOLLOWS - we must always check for silliness//

  if(noteList.size() > 0){
    silliness();
  }
 
 if(baseFrequencyOld != baseFrequency){
  redoTunings();
  }
  
 baseFrequencyOld = baseFrequency;
 
 drawSpectra();
 drawInfoBox();
 
 //saveFrame("frames/####.png");
}



void keyPressed() {
 if (key<256) {  //if a key is pressed, and its numerical code is less than 256,
   downKeys[key] = true;  //set the corresponding element of downKeys to 'true'
    /* for(int i = 0; i< downKeys.length; i++){
     if(downKeys[i]){  
       println(i);
       } //this FOR LOOP is optional...it goes through the downKeys array
         //one entry at a time, and if it encounters a 'true' (which corresponds to a pressed key)
         //it prints the value of the key to the console (below), using the println() function.
         //This is useful for working out the numerical code for particular keys.
         //For instance, 'space' is 32.
   }*/
     
 }
}

void keyReleased() { //this function returns elements of downKeys to 'false'
 if (key<256) {      //if a change in the key's state is detected.
   downKeys[key] = false;
   //println(0);
  }
}



 
 
 void drawSpectra(){
   for(int i = 0; i < defaultTunings.length; i++){
     pushMatrix();
       translate(0, height - 50);
       rectMode(CENTER);
       noStroke();
       colorMode(HSB);
       fill(0,0,255);
       translate(defaultTunings[i]*freqToPixels, 0);
       rect(0,0,5,30);
     popMatrix();
     
   }
   if(noteList.size() > 0){   //this is for displaying the frequencies...
   int yIndex = 0;
    for(int i = 0; i < noteList.size(); i++){

      Note thisNote = (Note) noteList.get(i);
      float yPos = height - (yIndex+2)*50;
      if(!thisNote.fade){
      yIndex ++;
      pushMatrix();
        translate(0,yPos);
        thisNote.drawHarmonics(freqToPixels);
      popMatrix();
      }
    }
   }
 }
 

 
 
