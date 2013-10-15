class Timer
{
  float duration;
  
  long timeEllapsedBeforeStart = 0;
  boolean resetBool = false;
  float mTime;
  
  
  Timer(float _duration)
  {
    
    duration = _duration;
  }
  
  void startTimer(){
    
    if(!resetBool) timeEllapsedBeforeStart = millis();
    resetBool = true;
 
  }
  
  float returnTime()
  {
    mTime = duration - (millis() - timeEllapsedBeforeStart);
    return mTime;    
  }
  
  boolean timeUp()
  {
    if(mTime <= 0){
      return true;
    }
    return false;
  }
}
