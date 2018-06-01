// a physical modelling sine wave modulator

// https://github.com/ludzeller/The-Institute-of-Sonic-Epistemologies
// http://www.ludwigzeller.de/projects/the-institute-of-sonic-epistemologies/
// ludwig.zeller@fhnw.ch


import fisica.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

// list help
// generate anchor
// minim test von altem sketch

FWorld world;
Minim       minim;
AudioOutput out; 

boolean mouseReleased = false;
boolean paused = false;

FBody prev;
float globFreq = 0.63;
float globDamp = 0.01;
float globLength = 50;

ArrayList<Link> joints;
ArrayList<Node> anchors;
ArrayList<Node> balls;

float anchorSize = 30;
float ballSize = 20;

float probability = 15;
int randomAmount = 12;

// shockwave
float power = 2000;
float range = 100;

boolean showHelp = false;

void setup() {

  //size( 1920, 1080, P3D);
  fullScreen();
  frameRate(60);
  //frame.setBackground(new java.awt.Color(0));
  smooth();
  
  Fisica.init(this);
  world = new FWorld();
  world.setGravity(0, 0);


  joints = new ArrayList<Link>();
  anchors = new ArrayList<Node>();
  balls = new ArrayList<Node>();  

  createMinim();
  reset();
}

void createMinim() {

  minim = new Minim(this);
  //minim.debugOn();
  out = minim.getLineOut(Minim.STEREO, 2048);
}

void draw() {

  background(0);

  handleControl();

  //fill(0,10);
  //rect(0,0,width,height);

  if (showHelp) {
    fill(255);
    text("Spring frequency: " + globFreq, 50, 50);
    text("Spring damping: " + globDamp, 50, 70);
    text("Spring length: " + globLength, 50, 90);
    text("Link probability: " + probability, 50, 110);
    text("Random amount: " + randomAmount, 50, 130);
    text("Ball size: " + ballSize, 50, 150);
    text("Shock power: " + power, 50, 170);
  }

  if (!paused) {
    try {
      world.step();
    } 
    catch(Exception e) {
    }
    catch(Error e) {
    }
  }
  world.draw();
}