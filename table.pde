void setupTable() {
  try { 
    resultTable = loadTable("results.csv", "header");
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

void writeData() {
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
    newRow.setInt("date", int(nf(year(), 4) + nf(month(), 2) + nf(day(), 2)));
    newRow.setString("task", resultNames[i]);
    newRow.setFloat("time", task[i].mSecondsLeft);
    newRow.setInt("session", lastSession + 1);
    newRow.setInt("id", resultTable.getRowCount() + 1);
  }  
  saveTable(resultTable, "results.csv");
}
