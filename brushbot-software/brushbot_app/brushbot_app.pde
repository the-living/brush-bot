// /////////////////////////////////////////////////////////////////////////////
//
// brush-bot Drawing Robot | The Living | 2016
//
// /////////////////////////////////////////////////////////////////////////////
//
// Sample GCode Format
// N00 G01 X100.0 F50.0*4
// N- : indicates line number of command (for multiple commands)
// G- : indicates type of action to be performed
// X- : input for the G01 command - the X-position to move to
// *n : checksum value for confirming valid data (only for commands w/ line numbers)
// /////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// EXTERNAL DEPENDENCIES
//------------------------------------------------------------------------------
// ControlP5 library
// http://www.sojamo.de/libraries/controlP5/
import controlP5.*;

// Default Serial library
// https://processing.org/reference/libraries/serial/
import processing.serial.*;

//------------------------------------------------------------------------------
// CONSTANTS
//------------------------------------------------------------------------------

//UI COLORS (Buttons & Sliders)
int mainColor = color(200); //background color
int bgColor = color(255); //UX background color
int fgColor = color(0); //UX foreground color
int activeColor = color(80, 150, 225); //UX hover color
int lockColor = color(120, 120, 120); //UX inactive color

//------------------------------------------------------------------------------
// VARIABLES
//------------------------------------------------------------------------------

//initialize Serial connection
// https://processing.org/reference/libraries/serial/Serial.html
Serial myPort; //create a serial port object

//communication buffers
String val; //create a buffer to hold RX data from serial port
GCodeBuffer GB; //buffer for TX GCode Commands
int lineCount = 0; //index to keep track of multi-line commands

//initialize UX objects
ControlP5 cP5; //controlP5 object
PFont fontL, fontM, fontS; //controller fonts

// plotter dimensions
// all distances are measured relative to the calibration point of the plotter
// (normally, this is located in the center of the drawing)
// measurement is in millimeters
float limit_top = 585.0; //top edge
float limit_bottom = -585.0; //bottom edge
float limit_right = 570.0; // right edge
float limit_left = -570.0; // left edge
float speed_max = 200.0; // steps/s

//plotter position
float posx, posy;

//array for issuing individual motor commands
boolean[] motors = new boolean[4];


//------------------------------------------------------------------------------
// SETUP
//------------------------------------------------------------------------------
void setup() {

  //Processing 2/3 compatibility
  settings();

  background(mainColor);


  //SERIAL CONNECTION
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 57600);

  //GCODE BUFFER - ArrayList for TX commands
  GB = new GCodeBuffer();

  //INITIALIZE MOTOR CONTROL ARRAY
  motors[0] = false;
  motors[1] = false;
  motors[2] = false;
  motors[3] = false;

  //INITIALIZE PLOTTER position
  posx = 0;
  posy = 0;

  //UX FONTS
  fontL = loadFont("Roboto-28.vlw");
  fontM = loadFont("Roboto-18.vlw");
  fontS = loadFont("Roboto-12.vlw");
  //INITIALIZE UX
  cP5 = new ControlP5(this);
  setupControls();

  //SET DEFAULT FONT
  //textFont(fontM);
}

//------------------------------------------------------------------------------
// SETTINGS
//------------------------------------------------------------------------------
void settings() {

  size(800, 800);
}

//------------------------------------------------------------------------------
// DRAW
//------------------------------------------------------------------------------
void draw() {

  background(mainColor);
  fill(0);
  rect(0, 600, 800, 200);

  noFill();
  rect(25, 25, 550, 550);
  //line( 600, 0, 600, height);

  //TX-RX over Serial port
  serialRun();
}

//Serial Port Communication
//Checks if serial port has available data
//if data is a "READY" signal from the Arduino
//checks if commands are available to send
//ifso, commands are written to serial port
void serialRun() {

  if (myPort.available() > 0) {
    val = myPort.readString();

    //Arduino firmware signals readiness with a ">"
    if (val.equals("\n> ") ) {
      //println( val );
      //Check if the GCodeBuffer contains commands
      if ( GB.size() > 0 ) {
        String s = GB.sendNext();
        myPort.write(s);
        //Echo command to debug panel
        println("sent: " + s);
      }
    } else {
      println( "recieved: " + val );
    }
  }
}
