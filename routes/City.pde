import java.util.Iterator;

class City {
  IFeatureCollection fc;
  
  ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
  ArrayList<Driver> drivers = new ArrayList<Driver>();
  ArrayList<Crossroad> crossroads = new ArrayList<Crossroad>();
  Graph graph = new Graph();
  
  int trafficLimit = 1000;
  
  public City(IFeatureCollection fc, IProjector proj){
    this.fc = fc;
    ArrayList<Feature> features = fc.getFeatures();
    
    for(Feature f : features){
      addCrossroad(f.geometry.first(), f);
      addCrossroad(f.geometry.last(), f);
    }
    
    for(Crossroad cr : crossroads){
      int id = getCrossroadID(cr.coord);
      GraphNode node = new GraphNode(id, cr.coord.lat, cr.coord.lon);
      graph.addNode(node);
    }
    
    for(Feature f : features){
      Geometry g = f.geometry;
      int first = getCrossroadID(g.first());
      int last = getCrossroadID(g.last());
      graph.addEdge(first, last, 0);
    }
  }
  
  public void addVehicle(){
    addVehicle(1);
  }
  
  public void addVehicle(int count){
    Vehicle v;
    Driver driver;
    
    v = new Vehicle(.00025+random(0.00010), proj);
    driver = new Driver(this, 2);
    driver.drive(v);     
    driver.navigate();
    
    vehicles.add(v);
    drivers.add(driver);
    count --;
    if(count > 0) addVehicle(count);
  }
  
  public void update(){
    Iterator<Vehicle> i = this.vehicles.iterator();
    while(i.hasNext()){
      Vehicle v = i.next();
      v.update();
      if(!v.moving){
             
        i.remove();
      }
    }
    
    int add = this.trafficLimit - this.vehicles.size();
    if(add > 0) addVehicle(add);
  }
  
  void addCrossroad(LatLon ll, Feature f){
    for (Crossroad c : this.crossroads){
      if(c.coord.isEqual(ll)){
        c.addRoad(f);
        return;
      }
    }
    
    Crossroad cr = new Crossroad(ll);
    cr.addRoad(f);
    this.crossroads.add(cr);
  }
  
  int getCrossroadID(LatLon ll){
    int length = this.crossroads.size();
    for(int i=0; i < length; i++){
      if(this.crossroads.get(i).coord.isEqual(ll)) return i;
    }
    return -1;
  }
  
  void drawStreets(){
    pushStyle();
      stroke(100);
      strokeWeight(1);
      noFill();
      ArrayList<Feature> streets = getFeatures();
      for (Feature f : streets) {
        beginShape();
        for(LatLon ll : f.geometry.coords){
         PVector xy = proj.project(ll);
         vertex(xy.x, xy.y);
        }
        endShape();
      }
    popStyle();
  }
  
  LatLon getCenter(){
    IFeatureCollection fc = getFeatures();
    LatLon[] bound = fc.bounds();
    return new LatLon(
      (bound[0].lat + bound[1].lat) / 2,
      (bound[0].lon + bound[1].lon) / 2
    );
  }
}