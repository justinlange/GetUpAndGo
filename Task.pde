class Task
{
  
int order;
String pictureName;
String actionName;
int startTime;
PImage mScreen;

//time functions
float duration;
long timeEllapsedBeforeStart = 0;
boolean resetBool = false;
float mTime;
boolean timeUp = false;

float textPosX, textPosY;   
  
Task(int _order, String _pictureName, String _actionName, float _duration) 
{
  int order = _order;
  pictureName = _pictureName;
  actionName = _actionName;
  float duration = _duration;
  
  mScreen = loadImage(pictureName + ".png"); 
  textPosX = width/2;
  textPosY = height*.7;
  

}

void update() {
  if(!resetBool) timeEllapsedBeforeStart = millis();
  resetBool = true;
  mTime = duration - (millis() - timeEllapsedBeforeStart);
  if(mTime <= 0) timeUp = true;  
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
   textAlign(CENTER);
   textFont(timeFontLarge);
   text(actionName, textPosX, textPosY/2);
   textFont(timeFontSmall);
   text("05:36", textPosX, textPosY); 
}
}

void startTimer(){    
  
}

  
  
