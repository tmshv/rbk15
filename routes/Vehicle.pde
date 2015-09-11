class Vehicle{
  float speed;
  float size;
  
  boolean moving = false;
  
  LatLon location = new LatLon();
  Track track;
  
  private LatLon targetCoord;
  private int targetCoordIndex;
  private ArrayList<LatLon> route;
  
  private IProjector projector;
  
  public Vehicle(IProjector projector){
    this(3, projector);  
  }
  
  public Vehicle(float speed, IProjector projector){
    this.speed = speed;
    this.size = 5;
    this.projector = projector;
    this.track = new Track(projector);
  }
  
  void move(Route route){
    this.move(route, 0);
  }
  
  void move(Route route, int delay){
    this.route = route.bake();
    if(this.route.size() == 0) {
      this.moving = false;
      return;
    }
    this.moving = true;
    
    this.location.setLatLon(this.route.get(0));
    
    this.targetCoordIndex = 1;
    this.nextTarget();
    
    this.writeLocation();
  }
  
  void update(){
    if(this.moving){
      PVector delta = getVelocity();
      
      if(delta.mag() > this.speed){
        delta.normalize();
        delta.mult(this.speed);
      
        this.location.add(this.getLatLonFromPVector(delta));
      }else{
        this.location.add(this.getLatLonFromPVector(delta));
        this.nextTarget();    
      }
      
      this.writeLocation();
    }
  }
  
  PVector getVelocity(){
    return PVector.sub(
      this.targetCoord.toPVector(),
      this.location.toPVector()
    );
  }
  
  void nextTarget(){
    if(this.targetCoordIndex < this.route.size()){
      this.targetCoord = this.route.get(this.targetCoordIndex);    
    }else{
      this.moving = false;
    }
    this.targetCoordIndex ++;
  }
  
  void writeLocation(){
    this.track.write(this.location.clone());
  }
  
  void draw(){
//    pushMatrix();
    
    PVector velo = this.getVelocity();
    float angle = atan2(velo.y, velo.x);
    
    PVector xy = this.projector.project(this.location);
    noStroke();
    fill(200, 200, 0);
    
    
//    translate(xy.x, xy.y);
//    rotate(angle);
    ellipseMode(CENTER);
    ellipse(xy.x, xy.y, this.size, this.size);
//    rect(0, 0, this.size, this.size/2);
//    rect(xy.x, xy.y, this.size, this.size/2);
//    popMatrix();

    this.track.draw();
    
  }
  
  private LatLon getLatLonFromPVector(PVector v){
    return new LatLon(v.x, v.y);
  }
}
