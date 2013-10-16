class Task
{
  
int order;
String pictureName;
String actionName;
float startTime;
PImage mScreen;
String timeString;
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
  textPosX = mWidth/2;
  textPosY = mHeight*.7;
  
  timeString = " ";
 
}

void update() {
   mSecondsLeft = (durationMinutes * 60) - (millis()/1000 - millisEllapsedBeforeStart/1000);
   mSecondsToDisplay = int( mSecondsLeft % 60);
   mMinutesLeft = (mSecondsLeft)/60;
   mMinutesToDisplay = int(mMinutesLeft); 
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
  
   fill(50);
   textAlign(CENTER);
   textFont(timeFontLarge);
   text(actionName, textPosX, textPosY/2);
   
   timeString = mMinutesToDisplay + " : " + mSecondsToDisplay;
   textFont(timeFontMedium); 
   text(timeString, textPosX, textPosY); 
}
}

void startTimer(){    
  
}

  
  
