class Camera{
  LatLon target;
  IProjector projector;
  
  boolean following;
  
  Camera(IProjector p){
    target = new LatLon();
    projector = p;
  }
  
  void moveTarget(float lat, float lon){
    if(this.following){
      this.following = false;
      this.target = this.target.clone();
    }
    this.target.lat += lat;
    this.target.lon += lon;
  }
  
  void lookAt(LatLon target){
    this.target.setLatLon(target);
  }
  
  void follow(LatLon target){
    this.target = target;
    this.following = true;
  }
  
  void update(){
    this.applyMatrix();
  }
  
  void applyMatrix(){
    PVector coord = projector.project(target); 
    translate(-coord.x, -coord.y);
  }
  
  void zoomIn(float step){
    this.projector.setScale(this.projector.getScale() + step);
  }
  
  void zoomOut(float step){
    this.projector.setScale(this.projector.getScale() - step);
  }
}
