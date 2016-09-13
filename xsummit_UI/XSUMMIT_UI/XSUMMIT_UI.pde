////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// brush-bot Airbrushing Robot | The Living | 2016                            //
// v3.0 2016.09.12                                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// EXTERNAL DEPENDENCIES
//------------------------------------------------------------------------------
import controlP5.*;
import processing.serial.*;

//------------------------------------------------------------------------------
// GLOBAL VARIABLES
//------------------------------------------------------------------------------

//UI Variables
ControlP5 cP5;
PFont font24, font18, font16i, font14, font12;
color black, white, grey, charcoal, green, red, blue;
PVector origin;
PShape preview;
float scalar;

//Command Variables
GCODEbuffer loader;
GCODEbuffer GB;
GCODEbuffer interrupt;

int geoCount;
int lastGeo;
String lineNum;

//Operation Variables
float posx, posy;
String pos_string;
int m1,m2,m3,m4;
Boolean[] motors;
int spoolStep;
Boolean running;
Boolean spraying;
Boolean paused;
Boolean report;

//Serial Variables
Serial myPort;
String val;
StringList lastVal;
String lastSent;
Boolean connected;
String port;

//DEBUG
Boolean VERBOSE = false;

//------------------------------------------------------------------------------
// SETUP
//------------------------------------------------------------------------------
void setup() {
  settings();

  initVariables();
  initFonts();
  initColors();

  setupControls();

  serialConnect();
}

//------------------------------------------------------------------------------
// DRAW LOOP
//------------------------------------------------------------------------------
void draw() {
  displayUI();
  displayStats();
  
  monitorConnection();
  
  renderNozzle();
}

//------------------------------------------------------------------------------
// APP SETTINGS
//------------------------------------------------------------------------------
void settings() {
  size(1500, 900);
}

void initVariables() {
  origin = new PVector(1050, 450);
  scalar = 1.0/3.0;
  
  posx = 0.0;
  posy = 0.0;
  pos_string = "";
  m1 = 0;
  m2 = 0;
  m3 = 0;
  m4 = 0;
  motors = new Boolean[4];
  spoolStep = 100;
  geoCount = 0;
  lastGeo = 0;
  
  loader = new GCODEbuffer();
  GB = new GCODEbuffer();
  interrupt = new GCODEbuffer();
  
  lastVal = new StringList("...");
  lastSent = "...";
  
  connected = false;
  running = false;
  paused = false;
  spraying = false;
  report = true;
}