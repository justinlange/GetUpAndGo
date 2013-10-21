void mouseReleased() {
  
  if(buttonCheck(264,600,396,100)){
   println("button 1 works!"); 
   splashPage = false;
   }
   
   if(buttonCheck(677,580,345,100)){
     println("button 2 works!"); 
   }
   
    if(!splashPage){ 

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
}


boolean buttonCheck(int x, int y, int w, int h) { 
  println("x: " + mouseX + "  y: " + mouseY);
  
  if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
    return true;
  }
  
  return false;
 
}
