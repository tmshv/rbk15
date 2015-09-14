City city;
Camera camera;
GeoJSON geo;
SphericalMercator proj = new SphericalMercator();
LatLon center;

PVector view = new PVector();

//String path = "../railway_features.geojson";
//String path = "../features.geojson";
String path = "../streets.geojson";

void setup() {
  size(1200, 700);
  smooth();
  
  geo = new GeoJSON(path);
  city = new City(geo, proj);
  city.addVehicle(200);
  
  camera = new Camera(proj, new PVector(width/2, height/2));
  center = getCenter(geo);  
//  camera.setView(proj.project(center));
    
  ArrayList<Feature> streets = geo.getFeatures();
  
  proj.scale = 0.02;
//  sm.scale = 1;
  
 camera.lookAt(center);
//  camera.lookAt(streets.get(100).geometry.coords.get(0));
//  camera.lookAt(view);

  //camera.follow(city.vehicles.get(0).location);
}

void draw() {
  //background(0);
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  
  noFill();
  LatLon mouse = camera.getCoordAtScreen(mouseX, mouseY);
  
  ArrayList<Feature> streets = geo.getFeatures();

  pushMatrix();
  camera.update();
  city.update();
  
  //for (Feature f : streets) {
  //stroke(100);
  //strokeWeight(1);
  //noFill();
  //beginShape();
  //for(LatLon ll : f.geometry.coords){
  //  PVector xy = proj.project(ll);
  //  vertex(xy.x, xy.y);
  //}
  //endShape();
  //}
  
  ellipseMode(CENTER);
  
  fill(0);
  stroke(0, 200, 0);
  PVector c = proj.project(center);
  ellipse(c.x, c.y, 6, 6);
  
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
  
  //DRAW GPAPH
  //drawGraphNodes(city.graph.getNodeArray());
  //drawGraphEdges(city.graph.getAllEdgeArray());
  
  popMatrix();  
  
  //text(mouse.lat, 5, 25);
  //text(mouse.lon, 5, 40);
}

void drawGraphNodes(GraphNode[] nodes){
  pushStyle();
  noStroke();
  fill(255);
  float s = 5;
  for(GraphNode node : nodes){
    PVector p = proj.project(new LatLon(node.xf(), node.yf()));
    ellipse(p.x, p.y, s, s);
  }
  popStyle();
}

void drawGraphEdges(GraphEdge[] edges){
  pushStyle();
  noFill();
  stroke(200);
  for(GraphEdge ge : edges){
    PVector p1 = proj.project(new LatLon(ge.from().xf(), ge.from().yf()));
    PVector p2 = proj.project(new LatLon(ge.to().xf(), ge.to().yf()));
    line(p1.x, p1.y, p2.x, p2.y);
  } 
  popStyle();
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
  if (keyCode == UP) camera.moveTarget(step, 0);
  if (keyCode == DOWN) camera.moveTarget(-step, 0);
  if (keyCode == LEFT) camera.moveTarget(0, -step);
  if (keyCode == RIGHT) camera.moveTarget(0, step);

  if (key == '1') {
    camera.zoomOut(z);
  }

  if (key == '2') {
    camera.zoomIn(z);
  }
}