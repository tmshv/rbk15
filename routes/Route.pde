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
      Feature segment = this.last_chain.both(cr);
      
      if(segment != null){
        this.addFeature(segment);
      }
    }
    
    this.last_chain = cr;
  }
  
  ArrayList<LatLon> bake(){
    ArrayList<LatLon> route = new ArrayList<LatLon>();
    for(Feature f : this.features){
      route.addAll(f.geometry.coords);
    }
    return route;
  }
  
  Route addFeature(Feature feature){
     this.features.add(feature);
     return this;
  }
}
