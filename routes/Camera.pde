class Camera extends PVector {
  float zoom = 1;
  void setView(PVector view){
    this.setView(view.x, view.y);
  }
  
  void setView(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  void applyMatrix(){
    scale(this.zoom);
    translate(-this.x, -this.y);
  }
  
  void zoomIn(){
    this.zoom += .025;
  }
  
  void zoomOut(){
    this.zoom -= .025;
  }
}