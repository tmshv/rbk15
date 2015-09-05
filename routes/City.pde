class City {
  IFeatureCollection fc;
  
  ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
  ArrayList<Driver> drivers = new ArrayList<Driver>();
  ArrayList<Crossroad> crossroads = new ArrayList<Crossroad>();
  Graph graph = new Graph();
  
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
    
    for(int i=0; i<10; i++){
      Vehicle v;
      Driver driver;
      
      v = new Vehicle(.001, proj);
      driver = new Driver(this, 2);
      driver.drive(v);     
      driver.navigate();
      
      vehicles.add(v);
      drivers.add(driver);
    }
  }
  
  public void update(){
    for(Vehicle v : this.vehicles){
      v.update();
    }
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
}
