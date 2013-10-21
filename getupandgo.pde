//import android.view.inputmethod.InputMethodManager;
//import android.content.Context;

//import java.lang.Iterable;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URL;

import java.util.ArrayList;
import java.util.List;


import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;


import android.os.AsyncTask;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;

//import android.content.Intent;
//Intent email;


int lastSession;
int numberRows;
String sessionString;
String tablePath = "/sdcard/results.csv";

Task[] task;

PFont timeFontSmall;
PFont timeFontMedium;
PFont timeFontLarge;

int counter = 0;
int millisEllapsedBeforeStart;
int timeEllapsed;

boolean splashPage = true;
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

String[] replacementImages = { 
  " ", " ", " ", " ", "foodlater", "tupperware", " ", " ", " ", " ", " " };

String[] replacementActions = {
"","","","", "No time to cook!", "Take food 2 go", "", "", "", ""};
 
String [] actionNames = {
  "wakingzzz", "Make Bed", "Shower!", "dress", "Cook ur Yums", "Eat", "Do Dishes", "Pack ur bag!", "Check stove", "Now go!"
};

String [] resultNames = {
  "Waking up:", "Making bed:", "Showering:", "Dressing:", "Cooking:", "Eating:", "Doing dishes:", "Packing:", "Final checks:", "Walking out..."
};

/*
int[] durationTimes = {
  1, 2, 10, 4, 8, 6, 3, 4, 2, 1
};
*/
//debug times
float[] durationTimes = {
  .03, .03, .03, .01, .05, .05, .01, .01, .02, .03
};

Table resultTable;

int mWidth = 1280;
int mHeight =768;



void setup() {
  size(1280, 768);
  
  setupTable();
  startTime();
  makeFonts();
  makeObjects();

  println("target Exit Minutes: " + targetExitMinutes);
}



void draw() {

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


void makeObjects() { 
  screenCount = pictureNames.length;
  task = new Task[screenCount];
  for (int i = 0; i < screenCount; i++ ) {
    task[i] = new Task(i, pictureNames[i], actionNames[i], durationTimes[i]);
  }
task[0].drawType = false;
task[4].canSkip = true;
task[5].canSkip = true;

}







