class Task
{
  
int order;
String pictureName;
String actionName;
float startTime;
PImage mScreen;

//time functions
float durationMinutes;

float secondsEllapsed;
float mSecondsLeft;
float mMinutesLeft;
int mSecondsToDisplay;
int mMinutesToDisplay;

boolean resetBool = false;
boolean timeUp = false;
boolean secondsLeft = false;

float seconds = 60;

float textPosX, textPosY;   
  
Task(int _order, String _pictureName, String _actionName, float _durationMinutes) 
{
  int order = _order;
  pictureName = _pictureName;
  actionName = _actionName;
  durationMinutes = _durationMinutes;
  
  mScreen = loadImage(pictureName + ".png"); 
  textPosX = width/2;
  textPosY = height*.7;
  

}

void update() {
  
   mSecondsLeft = (durationMinutes * 60) - (millis()/1000 - millisEllapsedBeforeStart/1000);
   mSecondsToDisplay = int( mSecondsLeft % 60);
   mMinutesLeft = (mSecondsLeft)/60;
   mMinutesToDisplay = int(mMinutesLeft);
    //mSecondsLeft = seconds - (millis()/1000 - millisEllapsedBeforeStart/1000) % 60;
    
   // mMinutesLeft = ((durationMinutes*60 - mSecondsLeft)/60) % 60;
   // mMinutesLeft = durationMinutes   

   
/*  
  minutesLeft = durationMinutes + 60 - (minute() - timeEllapsedBeforeStart); 
  if(mMinutes < 1){
    if(!secondsLeft){
       secondsLeft = true;
    }
  }
  
  */
 
}

void writeTime(){ 
}

void draw() {
   image(mScreen, 0, 0);
   if(currentScreen > 0){
     drawType();
   }     
}

void drawType() {
  //int seconds = minute(mTime);
  
   textAlign(CENTER);
   textFont(timeFontLarge);
   text(actionName, textPosX, textPosY/2);
   
   String timeString = mMinutesToDisplay + " : " + mSecondsToDisplay;
   textFont(timeFontSmall); 
   text(timeString, textPosX, textPosY); 
}
}

void startTimer(){    
  
}

  
  
