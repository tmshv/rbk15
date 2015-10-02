class Geometry extends LatLonPath{
  public String type;
  
  public Geometry(ArrayList<LatLon> coords){
    super(coords);
    this.type = "Polygon";
  }
  
  public Geometry(JSONObject geometry){
    this(new ArrayList<LatLon>());
    this.type = geometry.getString("type");
    
    JSONArray geo_coords = geometry.getJSONArray("coordinates");
    for (int i = 0; i < geo_coords.size(); i ++) {
      JSONArray g = geo_coords.getJSONArray(i);
      float lat = g.getFloat(1);
      float lon = g.getFloat(0);
      this.coords.add(new LatLon(lat, lon));
    }
  }
  
  LatLon first(){
    return this.coords.get(0);
  }
  
  LatLon last(){
    return this.coords.get(this.coords.size() - 1);
  }

  Geometry clone(){
    return new Geometry(super.clone().coords);
  }
}