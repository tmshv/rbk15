import pathfinder.*;

class Driver {
  public Graph graph;
  public int algorithm = 0;
  
  public Driver(Graph graph, int algorhitm){
    this.graph = graph;
    this.algorithm = algorithm;
  }
  
  public Route navigate(){
//  Route route = new Route();
//  for(GraphNode node : graphRoute){
//    int id = node.id();
//    Crossroad cr = crossroads.get(id);
//    route.chain(cr);
//  }
//    
//  println(geo.features.size());
//  println(crossroads.size());
//  println(graphRoute.length);
//  println(route.features.size());
    
    int start_id = 0;
    int end_id = 3000;
    
    IGraphSearch finder = makePathFinder(graph, algorithm);
    finder.search(start_id, end_id, true);
    GraphNode[] graphRoute = finder.getRoute();
    
    ArrayList<LatLon> route_coords = new ArrayList<LatLon>();
    for(GraphNode node : graphRoute){
      int id = node.id();
      Crossroad cr = crossroads.get(id);
      route_coords.add(cr.coord);
    }
    
    Route route = new Route();
    route.addFeature(new Feature(route_coords));
    return route;
  }
}

IGraphSearch makePathFinder(Graph graph, int pathFinder){
  IGraphSearch pf = null;
  float f = 1.0f;
  switch(pathFinder){
  case 0:
    pf = new GraphSearch_DFS(graph);
    break;
  case 1:
    pf = new GraphSearch_BFS(graph);
    break;
  case 2:
    pf = new GraphSearch_Dijkstra(graph);
    break;
  case 3:
    pf = new GraphSearch_Astar(graph, new AshCrowFlight(f));
    break;
  case 4:
    pf = new GraphSearch_Astar(graph, new AshManhattan(f));
    break;
  }
  return pf;
}
