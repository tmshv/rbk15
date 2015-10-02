City city;
Camera camera;
GeoJSON geo;
SphericalMercator proj = new SphericalMercator();
LatLon center;

PVector view = new PVector();

Crossroad crStart = null;
Crossroad crFinish = null;
Driver defaultDriver;
Road nearestRoad;

// String path = "../railway_features.geojson";
// String path = "../features.geojson";
// String path = "../streets.geojson";
String path = "../osm_sample.geojson";
// String path = "../osm_single_cr.geojson";

boolean drawRoads = false;
boolean drawAgents = false;
boolean drawCrossroads = false;
boolean drawNodes = true;
boolean drawEdges = true;
boolean drawGraphRoute = true;
boolean drawGraphMode = true;

void setup() {
  fullScreen();
  smooth();
  background(0);

  geo = new GeoJSON(path);
  FeatureExploder fx = new FeatureExploder(geo);
  FeatureOptimizer fo = new FeatureOptimizer(fx);

  city = new City(fo, proj);
  center = city.getCenter();
  
  camera = new Camera(proj, new PVector(width/2, height/2));
  camera.lookAt(center);
  
  defaultDriver = new Driver(city, 2);
}

void draw() {
  background(0);
  //noStroke();
  //fill(0, 20);
  //rect(0, 0, width, height);

  LatLon mouse = camera.getCoordAtScreen(mouseX, mouseY);
  Crossroad n = city.findNearestCrossroadTo(mouse);
  nearestRoad = city.findNearestRoadTo(mouse);

  // Route route = null;
  GraphNode[] route = null;
  if(drawGraphRoute && crFinish != null){
    int nearestCrossroadId = city.getCrossroadIndex(n);
    int finishCrossroadId = city.getCrossroadIndex(crFinish);
    route = defaultDriver.findRoute(nearestCrossroadId, finishCrossroadId);
  }
  
  if(mousePressed){
  if(mouseButton == LEFT)  crStart  = n; //<>//
    if(mouseButton == RIGHT) crFinish = n;
    
    if(crStart != null && crFinish != null){
      createAgent()
        .navigate(crStart, crFinish);
    }
  }
  
  pushMatrix();
  proj.scale = map(camera.getZoom(), 1, 10, 0.02, .3);
  camera.update();
  city.update();  
  
  // stroke(255);
  // noFill();
  // PVector pmouse = proj.project(mouse);
  // ellipseMode(CENTER);
  // ellipse(pmouse.x, pmouse.y, 10, 10);

  if (drawNodes) drawGraphNodes(city.graph.getNodeArray());
  if (drawEdges) drawGraphEdges(city.graph.getAllEdgeArray());
  if (drawRoads) city.drawRoads(nearestRoad);
  if (drawCrossroads) city.drawCrossroads();
  if (drawAgents) city.drawVehicles();
  
  // drawEdgeProj(nearestRoad, mouse);

  int routelength = 0;
  if(route != null){
    if(drawGraphMode) drawGraphRoute(route);
    else drawRoute(new Route(city, route));
  }
  
  if(crStart != null && crFinish != null){
    noFill();
    stroke(0, 0, 255);
    ellipseMode(CENTER);
    PVector c;
    c = proj.project(crStart.coord);
    ellipse(c.x, c.y, 5, 5);  
  
    c = proj.project(crFinish.coord);
    ellipse(c.x, c.y, 10, 10);
  }
  
  popMatrix();
  
  fill(255);
  text(routelength, 5, 10);
  if(crFinish != null){
    text(crFinish.roads.size(), 5, 25);
  }
}

