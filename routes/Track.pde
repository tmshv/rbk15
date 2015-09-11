class Track{
  ArrayList<LatLon> history = new ArrayList<LatLon>();
  private IProjector projector;
  
  public Track(IProjector projector){
    this.projector = projector;
  }
  
  void write(LatLon coord){
    this.history.add(coord);  
  }
  
  void draw(){
    noFill();
    stroke(200, 200, 0);
    strokeWeight(1);
    beginShape();
    for(LatLon ll : this.history){
      PVector c = this.projector.project(ll);
      vertex(c.x, c.y);
    }
    endShape();
  }
}
