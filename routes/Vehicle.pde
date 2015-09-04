class Vehicle{
  float speed;
  float size;
  
  boolean moving = false;
  
  LatLon location = new LatLon();
  Track track;
  
  private LatLon targetCoord;
  private int targetCoordIndex;
  private ArrayList<LatLon> route;
  
  private Projector projector;
  
  public Vehicle(Driver driver, Projector projector){
    this(driver, 3, projector);  
  }
  
  public Vehicle(Driver driver, float speed, Projector projector){
    this.speed = speed;
    this.size = 5;
    this.projector = projector;
    this.track = new Track(projector);
    
    this.drive(driver.navigate());
  }
  
  void drive(Route route){
    this.drive(route, 0);
  }
  
  void drive(Route route, int delay){
    this.route = route.bake();
    this.moving = true;
    
    this.location.setLatLon(this.route.get(0));
    
    this.targetCoordIndex = 1;
    this.nextTarget();
    
    this.writeLocation();
  }
  
  void step(){
    if(this.moving){
      PVector delta = PVector.sub(this.targetCoord.toPVector(), this.location.toPVector());
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
    PVector xy = this.projector.project(this.location);
    noStroke();
    fill(255);
    ellipseMode(CENTER);
    ellipse(xy.x, xy.y, this.size, this.size);
    this.track.draw();
  }
  
  private LatLon getLatLonFromPVector(PVector v){
    return new LatLon(v.x, v.y);
  }
}
