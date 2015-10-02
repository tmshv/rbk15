class Crossroad {
  ArrayList<Road> roads;
  LatLon coord;
  GraphNode node;

  public Crossroad(LatLon coord, GraphNode node){
    this.roads = new ArrayList<Road>(); 
    this.coord = coord;
    this.node = node;
  }
  
  Crossroad addRoad(Road road){
    this.roads.add(road);
    return this;
  }
  
  boolean has(Road road){
    for(Road f : this.roads){
      if(f == road) return true;
    }
    return false;
  }
  
  /**
  * Find a road for moving from cr to this
  **/
  // Feature arrive(Crossroad cr){
  //   for(Feature f : cr.roads){

  //     if (f.geometry.last().equals(cr.coord)) return f;

  //     // if(this.has(f)) return f;
  //   }
  //   return null;
  // }
}