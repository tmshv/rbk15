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
  background(0);
  
  geo = new GeoJSON(path);
  city = new City(geo, proj);
  city.addVehicle(city.trafficLimit);
  center = city.getCenter();
  
  camera = new Camera(proj, new PVector(width/2, height/2));  
  camera.lookAt(center);
}

void draw() {
  background(0);
  //noStroke();
  //fill(0, 20);
  //rect(0, 0, width, height);
    
  LatLon mouse = camera.getCoordAtScreen(mouseX, mouseY);
  
  pushMatrix();
  proj.scale = map(camera.getZoom(), 1, 10, 0.02, .1);
  camera.update();
  city.update();  
  //city.drawStreets();
  
  //fill(0);
  //stroke(0, 200, 0);
  //PVector c = proj.project(center);
  //ellipseMode(CENTER);
  //ellipse(c.x, c.y, 6, 6);
  
  for (Vehicle vehicle : city.vehicles) {
   vehicle.size = 5;
   vehicle.draw();
  }
  
  //DRAW GPAPH
  //drawGraphNodes(city.graph.getNodeArray());
  //drawGraphEdges(city.graph.getAllEdgeArray());
  
  popMatrix();
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

void keyPressed() {
  //float step = map(camera.zoom, 0, 1, 100, 10);
  float step = .0009;
  if (keyCode == UP) camera.moveTarget(step, 0);
  if (keyCode == DOWN) camera.moveTarget(-step, 0);
  if (keyCode == LEFT) camera.moveTarget(0, -step);
  if (keyCode == RIGHT) camera.moveTarget(0, step);

  if (key == '-') camera.zoomOut();
  if (key == '=') camera.zoomIn();
  if (key == '0') camera.lookAt(center);  
  if (key == ' ') saveFrame("rbk-foresight_###.jpg");
}