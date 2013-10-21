private void submitData(String outcome) {
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
