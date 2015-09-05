class Route {
  ArrayList<Feature> features;
  
  private Crossroad last_chain;
  
  public Route(){
    this(new ArrayList<Feature>());
  }
  
  public Route(ArrayList<Feature> route){
    this.features = route;
  }
  
  void chain(Crossroad cr){
    if(this.last_chain != null){
      Feature segment = cr.both(this.last_chain);
      
      if(segment != null){
        this.addFeature(segment);
      }else{
        println("jop");
      }
    }
    
    this.last_chain = cr;
  }
  
  ArrayList<LatLon> bake(){
    ArrayList<LatLon> route = new ArrayList<LatLon>();
    for(Feature f : this.features){
      ArrayList<LatLon> g = f.geometry.coords;
      route.addAll(g);
    }
    return route;
  }
  
  Route addFeature(Feature feature){
     this.features.add(feature);
     return this;
  }
}
