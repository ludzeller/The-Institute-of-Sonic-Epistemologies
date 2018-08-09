/************************************

Data Materiality.

A sine wave swarm synth based on a network of simulated springs
Written by ludwig.zeller@fhnw.ch in about 2015

---

REQUIREMENTS
- tested against Processing 3.3.6, Minim 2.2.2 and Fisica v14 by Ricard Marxer

CONCEPT 
- use this to configure and modulate sine wave audio oscillators in a physically simulated grid

CONTEXT
- this is a part of http://www.ludwigzeller.de/projects/the-institute-of-sonic-epistemologies/
- more codes of this at https://git.iem.at/rumori/The_Institute_of_Sonic_Epistemologies

ISSUES
- Minim tends to be overloaded and skippy
- interaction in fullscreen mode not fully working 

WISHLIST
- demo/instructions video?
- save program states?
- excitation with sensors?
- stereoscopic 3D mode?
- rewrite for paper.js / p5.js?

---

ADD NODES  
- add dynamic nodes: press 'a' and click left
- add static nodes: press 'f' and click left
- adjust ball size: press 'u' and move mouse horizontally

LINK NODES
- link nodes: press 's' and click several nodes
- connect neighbouring nodes: press 'n'
- connect neighbour nodes to static anchors: press 'm'

RANDOMIZE
- randomize: press 'r'
- adjust amount of generated nodes: press 'z' and move mouse horizontally
- adjust auto-link probability: press 't' and move mouse horizontally

REMOVE
- remove single nodes: press 'd' and click left on nodes
- reset everything: press 'c'

PHYSICS
- adjust spring damping: press 'w' and move mouse horizontally
- adjust spring frequency: press '1' and move mouse horizontally
- adjust spring length: press 'e' and move mouse horizontally
- trigger showing of physics parameters: press 'h'

EXITOR
- excite single nodes by mouse-dragging them 
- excite network around mouse cursor: press 'x'
- adjust excitation range: press 'i' and move mouse horizontally
- adjust excitation power: press 'o' and move mouse horizontally

************************************/


import fisica.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

FWorld world;
Minim minim;
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

  // note: needs to run in P3D for fully working mouse fisica interactions
  //size( 1280, 720, P3D);
  fullScreen(P3D);
  pixelDensity(2); // retina
  frameRate(60);
  smooth(8);
  
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
  //println(frameRate);
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