ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
Camera camera = new Camera();

ArrayList<Crossroad> crossroads = new ArrayList<Crossroad>();

Graph graph = new Graph();
Projector proj = new SphericalMercator();

void setup() {
  size(800, 600);
  
  GeoJSON geo = new GeoJSON("../features.geojson");

  for(Feature f : geo.features){
    Geometry g = f.geometry;
    LatLon first = g.first();
    LatLon last = g.last();
    
    addCrossroads(first, f);
    addCrossroads(last, f);
  }
  
  for(Crossroad c : crossroads){
    int id = getCrossroadsID(c.coord);
    GraphNode node = new GraphNode(id, c.coord.lat, c.coord.lon);
    graph.addNode(node);
  }
  
  for(Feature f : geo.features){
    Geometry g = f.geometry;
    int first = getCrossroadsID(g.first());
    int last = getCrossroadsID(g.last());
    
    graph.addEdge(first, last, 0);
  }
  
  Driver driver = new Driver(graph, 0);
   
  Vehicle v = new Vehicle(driver, .001, proj);
  vehicles.add(v);
  
  camera.zoom = .01;
}

void draw() {
  background(204);
  noFill();

  camera.setView(proj.project(vehicles.get(0).location));

  pushMatrix();
  translate(width/2, height/2);
  camera.applyMatrix();

  for (Vehicle vehicle : vehicles) {
    vehicle.size = 10 / camera.zoom;
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

void addCrossroads(LatLon ll, Feature f){
  for (Crossroad c : this.crossroads){
    if(c.coord.isEqual(ll)) return;
  }
  
  Crossroad cr = new Crossroad(ll);
  cr.addRoad(f);
  this.crossroads.add(cr);
}

int getCrossroadsID(LatLon ll){
  int length = this.crossroads.size();
  for(int i=0; i < length; i++){
    if(this.crossroads.get(i).coord.isEqual(ll)) return i;
  }
  return -1;
}
