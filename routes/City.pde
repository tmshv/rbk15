import java.util.Iterator;

class City {
  ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();
  ArrayList<Crossroad> crossroads = new ArrayList<Crossroad>();
  ArrayList<Road> roads = new ArrayList<Road>();
  Graph graph = new Graph();
  
  int trafficLimit = 1000;
  
  LatLon[] bound;

  public City(IFeatureCollection fc, IProjector proj){
    ArrayList<Feature> features = fc.getFeatures();
    
    bound = fc.bounds();
    GraphEdge edge;
    Road road;
    for(Feature f : features){
      LatLonPath path = new LatLonPath(f.geometry.clone().coords);

      Crossroad cr1 = getCrossroadAt(f.geometry.first());
      Crossroad cr2 = getCrossroadAt(f.geometry.last());
      float weight = cr1.coord.dist(cr2.coord);

      edge = addGraphEdge(cr1.node.id(), cr2.node.id(), weight);
      road = new Road(path.coords, cr1, cr2, edge);
      roads.add(road);

      edge = addGraphEdge(cr2.node.id(), cr1.node.id(), weight);
      road = new Road(path.reverse().coords, cr2, cr1, edge);
      roads.add(road);
    }
  }

  public Road getRoad(GraphEdge edge){
    for(Road r : roads){
      // if(r.edge == edge) return r;
      if(r.cr1.node.id() == edge.from().id() && r.cr2.node.id() == edge.to().id()) return r;
    }
    return null;
  }

  public LatLon getGraphNodeCoord(GraphNode node){
    Crossroad cr = crossroads.get(node.id());
    return cr.coord;
  }

  private GraphNode addGraphNode(int id, float x, float y){
    GraphNode node = new GraphNode(id, x, y);
    graph.addNode(node);
    return node;
  }

  private GraphEdge addGraphEdge(int from, int to, float weight){
    graph.addEdge(from, to, weight);
    return graph.getEdge(from, to);
  }
  
  public void update(){
    Iterator<Vehicle> i = this.vehicles.iterator();
    while(i.hasNext()){
      Vehicle v = i.next();
      v.update();
      if(!v.moving) i.remove();
    }
  }
  
  public void addVehicle(Vehicle v){
    this.vehicles.add(v);
  }
  
  Crossroad getCrossroadAt(LatLon ll){
    for (Crossroad cr : crossroads){
      if(cr.coord.isEqual(ll)){
        return cr;
      }
    }

    int id = crossroads.size();
    GraphNode n = addGraphNode(id, ll.lat, ll.lon);
    Crossroad cr = new Crossroad(ll, n);
    crossroads.add(cr);
    return cr;
  }
  
  int getCrossroadIndex(LatLon ll){
    int length = this.crossroads.size();
    for(int i=0; i < length; i++){
      if(this.crossroads.get(i).coord.isEqual(ll)) return i;
    }
    return -1;
  }
  
  int getCrossroadIndex(Crossroad cr){
    return getCrossroadIndex(cr.coord);
  }
  
  void drawVehicles(){
    for (Vehicle vehicle : this.vehicles) vehicle.draw();
  }
  
  void drawCrossroads(){
    pushStyle();
    
    for (Crossroad cr : this.crossroads) {
      noStroke();
      fill(255, 30);

      float s = map(cr.roads.size(), 0, 10, 10, 30);
      PVector p = proj.project(cr.coord); 
      ellipse(p.x, p.y, s, s);

      int crRoads = cr.roads.size();
      int crId = getCrossroadIndex(cr);

      noStroke();
      fill(#ffff00);
      textAlign(CENTER, CENTER);
      text(str(crId), p.x, p.y);
      // text(str(crRoads), p.x, p.y);
    }
    popStyle();
  }

  void drawRoads(Road selected){
    pushStyle();
    noFill();
    for (Road road : roads) {
      stroke(255, 50);
      strokeWeight(1);

      if(road == selected){
        stroke(#009966);
        strokeWeight(2);
      }

      beginShape();
      int i = 0;
      for(LatLon ll : road.coords){
       PVector xy = proj.project(ll);
       vertex(xy.x, xy.y);
       // text(str(i), xy.x, xy.y);
       i ++;
      }
      endShape();
    }
    popStyle();
  }
  
  LatLon getCenter(){
    return new LatLon(
      (bound[0].lat + bound[1].lat) / 2,
      (bound[0].lon + bound[1].lon) / 2
    );
  }
  
  public Crossroad findNearestCrossroadTo(LatLon latlon){
    float max_dist = 6378137; //<>//
    
    Crossroad choise = null;
    for(Crossroad cr : this.crossroads){
      float dist = cr.coord.dist(latlon);
      if(dist < max_dist){
        max_dist = dist;
        choise = cr;
      }
    }
    return choise;
  }

  GraphEdge findNearestGraphEdgeTo(LatLon latlon){
    PVector v = proj.project(latlon);

    GraphEdge nearest = null;
    float minDist = Float.MAX_VALUE;

    GraphEdge[] edges = graph.getAllEdgeArray();
    for(GraphEdge ge : edges){
      LatLon fromCoord = city.getGraphNodeCoord(ge.from());
      LatLon toCoord = city.getGraphNodeCoord(ge.to());

      PVector p1 = proj.project(fromCoord);
      PVector p2 = proj.project(toCoord);
      
      PVector projectionVertex = GeometryUtils.projectVertexOnLine(v, p1, p2);

      String pointClass = GeometryUtils.classify(projectionVertex, p1, p2);

      if(pointClass != "between") continue;

      float d = PVector.dist(v, projectionVertex);
      if(d < minDist){
        minDist = d;
        nearest = ge;
      }
    }

    return nearest;
  }

  Road findNearestRoadTo(LatLon latlon){
    GraphEdge nearest = findNearestGraphEdgeTo(latlon);
    if(nearest != null){
      for(Road r : roads){
        if(r.edge == nearest) return r;
      }
    }
    return null;
  }

  // private void joinCrossroad(Crossroad cr){
  //   Iterator<Crossroad> i = crossroads.iterator();
  //   while(i.hasNext()){
  //     Crossroad cr = i.next();
      
  //     if(cr.roads.size() == 4){
  //       i.remove();
  //     }
  //   }
  // }
}
