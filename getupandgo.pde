
//get up & go!

Task[] task;
PFont timeFontSmall;
PFont timeFontLarge;


boolean resetBool = true;
int millisEllapsedBeforeStart;
int timeEllapsed;

float targetExitMinutes;

int screenCount;
int currentScreen = 0;
String[] pictureNames = {
  "splash", "bed", "shower", "dress", "cook", "eat", "clean", "pack", "check", "exit"
};
String [] actionNames = {
"null", "Make Bed", "Shower!", "dress", "Cook ur Yums", "Eat", "Do Dishes", "Pack ur bag!", "Check stove & lights", "Now go!"
};
int[] durationTimes = {2,4,1,5,7,8,4,5,2,1};



void startTime(){
    if(!resetBool) {
        resetBool = true;
        millisEllapsedBeforeStart = millis();
   } 
   for(int i=0; i<durationTimes.length; i++){
    targetExitMinutes+=durationTimes[i]; 
   }
}

void setup() {
  size(1280, 768);
  
  sanityCheck(); 
  startTime();
  makeFonts();
  makeObjects();
  
  println("target Exit Minutes: " + targetExitMinutes);

}

void draw() {
  
  background(255);
    getTime();


  checkInput(); 
  
  task[currentScreen].update();  
  task[currentScreen].draw();
}

void checkInput() {

  if (mousePressed) {
    delay(100);
    if (currentScreen < screenCount - 1) {
       task[currentScreen].writeTime(); 
       allocateRemainingTime();       
       currentScreen++;
    }else{
      writeData();
      exit();
    }
  }
}

void allocateRemainingTime(){
  println("currentScreen: " + currentScreen);
  
 float remainingStoredTime = 0;
 float weightedTimeValue = 0;
 float secondsEllapsed = timeEllapsed / 1000;
 float secondsRemaining = (targetExitMinutes*60) - secondsEllapsed; 
 
 println("seconds remaining: " + secondsRemaining + " seconds ellapsed: " + secondsEllapsed);
 
 for(int i = currentScreen; i < durationTimes.length; i++){
    remainingStoredTime += task[i].durationMinutes;
    }
    
    println("remainingStoredTime: " + remainingStoredTime);
    
       //ratio of existing time to total duration should determine new time set
 for(int i = currentScreen + 1; i < durationTimes.length; i++){
      print(pictureNames[i] + "  " + task[i].durationMinutes + "   ");
      //task[i].durationMinutes= (task[i].durationMinutes/remainingStoredTime) * (targetExitMinutes-(secondsEllapsed/60)); 
       task[i].durationMinutes= (task[i].durationMinutes/remainingStoredTime) * targetExitMinutes; 

      println("new duration:   " + task[i].durationMinutes);
    } 
}

void writeData(){
}

void sanityCheck(){
   if (actionNames.length != pictureNames.length || pictureNames.length != durationTimes.length) {
    println("need same length data arrays!");
  exit();
  } 
}

void makeFonts(){
  timeFontSmall = createFont("BlackBoard.ttf", 72, true);
  textFont(timeFontSmall);
  timeFontLarge = createFont("BlackBoard.ttf", 120, true);
  textFont(timeFontLarge); 
}

void makeObjects(){ 
  screenCount = pictureNames.length;
  task = new Task[screenCount];
  for (int i = 0; i < screenCount; i++ ) {
    task[i] = new Task(i, pictureNames[i], actionNames[i], durationTimes[i]);
  }  
}

void getTime(){
  timeEllapsed = millis() - millisEllapsedBeforeStart;
 
}


