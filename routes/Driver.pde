import pathfinder.*;

class Driver {
  public City city;
  public int algorithm = 0;
  
  private float f = 1.0f;
  
  private Vehicle vehicle;
  
  public Driver(City city, int algorhitm){
    this.city = city;
    this.algorithm = algorithm;
  }
  
  public void drive(Vehicle v){
    this.vehicle = v;
  }
  
  public void navigate(){
    if(this.vehicle == null) return;
    
    IGraphSearch finder = makePathFinder(this.city.graph, algorithm);
    finder.search(this.getStart(), this.getEnd(), true);
    GraphNode[] graphRoute = finder.getRoute();
    
    if(graphRoute.length > 0){
      Route route = new Route();
      for(GraphNode node : graphRoute){
        int id = node.id();
        Crossroad cr = city.crossroads.get(id);
        route.chain(cr);
      }
         
      this.vehicle.move(route);
    }else{
      navigate();
    }
  }
  
  private int getStart(){
    int n = this.city.graph.getNbrNodes();
    return (int) random(n);
  }
  
  private int getEnd(){
    int n = this.city.graph.getNbrNodes();
    return (int) random(n);
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
