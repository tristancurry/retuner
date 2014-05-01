void checkControls(){

//ADJUST MODE ON/OFF
if(downKeys[49]){
   adjustMode = false;
 }
 if(downKeys[50]){
  adjustMode = true;
 }

//BASE FREQUENCY
if(downKeys[118] && baseFrequency > 0.1){
  baseFrequency = baseFrequency - 0.1;
}
if(downKeys[98]){
   baseFrequency = baseFrequency + 0.1;
}
 baseFrequency = round(baseFrequency*1000);
 baseFrequency = baseFrequency/1000;


//SNAP RADIUS
if(downKeys[44] && snapRadius > 0.0005){
  snapRadius = snapRadius - 0.0005;
}
if(downKeys[46]){
   snapRadius = snapRadius + 0.0005;
}


//STRENGTH
if(downKeys[110] && pullFactor > 0.005){
  pullFactor = pullFactor - 0.005;
}
if(downKeys[109]){
   pullFactor = pullFactor + 0.005;
}


//WOBBLE
if(downKeys[45] && wobble > 0.0){
  wobble = wobble - 0.1;
}
if(downKeys[61]){
   wobble = wobble + 0.1;
}
  wobble = round(wobble*1000);
  wobble = wobble/1000;


//FADE FACTOR
if(downKeys[120] && fadeFactor > 0){
  fadeFactor = fadeFactor - 1;
}
if(downKeys[99] && fadeFactor < 255){
   fadeFactor = fadeFactor + 1;
}

//KILL THE AUDIO
if(downKeys[47]){   //sometimes you're left with weird clicks and rumbles after messing around with the above. press "." to stop it all.
   minim.stop();
   minim = new Minim(this);
   out = minim.getLineOut();
 }
 
 
//PIANO 
   for(int i = 0; i < pianoKeys.length; i++){
    int k = pianoKeys[i];
    if(downKeys[k] && !downKeysOld[k] && noteList.size()< maximumNotes){               //if this piano key is depressed, and wasn't before, create a new Note corresponding to that frequency, add it to the list and play it.
      Note newNote = new Note(defaultTunings[i], out, i);
      noteList.add(newNote);
      newNote.blast();

    }
   if(!downKeys[k] && downKeysOld[k] && noteList.size() > 0){ //if this piano key is released, and it wasn't already, find any corresponding notes in the list and kill 'em!
     for(int j = 0; j < noteList.size(); j++){
        Note thisNote = (Note) noteList.get(j);
        if (thisNote.index == i){
           thisNote.fade();
        }
      }
     }
   downKeysOld[k] =  downKeys[k];   //store the current state of the keys
 }
}
