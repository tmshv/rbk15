//EPSG:3857 CRS
class SphericalMercator implements IProjector{
  float R = 6378137;
  float MAX_LATITUDE = 85.0511287798;
  Transform t;
  
  float scale = 1;

  public SphericalMercator(){
    //float s = 0.5 / (PI * this.R);
    //this.t = new Transform(s, 0.5, -s, 0.5);
    this.t = new Transform(1, 0, -1, 0);
  }

  PVector project(LatLon latlon) {
    float d = PI / 180;
    float max = this.MAX_LATITUDE;
    float lat = max(min(max, latlon.lat), -max);
    float sin = sin(lat * d);

    return t.transform(new PVector(
      this.R * latlon.lon * d,
      this.R * log((1 + sin) / (1 - sin)) / 2
    ), this.scale);
  }

  LatLon unproject(PVector point) {
    float d = 180 / PI;
    
    point = t.untransform(point.get(), this.scale);
    return new LatLon(
      (2 * atan(exp(point.y / this.R)) - (PI / 2)) * d,
      point.x * d / this.R
    );
  }
  
  PVector[] bounds(){
    float d = this.R * PI;
    PVector[] b = new PVector[2];
    b[0] = new PVector(-d, -d);
    b[1] = new PVector(d, d);
    return b;
  }
  
  void setScale(float scale){
    this.scale = scale;
  }
  
  float getScale(){
    return this.scale;
  }
}