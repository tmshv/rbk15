class Track{
  ArrayList<LatLon> history = new ArrayList<LatLon>();
  private Projector projector;
  
  public Track(Projector projector){
    this.projector = projector;
  }
  
  void write(LatLon coord){
    this.history.add(coord);  
  }
  
  void draw(){
    noFill();
    stroke(255);
    strokeWeight(3);
    beginShape();
    for(LatLon ll : this.history){
      PVector c = this.projector.project(ll);
      vertex(c.x, c.y);
    }
    endShape();
  }
}
