class Street{
  public ArrayList<PVector> coords;
  
  public Street(ArrayList<PVector> coords){
    this.coords = coords;
  }
  
  void draw(){
    noFill();
    stroke(0);
    strokeWeight(1);
    beginShape();
    for(PVector c: this.coords){
      vertex(c.x, c.y);  
    }
    endShape();
  } 
  
  float length(){
    float length = 0;
    PVector prev = coords.get(0);
    for(PVector c : coords){
      PVector d = PVector.sub(c, prev);
      length += d.mag();
      prev = c;
    }
    return length;
  }
}
