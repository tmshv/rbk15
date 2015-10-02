class Road extends LatLonPath{
  Crossroad cr1;
  Crossroad cr2;

  GraphEdge edge;
  
  public Road(ArrayList<LatLon> coords, Crossroad cr1, Crossroad cr2, GraphEdge edge){
    super(coords);

    this.cr1 = cr1;
    this.cr2 = cr2;
    this.edge = edge;

    cr1.addRoad(this);
    cr2.addRoad(this);
  }
}