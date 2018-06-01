
class Link extends FDistanceJoint implements ModulationSource {
  
  Resonator res;
  float oldLength = 0;

  Link (FBody b1, FBody b2) {
    super(b1, b2);
    res = new Resonator(this, Waves.SINE);
  }
  
  void destroy() {
    res.destroy();
  }

  void draw(PGraphics g) {
    
    
    res.update();
    
    
    preDraw(g);
    //fill(255);
    //text(this.diffLength(), this.getAnchor1X(), this.getAnchor1Y());
    noFill();
    stroke(255);
    line(this.getAnchor1X(), this.getAnchor1Y(), this.getAnchor2X(), this.getAnchor2Y() );
    //line(0, 0, velocity(), velocity());
    postDraw(g);
    
    oldLength = this.length();
    
  }
  
  float length() {
     return dist(this.getAnchor1X(), this.getAnchor1Y(), this.getAnchor2X(), this.getAnchor2Y());
  }
  
  float diffLength() {
    return abs(this.oldLength - this.length());
  }

  float amp() {
    float val = pow(map(this.diffLength(), 0, 300, 0, 1), 1);
    return map(val, 0, 1, 0, 0.3);
    //return this.getVelocityX();
    //return this.getVelocityX(),this.getVelocityY());
  }
  
  float pitch() {
    //return 440 + map(this.length(), 0, 500, 0, 440);
    return map(this.length(), 0, 500, 50, 1000);
  }
  
  float pan() {
    float val =  ( this.getAnchor1X() + this.getAnchor2X() ) / 2;
    return map( val, 0, width, -1, 1 );
    //return 0;
  }

  float log10 (float x) {
    return (log(x*100) / log(10));
  }

  
}
