// usage: left-click to start a sequence, vertical mouse position sets speed
// please note: you might have to click several times until the program responds

float val = 1.0; // 1 => 100%
int counter = 0;
int max = 35;
int step = 800; 
int last = 0;
float mult = 1.0;
boolean direction = true;
boolean run = false;

void setup() {
  size(800, 800); //<>//
  frameRate(60);
  noFill();
  stroke(255);
  setupAudio();
}

void draw() {
  
  background(0);
  
  if(counter >= max) run = false;
  
  if(run){
    
    if( millis() - last > step) {
      
      mult *= -1; // negative for inversion
      
      val = pow( map( counter, 0, max, 1, 0 ), 2) * mult;
      out.setPan( val > 0 ? 1 : -1 );
      float decayTime = step / 1000.0 * 0.8;
      out.playNote( 0.0, decayTime, new SineInstrument( centerFreq + centerFreq / 2 * range * val ) );
      last = millis();  
      counter++;
    } 
    strokeWeight(5);
    line(width/2, height/2, width/2 + width/2 * val, height/2);
  }
  
}

void mouseClicked() {
  
  run = true;
  val = 1;
  counter = 0;
  step = (int)map(mouseY, height, 0, 1000, 50 );

}