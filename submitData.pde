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

    
    //print("entryString: " + entryString + "  timeString: " + timeString + "pictureNames: " + pictureNames[i]);
    //println("i: " + i + "  task[i].secondsTaken: " + task[i].secondsTaken);
   
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
