class Track{
  ArrayList<PVector> history = new ArrayList<PVector>();
  void write(PVector coord){
    this.history.add(coord);  
  }
  
  void draw(){
    noFill();
    stroke(255);
    strokeWeight(3);
    beginShape();
    for(PVector c : this.history){
      vertex(c.x, c.y);
    }
    endShape();
  }
}
