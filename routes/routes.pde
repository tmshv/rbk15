ArrayList<Street> streets = new ArrayList<Street>();
ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
Camera camera = new Camera();

void setup() {
  size(500, 500);
  SphericalMercator proj = new SphericalMercator();

  JSONArray features = loadJSONObject("../features.geojson")
    .getJSONArray("features");

  for (int f = 0; f < features.size(); f ++) {
    JSONArray geo_coords = features
      .getJSONObject(f)
      .getJSONObject("geometry")
      .getJSONArray("coordinates");

    ArrayList<LatLon> coords = new ArrayList<LatLon>();
    for (int i = 0; i < geo_coords.size(); i ++) {
      JSONArray g = geo_coords.getJSONArray(i);
      LatLon c = new LatLon(g.getFloat(0), g.getFloat(1));
      coords.add(c);
    }

    ArrayList<PVector> street_coords = new ArrayList<PVector>();
    for (LatLon ll : coords) {
      PVector xy = proj.project(ll);
      street_coords.add(xy);
    }

    streets.add(new Street(street_coords));
  }

  for (Street street : streets) {
    Vehicle v = new Vehicle();
    v.drive(street);
    vehicles.add(v);
  }

  camera.zoom = .5;
  camera.setView(6670954, 3552487);

  //TEST
  //  camera.zoom = 1;
  //  camera.setView(0, 0);
  //  
  //  ArrayList<PVector> street_coords = new ArrayList<PVector>();
  //  street_coords.add(new PVector(0, 0));
  //  street_coords.add(new PVector(200, 200));
  //  street_coords.add(new PVector(240, 100));
  //  street_coords.add(new PVector(40, 10));
  //  Street demoStreet = new Street(street_coords);
  //  streets.add(demoStreet);
  //  
  //  Vehicle v = new Vehicle(10);
  //  v.drive(demoStreet);
  //  vehicles.add(v);
}

void draw() {
  background(204);
  noFill();

  pushMatrix();
  translate(width/2, height/2);
  camera.applyMatrix();

  for (Street street : streets) {
    street.draw();
  }

  for (Vehicle vehicle : vehicles) {
    vehicle.step();
    vehicle.draw();
  }

  popMatrix();

  text(camera.x, 5, 10);
  text(camera.y, 5, 25);
  text(camera.zoom, 5, 40);
}

void keyPressed() {
  float step = map(camera.zoom, 0, 1, 100, 10);
  if (keyCode == UP) {
    camera.y += step;
  }

  if (keyCode == DOWN) {
    camera.y -= step;
  }

  if (keyCode == LEFT) {
    camera.x += step;
  }

  if (keyCode == RIGHT) {
    camera.x -= step;
  }

  if (key == '1') {
    camera.zoomOut();
  }

  if (key == '2') {
    camera.zoomIn();
  }
}