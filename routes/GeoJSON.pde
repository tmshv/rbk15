class GeoJSON implements IFeatureCollection{
  ArrayList<Feature> features = new ArrayList<Feature>();

  public GeoJSON(String filepath) {
    this.loadFeatures(loadJSONObject(filepath)
      .getJSONArray("features")
    );
  }
  
  public ArrayList<Feature> getFeatures(){
    return this.features;
  }

  private void loadFeatures(JSONArray features) {
    for (int i = 0; i < features.size(); i ++) {
      JSONObject f = features.getJSONObject(i);
      
      this.features.add(new Feature(f));
    }
  }
}
