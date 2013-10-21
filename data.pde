void setupTable() {
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
    newRow.setFloat("time", task[i].secondsTaken);
    newRow.setInt("session", lastSession + 1);
    newRow.setInt("id", resultTable.getRowCount() + 1);
  }  
  saveTable(resultTable, tablePath);
  submitData(pictureNames);
}


String entryString;
String timeString;
int entryStart = 19;

private void submitData(String[] outcome) {
    HttpClient client = new DefaultHttpClient();
    HttpPost post = new HttpPost("https://docs.google.com/spreadsheet/formResponse?formkey=dEM0UlRxNGJSTzVJa25lRHlCeWlJSmc6MA");

    List<BasicNameValuePair> results = new ArrayList<BasicNameValuePair>();
    
    for (int i = 0; i < screenCount; i ++){
      
    entryString = "entry." + int(i + entryStart) + ".single"; 
    timeString = nf(task[i].secondsTaken, 2);
    results.add(new BasicNameValuePair(entryString, timeString));

    
    print("entryString: " + entryString + "  timeString: " + timeString + "pictureNames: " + pictureNames[i]);
    println("i: " + i + "  task[i].secondsTaken: " + task[i].secondsTaken);
   
    }


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
