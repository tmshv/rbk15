class LatLon {
  float lat;
  float lon;
  
  public LatLon(){
    this(0.0, 0.0);
  }
  
  public LatLon(float lat, float lon){
    this.lat = lat;
    this.lon = lon;
  }
  
  public void setLatLon(LatLon ll){
    this.lat = ll.lat;
    this.lon = ll.lon;
  }
  
  public LatLon add(float lat, float lon){
    this.lat += lat;
    this.lon += lon;
    return this;
  }
    
  public LatLon add(LatLon ll){
    return this.add(ll.lat, ll.lon);
  }
  
  public LatLon sub(float lat, float lon){
    this.lat -= lat;
    this.lon -= lon;
    return this;
  }
  
  public LatLon sub(LatLon ll){
    return this.sub(ll.lat, ll.lon);
  }
  
  public float dist(LatLon ll) {
    float R = 6378137;
    
    float dLat = radians(ll.lat - this.lat);
    float dLon = radians(ll.lon - this.lon);
    float lat1 = radians(this.lat);
    float lat2 = radians(ll.lat);
    
    float a = pow(sin(dLat / 2),2) + pow(sin(dLon / 2),2) * cos(lat1) * cos(lat2);
    float c = 2 * asin(sqrt(a));
    return R * c;
  }
  
  boolean isEqual(LatLon ll){
    return this.lat == ll.lat && this.lon == ll.lon;
  }
  
  LatLon clone(){
    return new LatLon(this.lat, this.lon);
  }
  
  String toString(){
    return str(this.lat) + " " + str(this.lon);
  }
  
  PVector toPVector(){
    return new PVector(this.lat, this.lon);
  }
}