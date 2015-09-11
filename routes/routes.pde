City city;
Camera camera;
GeoJSON geo;
SphericalMercator sm = new SphericalMercator();
IProjector proj = sm;
LatLon center;

PVector view = new PVector();

void setup() {
  size(1200, 700);
  
  geo = new GeoJSON("../railway_features.geojson");
  city = new City(geo, proj);
  city.addVehicle(10);
  
  camera = new Camera(proj);
  center = getCenter(geo);  
//  camera.setView(proj.project(center));
    
  ArrayList<Feature> streets = geo.getFeatures();
  
  sm.scale = 0.02;
//  sm.scale = 1;
  
//  camera.lookAt(center);
//  camera.lookAt(streets.get(100).geometry.coords.get(0));
//  camera.lookAt(view);

  camera.follow(city.vehicles.get(0).location);
}

void draw() {
  background(0);
  noFill();
  
  ArrayList<Feature> streets = geo.getFeatures();

//  camera.setView(proj.project(center));
//  setView(streets.get(100).geometry.coords.get(0));

  pushMatrix();
  translate(width/2, height/2);

  camera.update();
  city.update();
  
  for (Feature f : streets) {
    stroke(100);
    strokeWeight(1);
    noFill();
    beginShape();
    for(LatLon ll : f.geometry.coords){
      PVector xy = proj.project(ll);
      //println(xy);
      vertex(xy.x, xy.y);
    }
    endShape();
  }
  
  ellipseMode(CENTER);
  
  noStroke();
  fill(0, 200, 0);
  PVector c = proj.project(center);
  ellipse(c.x, c.y, 10, 10);
  
  //for (Crossroad cr : city.crossroads) {
  //  stroke(255);
  //  noFill();
   
  //  PVector xy = proj.project(cr.coord);
  //  ellipse(xy.x, xy.y, 4, 4);
  //}

  for (Vehicle vehicle : city.vehicles) {
   vehicle.size = 5;
   vehicle.draw();
  }

  popMatrix();

  text(city.vehicles.size(), 5, 10);
//  text(camera.lon, 5, 25);
  //text(camera.zoom, 5, 40);
//  text(sm.scale, 5, 40);
}

void setView(LatLon coord){
  PVector c = proj.project(coord);
  view.x = c.x;
  view.y = c.y;
}

LatLon getCenter(IFeatureCollection fc){
  LatLon[] bound = fc.bounds();
  return new LatLon(
    (bound[0].lat + bound[1].lat) / 2,
    (bound[0].lon + bound[1].lon) / 2
  );
}

void keyPressed() {
  //float step = map(camera.zoom, 0, 1, 100, 10);
  float step = .0009;
  float z = .1;
  if (keyCode == UP) camera.moveTarget(-step, 0);
  if (keyCode == DOWN) camera.moveTarget(step, 0);
  if (keyCode == LEFT) camera.moveTarget(0, -step);
  if (keyCode == RIGHT) camera.moveTarget(0, step);

  if (key == '1') {
    camera.zoomOut(z);
  }

  if (key == '2') {
    camera.zoomIn(z);
  }
}
