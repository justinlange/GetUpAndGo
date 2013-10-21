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


String cardOneURL = "http://pokegym.net/gallery/displayimage.php?imageid=51910";
String cardTwoURL = "http://pokegym.net/gallery/displayimage.php?imageid=51910";
String cardThreeURL = "third";

import android.content.Intent;
String subject = "Test from your Android device!";
String emailBody = "This is an email, sent from your Android device. Congrats!";
String tablePath = "/sdcard/results.csv";

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
  "wakingzzz", "making bed", "showering", "dressing", "cooking", "eating", "doing dishes", "packing", "final checks", "Now go!"
};

int[] durationTimes = {
  1, 2, 10, 3, 8, 5, 3, 4, 2, 1
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


void mouseReleased() {
  
    submitVote("working");

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


boolean buttonCheck(int x, int y, int w, int h) { 
  
  if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) return true;
  return false;
 
}

void sendEmail() {
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

private void submitVote(String outcome) {
    HttpClient client = new DefaultHttpClient();
    HttpPost post = new HttpPost("https://docs.google.com/spreadsheet/formResponse?formkey=dEM0UlRxNGJSTzVJa25lRHlCeWlJSmc6MA");

    List<BasicNameValuePair> results = new ArrayList<BasicNameValuePair>();
    results.add(new BasicNameValuePair("entry.0.single", cardOneURL));
    results.add(new BasicNameValuePair("entry.1.single", outcome));
    results.add(new BasicNameValuePair("entry.2.single", cardTwoURL));
    results.add(new BasicNameValuePair("entry.3.single", cardThreeURL));


    try {
        post.setEntity(new UrlEncodedFormEntity(results));
    } catch (UnsupportedEncodingException e) {
        // Auto-generated catch block
        Log.e("YOUR_TAG", "An error has occurred", e);
    }
    try {
        client.execute(post);
    } catch (ClientProtocolException e) {
        // Auto-generated catch block
        Log.e("YOUR_TAG", "client protocol exception", e);
    } catch (IOException e) {
        // Auto-generated catch block
        Log.e("YOUR_TAG", "io exception", e);
    }
}




