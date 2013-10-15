//get up & go!

Task[] task;
PFont timeFontSmall;
PFont timeFontLarge;



int screenCount = 9;
int currentScreen = 0;
String[] pictureNames = {
  "splash", "bed", "shower", "cook", "eat", "clean", "pack", "check", "exit"
};
String [] actionNames = {"null", "Make Bed", "Shower!", "Cook ur Yums", "Eat", "Do Dishes", "Pack ur bag!", "Check stove & lights", "Now go!"};


void setup() {
  size(1280, 768);
  
  timeFontSmall = createFont("BlackBoard.ttf", 72, true);
  textFont(timeFontSmall);
  timeFontLarge = createFont("BlackBoard.ttf", 120, true);
  textFont(timeFontLarge);

  task = new Task[screenCount];

  //create new screens
  for (int i = 0; i < screenCount; i++ ) {
    task[i] = new Task(i, pictureNames[i], actionNames[i], 90);
  }
}

void draw() {
  background(255);

  checkInput(); 
  
  task[currentScreen].update();  
  task[currentScreen].draw();
}

void checkInput() {

  if (mousePressed) {
    delay(100);
    if (currentScreen < screenCount-1) {
       task[currentScreen].writeTime();  
       currentScreen++;
    }else{
      writeData();
      exit();
    }
  }
}

void writeData(){
  
  
}

