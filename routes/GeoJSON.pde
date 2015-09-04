class GeoJSON {
  ArrayList<Feature> features = new ArrayList<Feature>();

  public GeoJSON(String filepath) {
    this.getFeatures(loadJSONObject(filepath)
      .getJSONArray("features")
    );
  }

  private void getFeatures(JSONArray features) {
    for (int i = 0; i < features.size(); i ++) {
      JSONObject f = features.getJSONObject(i);
      
      this.features.add(new Feature(f));
    }
  }
}