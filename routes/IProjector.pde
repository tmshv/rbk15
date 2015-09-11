interface IProjector {
  PVector project(LatLon latlon);
  LatLon unproject(PVector point);
  PVector[] bounds();
  void setScale(float scale);
  float getScale();
}
