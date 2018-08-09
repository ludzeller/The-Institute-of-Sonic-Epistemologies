
class Node extends FCircle implements ModulationSource {
  
  Resonator res;

  Node (float size) {
    super(size);
    res = new Resonator(this, Waves.SINE);
  }
  
  void destroy() {
    res.destroy();
    res = null;
  }

  void draw(PGraphics g) {
    
    res.update();
    
    preDraw(g);
    ellipse(0, 0, this.getSize(), this.getSize());
    
    noFill();
    stroke(255,0,0);
    ellipse(0, 0, velocity() * 500, velocity() * 500);
    
    postDraw(g);
  }

  float velocity() {
    return map(constrain(dist(0, 0, this.getVelocityX(), this.getVelocityY()), 0, 7000), 0, 7000, 0, 1) ;
  }
  
  float amp() {
    //return 0;
    return map(velocity(), 0, 1, 0, 0.10);
  }
  
  float pitch() {
    //return 440;
    //println(map(velocity(), 0, 1, 60, 1000));
    //return map(velocity(), 0, 1, 60, 1000);
    float val = pow(map(this.getY(), 0, height, 1, 0), 3); 
    return(map(val, 0, 1, 60, 4000));
  }
  
  float pan() {
    return map(this.getX(), 0, width, -1, 1); 
  }

  //float log10 (float x) {
  //  return (log(x*100) / log(10));
  //}

}