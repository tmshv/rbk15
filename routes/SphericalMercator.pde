//EPSG:3857 CRS
class SphericalMercator {
  float R = 6378137;
  float MAX_LATITUDE = 85.0511287798;

  PVector project(LatLon latlon) {
    float d = PI / 180;
    float max = this.MAX_LATITUDE;
    float lat = max(min(max, latlon.lat), -max);
    float sin = sin(lat * d);

    return new PVector(
      this.R * latlon.lon * d,
      this.R * log((1 + sin) / (1 - sin)) / 2
    );
  }

  LatLon unproject(PVector point) {
    float d = 180 / PI;

    return new LatLon(
      (2 * atan(exp(point.y / this.R)) - (PI / 2)) * d,
      point.x * d / this.R);
    }
};
