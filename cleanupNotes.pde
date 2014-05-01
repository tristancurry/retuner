void cleanupNotes(){
  for(int i = 0; i < noteList.size(); i++){
    Note thisNote = (Note) noteList.get(i);
    if(thisNote.fade){
      //liveNotes --;
    }
    
    if(thisNote.fade && thisNote.ampEnv.isAtEnd() && !thisNote.dead){
      thisNote.unblast();
      
    }
    if(thisNote.dead){
       //liveNotes --;
      noteList.remove(i);

    }

  }
}



