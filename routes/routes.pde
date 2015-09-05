City city;
Camera camera;

IProjector proj = new SphericalMercator();

void setup() {
  size(800, 600);
  
  GeoJSON geo = new GeoJSON("../features.geojson");
  city = new City(geo, proj);  
  
  camera = new Camera();
  camera.zoom = .01;
  camera.setView(proj.project(city.vehicles.get(0).location));
}

void draw() {
  background(204);
  noFill();

//  camera.setView(proj.project(city.vehicles.get(0).location));

  pushMatrix();
  translate(width/2, height/2);
  camera.applyMatrix();

  city.update();

  ArrayList<Feature> streets = city.fc.getFeatures();
  for (Feature f : streets) {
    stroke(0);
    noFill();
    beginShape();
    for(LatLon ll : f.geometry.coords){
      PVector xy = proj.project(ll);
      vertex(xy.x, xy.y);
    }
    endShape();
  }
  
  ellipseMode(CENTER);
  for (Crossroad cr : city.crossroads) {
    stroke(255);
    noFill();
   
    PVector xy = proj.project(cr.coord);
    ellipse(xy.x, xy.y, 4, 4);
  }

  for (Vehicle vehicle : city.vehicles) {
    vehicle.size = 10 / camera.zoom;
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
    camera.y -= step;
  }

  if (keyCode == DOWN) {
    camera.y += step;
  }

  if (keyCode == LEFT) {
    camera.x -= step;
  }

  if (keyCode == RIGHT) {
    camera.x += step;
  }

  if (key == '1') {
    camera.zoomOut();
  }

  if (key == '2') {
    camera.zoomIn();
  }
}
