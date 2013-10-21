package processing.test.getupandgo;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import android.content.Intent; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class getupandgo extends PApplet {

//import android.view.inputmethod.InputMethodManager;
//import android.content.Context;

//import java.lang.Iterable;


String subject = "Test from your Android device!";
String emailBody = "This is an email, sent from your Android device. Congrats!";
String tablePath = "/sdcard/Pictures/results.csv";

Intent email;

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
  1, 2, 10, 3, 8, 5, 3, 4, 2, 1
};

Table resultTable;

int mWidth = 1280;
int mHeight =768;



public void setup() {
  

  setupTable();
  sanityCheck(); 
  startTime();
  makeFonts();
  makeObjects();

  println("target Exit Minutes: " + targetExitMinutes);
}



public void draw() {

  
  background(255);
  getTime();

  task[currentScreen].startTimer();
  task[currentScreen].draw();
  
 

  if (!resultsPage) {
    task[currentScreen].update();
  }
  else { 
    drawResults();
  }
  
   fill(0);
  stroke(0,255,0);
  rect(100, 800,100,100);
  

}


public void startTime() {
  if (!resetBool) {
    resetBool = true;
    millisEllapsedBeforeStart = millis();
  } 
  for (int i=0; i<durationTimes.length; i++) {
    targetExitMinutes+=durationTimes[i];
  }
}

public void allocateRemainingTime() {

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

public void sanityCheck() {
  if (actionNames.length != pictureNames.length || pictureNames.length != durationTimes.length) {
    println("need same length data arrays!");
    exit();
  }
}


public void makeObjects() { 
  screenCount = pictureNames.length;
  task = new Task[screenCount];
  for (int i = 0; i < screenCount; i++ ) {
    task[i] = new Task(i, pictureNames[i], actionNames[i], durationTimes[i]);
  }
task[0].drawType = false;

}

public void getTime() {
  timeEllapsed = millis() - millisEllapsedBeforeStart;
}


public void mouseReleased() {
  /* 
   if(screenCounter < 1){
   
   }
   */
   
  if(buttonCheck(300, 800,100,100)){
   println("button works!"); 
   }
   

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


public boolean buttonCheck(int x, int y, int w, int h) { 
  
  if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) return true;
  return false;
 
}

public void sendEmail() {
  try {
    // create email message
    email = new Intent(Intent.ACTION_SEND);
    email.setType("text/plain");
    email.putExtra(Intent.EXTRA_SUBJECT, subject);
    email.putExtra(Intent.EXTRA_TEXT, emailBody);

    // send!
    startActivity(Intent.createChooser(email, "Send email..."));
  }
  catch (android.content.ActivityNotFoundException ex) {
    println("No email client installed, email failed... :(");
  }
}




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
  textPosY = mHeight*.7f;
  
  timeString = " ";
  resultsString = " ";
   
}

public void update() {
   mSecondsLeft = (durationMinutes * 60) - (millis()/1000 - millisEllapsedAtStart/1000);
   mMinutesLeft = (mSecondsLeft)/60;
   
   if(floor(mMinutesLeft) < 1) timeUp = true;

   mSecondsToDisplay = PApplet.parseInt( mSecondsLeft % 60);
   mMinutesToDisplay = PApplet.parseInt(mMinutesLeft); 
   timeString = mMinutesToDisplay + " : " + nf(mSecondsToDisplay, 2);
  
}

public void writeTime(){ 
  secondsTaken = millis() - millisEllapsedAtStart;
  secondsTaken = secondsTaken/1000;
  
  int secondsTakenToDisplay = secondsTaken % 60;
  int minutesTaken = secondsTaken/60;
  resultsString = minutesTaken + " : " + nf(secondsTakenToDisplay, 2);
  println("results string: " + resultsString + " secondsTaken: " + secondsTaken);
}

public int checkTime(){
  secondsTaken = millis() - millisEllapsedAtStart;
  secondsTaken = secondsTaken/1000;
  return secondsTaken;
}

public void draw() {
  
   image(mScreen, 0, 0);
   if(drawType){
     drawType();
   }     
}

public void drawType() {
  
  
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

public void startTimer(){ 
  if(!resetBool){  
    millisEllapsedAtStart = millis(); 
    resetBool = true;
  }
}

}

  
  
public void drawResults() {
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
    text(task[i].resultsString, 550, yPos + i*tg);   
    }


    TableRow row = resultTable.findRow(sessionString, "session");
    int tIterator = row.getInt("id");
    int loopEnd = tIterator+screenCount;    
     println("tIterator: " + tIterator);
   
    int ig = 0; // for drawing   
    
    for (int i = tIterator; i< loopEnd; i++){
      print("  i: " + i + "  ig: " + ig + "  yPos: " + yPos);
      TableRow nRow = resultTable.getRow(i-2);
      textAlign(RIGHT);
      
      println(nRow.getString("task"));
      

      text(floor((nRow.getInt("time"))/60), 880, yPos+ tg*ig);
      text(" :", 895, yPos + tg*ig);
      textAlign(LEFT);
      text(nf((nRow.getInt("time"))%60,2), 900, yPos+ tg*ig);
            //next line for debug only
      text(nRow.getString("task"), 1000, yPos + tg*ig);
      ig++;
 } 
 
}

public void makeFonts() {

  timeFontSmall = createFont("BlackBoard.ttf", 36, true);
  textFont(timeFontSmall);
  timeFontMedium = createFont("BlackBoard.ttf", 72, true);
  textFont(timeFontMedium);
  timeFontLarge = createFont("BlackBoard.ttf", 120, true);
  textFont(timeFontLarge);
}
public void setupTable() {
  try { 
    resultTable = loadTable(tablePath, "header");
     lastSession = 0;
      numberRows = resultTable.getRowCount();
  if (numberRows < 2) {
    sessionString = nf(0,1);
  }
  else {
    sessionString = nf(resultTable.getInt(numberRows - 1, "session"),1);
    println(lastSession);
  }
  }
  catch (Exception e) {
    tableExists = false;
  }
  if (tableExists == false) {
    resultTable = new Table();
    resultTable.addColumn("date");
    resultTable.addColumn("task");
    resultTable.addColumn("time");    
    resultTable.addColumn("session");
    resultTable.addColumn("id");
  }
}

public void writeData() {
  println("we are in writeDate();"); 

  lastSession = 0;
  numberRows = resultTable.getRowCount();
  if (numberRows < 2) {
    lastSession = 0;
  }
  else {
    lastSession = resultTable.getInt(numberRows - 1, "session");
  }

  for (int i = 0; i< screenCount; i++) {       
    TableRow newRow = resultTable.addRow();
    newRow.setInt("date", PApplet.parseInt(nf(year(), 4) + nf(month(), 2) + nf(day(), 2)));
    newRow.setString("task", resultNames[i]);
    newRow.setFloat("time", task[i].secondsTaken);
    newRow.setInt("session", lastSession + 1);
    newRow.setInt("id", resultTable.getRowCount() + 1);
  }  
  saveTable(resultTable, tablePath);
}

  public int sketchWidth() { return 1280; }
  public int sketchHeight() { return 768; }
}