void drawGraphRoute(GraphNode[] route){
  pushStyle();
  
  for(int i=0; i<route.length-1; i++){
    GraphNode n1 = route[i];
    GraphNode n2 = route[i + 1];

    PVector p1 = proj.project(city.getGraphNodeCoord(n1));
    PVector p2 = proj.project(city.getGraphNodeCoord(n2));
    
    noFill();
    stroke(#aa0000);
    strokeWeight(2);
    line(p1.x, p1.y, p2.x, p2.y);
    
    pushMatrix();
    PVector diff = PVector.sub(p2, p1);
    float a = atan2(diff.y, diff.x);
    translate(p2.x, p2.y);
    rotate(a - HALF_PI);
    
    float s = 9;
    float sr = 3;
    strokeWeight(1);
    fill(#aa0000);
    triangle(-s/sr, -s, s/sr, -s, 0, 0);
    
    popMatrix();
  }
  popStyle();
}

void drawRoute(Route route){
  pushStyle();
  ArrayList<LatLon> coords = route.bake();

  for(int i=0; i<coords.size()-1; i++){
    PVector p1 = proj.project(coords.get(i));
    PVector p2 = proj.project(coords.get(i + 1));
    
    noFill();
    stroke(#00ff00);
    strokeWeight(1);
    line(p1.x, p1.y, p2.x, p2.y);
    
    pushMatrix();
    PVector diff = PVector.sub(p2, p1);
    float a = atan2(diff.y, diff.x);
    translate(p2.x, p2.y);
    rotate(a - HALF_PI);
    
    float s = 9;
    float sr = 3;
    strokeWeight(1);
    fill(#00ff00);
    triangle(-s/sr, -s, s/sr, -s, 0, 0);
    
    popMatrix();
  }
  popStyle();
}

void drawEdgeProj(GraphEdge ge, LatLon ll){
  if(ge == null) return;

  PVector v = proj.project(ll);

  LatLon fromCoord = city.getGraphNodeCoord(ge.from());
  LatLon toCoord = city.getGraphNodeCoord(ge.to());

  PVector p1 = proj.project(fromCoord);
  PVector p2 = proj.project(toCoord);
      
  PVector p = GeometryUtils.projectVertexOnLine(v, p1, p2);

  stroke(#ff0000);
  fill(#990000);
  ellipseMode(CENTER);
  ellipse(p.x, p.y, 5, 5); 
}

Driver createAgent(){
    // Vehicle v = new Vehicle(.00025+random(0.00010), proj);    
    Vehicle v = new Vehicle(.00001, proj);    
    city.addVehicle(v);
    
    Driver driver = new Driver(city, 2);
    driver.drive(v);
    return driver;
}

void deleteSelectedEdge(){
  if(nearestRoad != null){
    GraphEdge e = nearestRoad.edge;
    city.graph.removeEdge(e.from().id(), e.to().id());
  }
}

void bakeGraph(){
  String dump = GraphUtils.bake(city.graph);
  println(dump);
}

void drawGraphNodes(GraphNode[] nodes){
  pushStyle();
  float s = 10;
  for(GraphNode node : nodes){
    LatLon nodeCoord = city.getGraphNodeCoord(node);
    PVector p = proj.project(nodeCoord);

    noStroke();
    fill(0, 255, 0, 75);
    ellipse(p.x, p.y, s, s);

    noStroke();
    fill(255, 75);
    text(str(node.xf()) + ";" + str(node.yf()), p.x, p.y);
  }
  popStyle();
}

void drawGraphEdges(GraphEdge[] edges){
  pushStyle();
  noFill();

  GraphEdge nearest = null;
  if(nearestRoad != null) nearest = nearestRoad.edge;

  for(GraphEdge ge : edges){
    if(ge == nearest) stroke(#ffff00);
    else stroke(200, 50);

    LatLon fromCoord = city.getGraphNodeCoord(ge.from());
    LatLon toCoord = city.getGraphNodeCoord(ge.to());
    PVector p1 = proj.project(fromCoord);
    PVector p2 = proj.project(toCoord);
    
    line(p1.x, p1.y, p2.x, p2.y);
    
    pushMatrix();
    PVector diff = PVector.sub(p2, p1);
    float a = atan2(diff.y, diff.x);
    translate(p2.x, p2.y);
    rotate(a - HALF_PI);
    
    float s = 15;
    float sr = 3;
    triangle(-s/sr, -s, s/sr, -s, 0, 0);
    
    popMatrix();
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
  float step = .01 / camera.getZoom();
  if (keyCode == UP) camera.moveTarget(step, 0);
  if (keyCode == DOWN) camera.moveTarget(-step, 0);
  if (keyCode == LEFT) camera.moveTarget(0, -step);
  if (keyCode == RIGHT) camera.moveTarget(0, step);

  if (key == '-') camera.zoomOut();
  if (key == '=') camera.zoomIn();
  if (key == '0') camera.lookAt(center);  
  if (key == ' ') saveFrame("../rbk-foresight_###.jpg");
  
  if (key == 'e') deleteSelectedEdge();
  if (key == 'g') bakeGraph();
  if (key == 'r') drawGraphMode = !drawGraphMode;
  
  if (key == '1') drawRoads = !drawRoads;
  if (key == '2') drawAgents = !drawAgents;
  if (key == '3') drawCrossroads = !drawCrossroads;
  if (key == '4') drawNodes = !drawNodes;
  if (key == '5') drawEdges = !drawEdges;
  if (key == '6') drawGraphRoute = !drawGraphRoute;
}