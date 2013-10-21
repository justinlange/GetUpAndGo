class Task
{
  
int millisEllapsedAtStart;
int secondsTaken;
int order;
String pictureName;
String actionName;
float startTime;
PImage mScreen;
String timeString;
String resultsString;
//time functions

float durationMinutes;
float secondsEllapsed;
float mSecondsLeft;
float mMinutesLeft;
int mSecondsToDisplay;
int mMinutesToDisplay;
int varFill = 255;
int textColor = 50;

boolean resetBool = false;
boolean timeUp = false;
boolean secondsLeft = false;
boolean drawType = true;

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
  resultsString = " ";
   
}

void update() {
   mSecondsLeft = (durationMinutes * 60) - (millis()/1000 - millisEllapsedAtStart/1000);
   mMinutesLeft = (mSecondsLeft)/60;
   
   if(floor(mMinutesLeft) < 1) timeUp = true;

   mSecondsToDisplay = int( mSecondsLeft % 60);
   mMinutesToDisplay = int(mMinutesLeft); 
   timeString = mMinutesToDisplay + " : " + nf(mSecondsToDisplay, 2);
  
}

void writeTime(){ 
  secondsTaken = millis() - millisEllapsedAtStart;
  secondsTaken = secondsTaken/1000;
  
  int secondsTakenToDisplay = secondsTaken % 60;
  int minutesTaken = secondsTaken/60;
  resultsString = minutesTaken + " : " + nf(secondsTakenToDisplay, 2);
  println("results string: " + resultsString + " secondsTaken: " + secondsTaken);
}

int checkTime(){
  secondsTaken = millis() - millisEllapsedAtStart;
  secondsTaken = secondsTaken/1000;
  return secondsTaken;
}

void draw() {
  
   image(mScreen, 0, 0);
   if(drawType){
     drawType();
   }     
}

void drawType() {
  
  
  if(!timeUp){
    fill(textColor);
  }else{
    fill(235,25,25);
  }
  
   textAlign(CENTER);
   
   textFont(timeFontMedium); 
   text(timeString, textPosX, textPosY); 
   
   if(varFill > 0 && checkTime() > 3) varFill-=3;
   fill(textColor, varFill);
   
   println("textColor: " + textColor + "  varFill: " + varFill);
   
   textFont(timeFontLarge);
   text(actionName, textPosX, textPosY/2); 
   
   

}

void startTimer(){ 
  if(!resetBool){  
    millisEllapsedAtStart = millis(); 
    resetBool = true;
  }
}

}

  
  
