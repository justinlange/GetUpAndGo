//import android.view.inputmethod.InputMethodManager;
//import android.content.Context;

import java.lang.Iterable;

//get up & go!

// table functions 
int lastSession;
int numberRows;
String sessionString;

Task[] task;

PFont timeFontSmall;
PFont timeFontMedium;
PFont timeFontLarge;

int counter = 0;
int millisEllapsedBeforeStart;
int timeEllapsed;

boolean resultsPage = false;
boolean resetBool = false;
boolean resultsWritten = false;
boolean tableExists = true;

float targetExitMinutes;

int screenCount;
int currentScreen = 0;
String[] pictureNames = {
  "splash", "bed", "shower", "dress", "cook", "eat", "clean", "pack", "check", "exit"
};
String [] actionNames = {
  "wakingzzz", "Make Bed", "Shower!", "dress", "Cook ur Yums", "Eat", "Do Dishes", "Pack ur bag!", "Check stove", "Now go!"
};

String [] resultNames = {
  "wakingzzz", "making bed", "showering", "dressing", "cooking", "eating", "doing dieshes", "packing", "final checks", "Now go!"
};

int[] durationTimes = {
  4, 5, 12, 5, 7, 8, 4, 5, 2, 1
};

Table resultTable;

int mWidth = 1280;
int mHeight =768;



void setup() {
  size(1280, 768); 

  setupTable();
  sanityCheck(); 
  startTime();
  makeFonts();
  makeObjects();

  println("target Exit Minutes: " + targetExitMinutes);
}



void draw() {

  background(255);
  getTime();

  task[currentScreen].draw();

  if (!resultsPage) {
    task[currentScreen].update();
  }
  else { 
    drawResults();
  }
}


void startTime() {
  if (!resetBool) {
    resetBool = true;
    millisEllapsedBeforeStart = millis();
  } 
  for (int i=0; i<durationTimes.length; i++) {
    targetExitMinutes+=durationTimes[i];
  }
}

void allocateRemainingTime() {

  float remainingStoredTime = 0;
  float weightedTimeValue = 0;
  float secondsEllapsed = timeEllapsed / 1000;
  float secondsRemaining = (targetExitMinutes*60) - secondsEllapsed; 


  for (int i = currentScreen; i < durationTimes.length; i++) {
    remainingStoredTime += task[i].durationMinutes;
  }

  for (int i = currentScreen + 1; i < durationTimes.length; i++) {
    //print(pictureNames[i] + "  " + task[i].durationMinutes + "   ");
    task[i].durationMinutes= (task[i].durationMinutes/remainingStoredTime) * targetExitMinutes;
  }
}

void sanityCheck() {
  if (actionNames.length != pictureNames.length || pictureNames.length != durationTimes.length) {
    println("need same length data arrays!");
    exit();
  }
}

void makeFonts() {

  timeFontSmall = createFont("BlackBoard.ttf", 36, true);
  textFont(timeFontSmall);
  timeFontMedium = createFont("BlackBoard.ttf", 72, true);
  textFont(timeFontMedium);
  timeFontLarge = createFont("BlackBoard.ttf", 120, true);
  textFont(timeFontLarge);
}

void makeObjects() { 
  screenCount = pictureNames.length;
  task = new Task[screenCount];
  for (int i = 0; i < screenCount; i++ ) {
    task[i] = new Task(i, pictureNames[i], actionNames[i], durationTimes[i]);
  }
task[0].drawType = false;

}

void getTime() {
  timeEllapsed = millis() - millisEllapsedBeforeStart;
}

void drawResults() {
  int yPos = 150;
  int tg = 50;

  fill(150, 150);
  noStroke();
  rect(0, 100, mWidth, mHeight-200);
  fill(50);

  //make headers
  textAlign(CENTER);
  text("Today", 550, yPos);
  text("Yesterday", 900, yPos); 

  textAlign(LEFT);
  textFont(timeFontSmall); 
  
  yPos += tg;
  
  for (int i = 0; i< screenCount; i++) { 
    text(resultNames[i], 100, yPos + i*tg);
    textAlign(LEFT);
    text(task[i].timeString, 550, yPos + i*tg);   
    }
    int ig = 0;
 
 /*   
 for (TableRow row: resultTable.findRows(sessionString, "session")) {
    textAlign(RIGHT);
    text(floor((row.getInt("time"))/60), 880, yPos+ ig);
    text(":", 895, yPos +ig);
    textAlign(LEFT);
    text(nf((row.getInt("time"))%60,2), 900, yPos+ ig);
    ig+= tg;
 } 
 
*/
 
    TableRow row = resultTable.findRow(sessionString, "session");
    //print("sessionString: " + sessionString);

    int tIterator = row.getInt("id");
    
    print("  tIterator: " + tIterator); 
    
    for (int i = tIterator; i< tIterator+10; i++){
      println("  i: " + i);
      TableRow nRow = resultTable.getRow(i);
      textAlign(RIGHT);
      text(floor((nRow.getInt("time"))/60), 880, yPos+ tg*ig);
      text(":", 895, yPos +i);
      textAlign(LEFT);
      text(nf((nRow.getInt("time"))%60,2), 900, yPos+ tg*ig);
      ig++;
 } 
 
}


void mouseReleased() {

  /* 
   if(screenCounter < 1){
   if(buttonCheck(mouseX, mouseY){
   println("button works!"); 
   }
   }
   */

  if (resultsPage) exit();
  if (currentScreen < screenCount - 1) {
    task[currentScreen].writeTime(); 
    allocateRemainingTime();       
    currentScreen++;
  }
  else {
    resultsPage = true;
    task[currentScreen].drawType = false;
    if (!resultsWritten) writeData();
    resultsWritten = true;
  }
}


boolean buttonCheck(int x, int y) { 

  return false;
}




