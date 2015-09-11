//EPSG:4326 CRS
class SimpleProjector implements IProjector{
  Transform t;
  public SimpleProjector(){
    t = new Transform(1 / 180, 1, -1 / 180, 0.5);
  }
  
  PVector project(LatLon latlon) {
    return t.transform(new PVector(latlon.lon, latlon.lat), 1);
  }

  LatLon unproject(PVector point) {
    return new LatLon(point.y, point.x);
  }
  
  PVector[] bounds(){
    return null;
  }
  
  void setScale(float scale){
    
  }
  
  float getScale(){
    return 1;
  }
};
