void allocateRemainingTime() {

  float remainingStoredTime = 0;
  float weightedTimeValue = 0;
  float secondsEllapsed = timeEllapsed / 1000;
  float secondsRemaining = (targetExitMinutes*60) - secondsEllapsed; 


  for (int i = currentScreen; i < durationTimes.length; i++) {
    remainingStoredTime += task[i].durationMinutes;
  }



  for (int i = currentScreen + 1; i < durationTimes.length; i++) {
    weightedTimeValue = task[i].originalDurationMinutes/targetExitMinutes;
    
    //print(pictureNames[i] + "  " + task[i].durationMinutes + "   ");
    task[i].durationMinutes= remainingStoredTime * weightedTimeValue;
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

void getTime() {
  timeEllapsed = millis() - millisEllapsedBeforeStart;
}
