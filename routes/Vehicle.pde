class Vehicle{
  float speed;
  
  boolean moving = false;
  
  PVector location = new PVector();
  Track track = new Track();
  
  private PVector targetCoord;
  private int targetCoordIndex;
  private Street street;
  
  public Vehicle(){
    this(3);  
  }
  
  public Vehicle(float speed){
    this.speed = speed;
  }
  
  void drive(Street street){
    this.street = street;
    this.moving = true;
    
    PVector start = this.street.coords.get(0);
    this.location.x = start.x;
    this.location.y = start.y;
    
    this.targetCoordIndex = 1;
    this.nextTarget();
    
    this.writeLocation();
  }
  
  void step(){
    if(this.moving){
      PVector delta = PVector.sub(this.targetCoord, this.location);
      if(delta.mag() > this.speed){
        delta.normalize();
        delta.mult(this.speed);
      
        this.location.add(delta);
      }else{
        this.location.add(delta);
        this.nextTarget();    
      }
      
      this.writeLocation();
    }
  }
  
  void nextTarget(){
    if(this.targetCoordIndex < this.street.coords.size()){
      this.targetCoord = this.street.coords.get(this.targetCoordIndex);    
    }else{
      this.moving = false;
    }
    this.targetCoordIndex ++;
  }
  
  void writeLocation(){
    this.track.write(this.location.get());
  }
  
  void draw(){
    float size = 5;
    noStroke();
    fill(255);
    ellipseMode(CENTER);
    ellipse(this.location.x, this.location.y, size, size);
    this.track.draw();
  }
}
