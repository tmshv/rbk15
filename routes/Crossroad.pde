class Crossroad {
  ArrayList<Feature> roads;
  LatLon coord;
  
  public Crossroad(LatLon coord){
    this.roads = new ArrayList<Feature>(); 
    this.coord = coord;
  }
  
  Crossroad addRoad(Feature road){
    this.roads.add(road);
    return this;
  }
  
  boolean has(Feature segment){
    for(Feature f : this.roads){
      if(f == segment) return true;
    }
    return false;
  }
  
  Feature both(Crossroad cr){
    for(Feature f : this.roads){
      if(cr.has(f)) return f;
    }
    return null;
  }
}