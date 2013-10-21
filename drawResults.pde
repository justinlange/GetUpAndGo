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
