class LatLonPath{
	public ArrayList<LatLon> coords;

	public LatLonPath(ArrayList<LatLon> coords){
		this.coords = coords;
	}

	ArrayList<LatLon> getInnerCoords(){
		ArrayList<LatLon> c = new ArrayList<LatLon>();
		for(int i=1; i<coords.size()-1; i++){
			c.add(coords.get(i));
		}
		return c;
  	}	

	LatLonPath clone(){
		ArrayList<LatLon> c = new ArrayList<LatLon>();
		for(LatLon ll : coords){
			c.add(ll.clone());
		}
		return new LatLonPath(c);
	}

	LatLonPath reverse(){
		LatLonPath c = clone();
		Collections.reverse(c.coords);
		return c;
	}
}