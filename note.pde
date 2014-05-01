class Note {
  
Oscil wave;  
float freq;
int octaves = octavesAbove + octavesBelow;
float[] harmonics = new float[(octaves*12) + 1];
float[] intonations = new float[12];

boolean fade;
boolean dead;


AudioOutput output;
int index;
Line ampEnv;
  
Note(float _freq, AudioOutput _output, int _index){
  freq = _freq;
  wave = new Oscil( freq, 0.5f, Waves.randomNHarms(7));
  output = _output;
  index = _index;
  
    intonations[0] = 1;
    intonations[1] = 16/15.;
    intonations[2] = 9/8.;
    intonations[3] = 6/5.;
    intonations[4] = 5/4.;
    intonations[5] = 4/3.;
    intonations[6] = 7/5.;
    intonations[7] = 3/2.;
    intonations[8] = 8/5.;
    intonations[9] = 5/3.;
    intonations[10] = 16/9.;
    intonations[11] = 15/8.;
  
  makeHarmonics();
  
  ampEnv = new Line(0, 0.5f, 0.5f);
  ampEnv.patch(wave.amplitude);


  fade = false;
  dead = false;

  

}  
  
  void blast(){
     ampEnv.activate();
    wave.patch(output);

  }
  
  void unblast(){
    dead = true;
    wave.unpatch(output);

  }
  
  void fade(){
    fade = true;
    //wave.setFrequency(freq*1.5);
    ampEnv.setLineTime(1);
    ampEnv.setEndAmp(0);


  }
  
  void makeHarmonics(){
    for(int i = 0; i < octaves; i++){
      float octaveMultiplier = pow(2, -octavesBelow + i);
      for(int j = 0; j < intonations.length; j++){
        harmonics[j + 12*i] = octaveMultiplier*freq*intonations[j];  
      }
    }
   harmonics[harmonics.length - 1] = freq*pow(2,octavesAbove);
  }
  


  void drawHarmonics(float xScale){
    rectMode(CENTER);
    noStroke();
    fill((freq*255/220)%255,255,255);
    noSmooth();
    for(int i = 0; i < harmonics.length; i++){
      rect(harmonics[i]*xScale,0,5,30);
    }
    rect(freq*xScale,0,5,60);
    }
 }

