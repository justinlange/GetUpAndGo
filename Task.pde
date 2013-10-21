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
float originalDurationMinutes;
float secondsEllapsed;
float mSecondsLeft;
float mMinutesLeft;
int mSecondsToDisplay;
int mMinutesToDisplay;
int varFill = 0;
int textColor = 50;

boolean resetBool = false;
boolean firstUpdate = true;
boolean timeUp = false;
boolean secondsLeft = false;
boolean drawType = true;
boolean canSkip = false;

float seconds = 60;

float textPosX, textPosY;   
  
Task(int _order, String _pictureName, String _actionName, float _durationMinutes) 
{
  int order = _order;
  pictureName = _pictureName;
  actionName = _actionName;
  durationMinutes = _durationMinutes;
  originalDurationMinutes = durationMinutes;
  
  mScreen = loadImage(pictureName + ".png"); 
  textPosX = mWidth/2;
  textPosY = mHeight*.7;
  
  timeString = " ";
  resultsString = " ";
   
}

void update() {
  
  if(firstUpdate){
    if(durationMinutes < originalDurationMinutes*.9 && canSkip == true){
      println("origDurMins: " + originalDurationMinutes + "  durationMintues: " + durationMinutes);
      mScreen = loadImage(replacementImages[currentScreen] + ".png");
      actionName = replacementActions[currentScreen];
    }
   firstUpdate = false; 
  }
  
  
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

float checkTime(){
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
  
   textAlign(LEFT);
   textFont(timeFontMedium); 
   text(timeString, textPosX-50, textPosY); 
   
   if(varFill < 255 && checkTime() < 2) varFill+=7;
   
   if(varFill > 0 && checkTime() > 3) varFill-=3;
   
   textAlign(CENTER);
   fill(textColor, varFill);   
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

  
  
