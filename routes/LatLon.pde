class LatLon {
  float lat;
  float lon;
  
  public LatLon(float lat, float lon){
    this.lat = lat;
    this.lon = lon;
  }
  
  String toString(){
    return str(this.lat) + " " + str(this.lon);
  }
}
