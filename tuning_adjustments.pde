void redoTunings(){

for(int i = 0; i < defaultTunings.length; i++){
    if(i == 0){
      defaultTunings[i] = baseFrequency; //set frequency of lowest note on virtual piano. this should be dynamically modifiable by the user, actually
    } else {
      defaultTunings[i] = 1.059463*defaultTunings[i-1]; //apply ET ratio to previous frequency, to find this frequency!
      defaultTunings[i] = round(1000*defaultTunings[i]); //round to 3 decimal places part 1
      defaultTunings[i] = defaultTunings[i]/1000;        //complete the rounding!
    }
  }
}

void adjustFrequencies(){

  if(liveNotes > 0){
    for(int i = 0; i< noteList.size(); i++){    //if there are any live notes, get the oldest (ie first note in noteList that isn't fading.//remake the harmonics just for the silliness effect. call it "thisNote".
      Note thisNote = (Note) noteList.get(i);   //if there are more than one live note, grab any one that isn't the oldest (i.e. go through notelist, from the index of thisNote)
      if(!thisNote.fade){
        thisNote.makeHarmonics();
      
        if(liveNotes > 1 && adjustMode){
        
          for(int j = i+1; j < noteList.size(); j++){
            Note thatNote = (Note) noteList.get(j);
            if(!thatNote.fade){
              float fund = thatNote.freq;
              int h = thisNote.harmonics.length;
              float[] dist = new float[h];
              float[] pull = new float[h];
            
              for(int k = 0; k < h; k++){
                dist[k] = thisNote.harmonics[k] - fund;
                if(abs(dist[k]) > thisNote.harmonics[k]*snapRadius){
                  pull[k] = pullFactor/(dist[k]);
                  fund = fund + pull[k];
                 } else {
                  fund = thisNote.harmonics[k];
                  break;   //break out of this loop if snapped to a harmonic of the base note. 
                }
              }
              thatNote.freq = fund;
              thatNote.makeHarmonics();
              thatNote.wave.setFrequency(thatNote.freq);  
            }
          }
        
        }
        break; //break out of the loop if there aren't any other notes to adjust
      }
    }
  }
}


void silliness(){
    for(int i = 0; i < noteList.size(); i++){
      Note thisNote = (Note) noteList.get(i);
      if(downKeys[32] && !downKeysOld[32] && !thisNote.fade){
        if(random(0,1) <= distortionProb){
            thisNote.blast(); 
        }
      }  if(downKeys[32] && downKeysOld[32] && !thisNote.fade){
        float crom = thisNote.freq + random(-wobble,wobble);
        if(crom > 0){
        thisNote.freq = crom;
        thisNote.wave.setFrequency(thisNote.freq);
        adjustFrequencies();
        }
     
    }
    downKeysOld[32] = downKeys[32];
  } 
}
