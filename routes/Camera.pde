class Camera{
  LatLon target;
  IProjector projector;
  PVector offset;


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
    this.target.lat += lat;
    this.target.lon += lon;
  }
  
  void lookAt(LatLon target){
    this.target.setLatLon(target);
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