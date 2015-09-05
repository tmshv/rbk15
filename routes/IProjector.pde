interface IProjector {
  PVector project(LatLon latlon);
  LatLon unproject(PVector point);
}
