

//get up & go!

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

float targetExitMinutes;

int screenCount;
int currentScreen = 0;
String[] pictureNames = {
  "splash", "bed", "shower", "dress", "cook", "eat", "clean", "pack", "check", "exit"
};
String [] actionNames = {
"wakingzzz", "Make Bed", "Shower!", "dress", "Cook ur Yums", "Eat", "Do Dishes", "Pack ur bag!", "Check stove & lights", "Now go!"
};

String [] resultNames = {
"wakingzzz", "making bed", "showering", "dressing", "cooking", "eating", "doing dieshes", "packing", "final checks", "Now go!"
};

int[] durationTimes = {2,4,1,5,7,8,4,5,2,1};

Table resultTable;

int mWidth = 1280;
int mHeight =768;

void setup() {
  size(mWidth, mHeight); 
  
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
 
  //input handled by mousePressed()
 
  task[currentScreen].update();  
  task[currentScreen].draw();
  
  if(resultsPage) drawResults();
}


void startTime(){
    if(!resetBool) {
        resetBool = true;
        millisEllapsedBeforeStart = millis();
   } 
   for(int i=0; i<durationTimes.length; i++){
    targetExitMinutes+=durationTimes[i]; 
   }
}

void allocateRemainingTime(){
  
 float remainingStoredTime = 0;
 float weightedTimeValue = 0;
 float secondsEllapsed = timeEllapsed / 1000;
 float secondsRemaining = (targetExitMinutes*60) - secondsEllapsed; 
 
 
 for(int i = currentScreen; i < durationTimes.length; i++){
    remainingStoredTime += task[i].durationMinutes;
    }
    
 for(int i = currentScreen + 1; i < durationTimes.length; i++){
      print(pictureNames[i] + "  " + task[i].durationMinutes + "   ");
      task[i].durationMinutes= (task[i].durationMinutes/remainingStoredTime) * targetExitMinutes; 
    } 
}

void sanityCheck(){
   if (actionNames.length != pictureNames.length || pictureNames.length != durationTimes.length) {
    println("need same length data arrays!");
  exit();
  } 
}

void makeFonts(){
  
  timeFontSmall = createFont("BlackBoard.ttf", 36, true);
  textFont(timeFontSmall);
  timeFontMedium = createFont("BlackBoard.ttf", 72, true);
  textFont(timeFontMedium);
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

void drawResults(){
  int yPos = 150;
  
  fill(150,100);
  noStroke();
  rect(0,100,width, height-200);
  fill(50);
  textAlign(LEFT);
  textFont(timeFontSmall); 
  for(int i = 0; i< screenCount; i++){ 
    text(resultNames[i], 100, yPos + i*50);
    text(task[i].timeString, 700, yPos + i*50);
  } 
}

void setupTable(){
  resultTable = loadTable("results.csv", "header");  
}
  
void writeData(){
  println("we are in writeDate();"); 
  
  
  int lastSession = 0;
  int numberRows = resultTable.getRowCount();
  if(numberRows < 2){
     lastSession = 0;
  }else{
   lastSession = resultTable.getInt(numberRows - 1, "session");
  }
 
    for(int i = 0; i< screenCount; i++){       
      TableRow newRow = resultTable.addRow();
      newRow.setInt("date", int(nf(year(),4) + nf(month(), 2) + nf(day(), 2)));
      newRow.setString("task", resultNames[i]);
      newRow.setFloat("time", task[i].mSecondsLeft);
      newRow.setInt("session", lastSession + 1);
  }  
      saveTable(resultTable, "results.csv");
}

void mouseReleased(){

  if(resultsPage) exit();
  if (currentScreen < screenCount - 1) {
       task[currentScreen].writeTime(); 
       allocateRemainingTime();       
       currentScreen++;
    }else{
      resultsPage = true;
      if(!resultsWritten) writeData();
      resultsWritten = true;

    }
  
}



