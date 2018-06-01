
class Node extends FCircle implements ModulationSource {
  
  Resonator res;

  Node (float size) {
    super(size);
    //res = new Resonator(this);
  }
  
  void destroy() {
    //res.destroy();
    res = null;
  }

  void draw(PGraphics g) {
    preDraw(g);
    ellipse(0, 0, this.getSize(), this.getSize());
    //text( this.vel(), this.getSize() * 0.5 + 5, this.getSize() * 0.5);
    
    //res.update();

    noFill();
    stroke(255,0,0);
    ellipse(0, 0, velocity(), velocity());
    postDraw(g);
  }

  float velocity() {
    return dist(0,0,this.getVelocityX(),this.getVelocityY());
  }
  
  float amp() {
    return 0;
    //return map(velocity(), 0, 5000, 0, 0.05);
  }
  
  float pitch() {
    return 440;
  }
  
  float pan() {
    return this.getX(); 
  }

  float log10 (float x) {
    return (log(x*100) / log(10));
  }

  
}
