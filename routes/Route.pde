class Route {
  ArrayList<Road> roads;

  public Route(City city, GraphNode[] route){
    this(new ArrayList<Road>());

    for(int i=0; i<route.length - 1; i++){
      GraphNode n1 = route[i];
      GraphNode n2 = route[i + 1];

      GraphEdge edge = city.graph.getEdge(n1.id(), n2.id());
      Road road = city.getRoad(edge);

      if(road != null) roads.add(road);
    }
  }
  
  public Route(ArrayList<Road> route){
    this.roads = route;
  }
  
  ArrayList<LatLon> bake(){
    ArrayList<LatLon> route = new ArrayList<LatLon>();

    if(roads.size() > 0){
      route.add(roads.get(0).cr1.coord);

      for(Road r : roads){
        route.addAll(r.getInnerCoords());
        route.add(r.cr2.coord);
      }
    }

    return route;
  }
}