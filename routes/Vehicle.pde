class Vehicle{
  color[] tints = {#f9ed69, #f08a5d, #b83b5e, #6a2c70};
  
  float speed;
  float size;
  int paint;
  
  boolean moving = false;
  
  LatLon location = new LatLon();
  PVector velocity = new PVector();
  //LatLon acceleration = new LatLon();
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
    
    this.paint = this.tints[(int) random(this.tints.length)];
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
      PVector v = getVelocity();
      
      //float dist = this.location.dist(this.targetCoord);
      
      //this.location.add(this.velocity.x, this.velocity.y);
      //if(dist < .001){
      //  PVector lastVelocity = this.targetCoord.toPVector().sub(this.location.toPVector());
      //  this.location.add(lastVelocity.x, lastVelocity.y);

      //  this.nextTarget();
        
      //  lastVelocity = PVector.sub(this.velocity, lastVelocity);
      //  this.location.add(lastVelocity.x, lastVelocity.y);
      //}
      
      
      if(v.mag() > this.speed){
        v.normalize();
        v.mult(this.speed);
        this.location.add(this.getLatLonFromPVector(v));
      }else{
        float d = this.speed - v.mag();
        this.location.add(this.getLatLonFromPVector(v));
        this.nextTarget();
        v = getVelocity();
        v.normalize();
        v.mult(d);
        this.location.add(this.getLatLonFromPVector(v));
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
      this.velocity = this.targetCoord.toPVector()
        .sub(this.location.toPVector())
        .normalize()
        .mult(speed);
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
    
    //PVector velo = this.getVelocity();
    //float angle = atan2(velo.y, velo.x);
    
    PVector xy = this.projector.project(this.location);
    //noStroke();
    //fill(200, 200, 0);
    
//    translate(xy.x, xy.y);
//    rotate(angle);
    //ellipseMode(CENTER);
    //ellipse(xy.x, xy.y, this.size, this.size);
//    rect(0, 0, this.size, this.size/2);
//    rect(xy.x, xy.y, this.size, this.size/2);
//    popMatrix();

    LatLon last = this.track.last();
    if(last != null){
      PVector pxy = this.projector.project(last);
      //stroke(255, 255, 0);
      stroke(this.paint);
      line(pxy.x, pxy.y, xy.x, xy.y);
    }

    //this.track.draw();
    
  }
  
  private LatLon getLatLonFromPVector(PVector v){
    return new LatLon(v.x, v.y);
  }
}