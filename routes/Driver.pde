import pathfinder.*;

class Driver {
  public City city;
  public int algorithm = 2;
  
  private float f = 1.0f;
  
  private Vehicle vehicle;
  
  public Driver(City city, int algorhitm){
    this.city = city;
    this.algorithm = algorithm;
  }
  
  public void drive(Vehicle v){
    this.vehicle = v;
  }
  
  public Route navigate(LatLon from, LatLon to){
    Crossroad crFrom = this.city.findNearestCrossroadTo(from);
    Crossroad crTo   = this.city.findNearestCrossroadTo(to);

    return navigate(crFrom, crTo);
  }

  public Route navigate(Crossroad from, Crossroad to){
    int start  = this.city.getCrossroadIndex(from);
    int finish = this.city.getCrossroadIndex(to);
    
    return navigate(start, finish);
  }

  public Route navigate(int from, int to){
    GraphNode[] graphRoute = findRoute(from, to);
    if(graphRoute.length == 0) return null;

    Route route = new Route(city, graphRoute);
    if(this.vehicle != null) this.vehicle.move(route);
    return route;
  }
  
  public GraphNode[] findRoute(int from, int to){
    IGraphSearch finder = makePathFinder(this.city.graph, this.algorithm);
    finder.search(from, to);
    return finder.getRoute();
  }

  IGraphSearch makePathFinder(Graph graph, int alg){
    IGraphSearch pf = null;
    
    switch(alg){
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
      pf = new GraphSearch_Astar(graph, new AshCrowFlight(this.f));
      break;
    case 4:
      pf = new GraphSearch_Astar(graph, new AshManhattan(this.f));
      break;
    }
    return pf;
  }
}