class Camera{
  LatLon target;
  IProjector projector;
  PVector offset;

  private boolean following;
  private int zoom = 1;
  
  Camera(IProjector p, PVector o){
    target = new LatLon();
    projector = p;
    offset = o;
  }
  
  LatLon getCoordAtScreen(float x, float y){
    PVector coord = projector.project(target);
    coord.sub(offset);
    coord.x += x;
    coord.y += y;
    return projector.unproject(coord);
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
    translate(offset.x, offset.y);
    PVector coord = projector.project(target); 
    translate(-coord.x, -coord.y);
  }
  
  int zoomIn(){
    zoom++;
    return zoom;
  }
  
  int zoomOut(){
    zoom = max(1, --zoom);
    return zoom;
  }
  
  int getZoom(){
    return zoom;
  }
}