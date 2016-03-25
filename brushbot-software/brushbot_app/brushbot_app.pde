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
// *n : checksum value for confirming valid data (only necessary for commands with line numbers)
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
int bgColor = color(255); //background color
int fgColor = color(0); //foreground color
int activeColor = color(80, 150, 225); //hover color
int lockColor = color(120, 120, 120); //inactive color

//------------------------------------------------------------------------------
// VARIABLES
//------------------------------------------------------------------------------

//Initialize Serial connection
Serial myPort; //create a serial port object
String val; //create a buffer to hold RX data from serial port

GCodeBuffer GB; //buffer for GCode Commands
int lineCount = 0; //index to keep track of multi-line commands

ControlP5 cP5; //controlP5 object
PFont fontL, fontM, fontS; //controller fonts


//PHYSICAL LIMITS OF MACHINE
float limit_top = 585.0; //top edge
float limit_bottom = -585.0; //bottom edge
float limit_right = 570.0; // right edge
float limit_left = -570.0; // left edge
float speed_max = 200.0; // steps/s


//COMMAND TRACKING
boolean cmdSent = false; //indicates if a command has been sent
boolean cmdTrigger = false; //indicates if command can be sent

//MOTOR SELECTION
boolean[] motors = new boolean[4];


//------------------------------------------------------------------------------
// SETUP
//------------------------------------------------------------------------------
void setup() {

  //Processing 2/3 compatibility
  settings();

  background(200);

  //INTERFACE FONTS
  fontL = loadFont("Roboto-28.vlw");
  fontM = loadFont("Roboto-18.vlw");
  fontS = loadFont("Roboto-12.vlw");

  //SERIAL CONNECTION
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 57600);

  //GCode Buffer - ArrayList to contain commands to send
  GB = new GCodeBuffer();

  //initialize motor selection array
  motors[0] = false;
  motors[1] = false;
  motors[2] = false;
  motors[3] = false;

  //CONTROL PANEL SETTINGS
  cP5 = new ControlP5(this);
  setupControls();

  textFont(fontM);
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

  background(200);
  fill(0);
  rect(0, 600, 800, 200);
  
  fill(fgColor);

  //checks if START button has been pressed
  //ifso, collects data from inputs and generates
  //GCODE command and enters them into GCode Buffer
  if ( cmdTrigger ) {
    generateCommand();
    cmdTrigger = false;
  }

  //TX-RX over Serial port
  serialRun();
}

//GCode Generator
//Extracts data from inputs and passes along
//to GCode helper commands to write command
void generateCommand() {

  //By default, machine is set to move to "top" position
  //float x = xMax;
  //Pull value from Speed slider
  //float s = cP5.get(Slider.class, "speed").getValue();

  //Generate a G01 (Line) command
  //String cmd = genLine(x,s);
  //Write command to GCode Buffer
  //GB.write(cmd);

  //Check if Auto-Home is enabled
  //ifso, generate an additional GoHome command
  //and append to GCode Buffer
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
      cmdSent = false;

      //Check if the GCodeBuffer contains commands
      if ( GB.size() > 0 ) {
        String s = GB.sendNext();
        myPort.write(s);
        //Echo command to debug panel
        println("sent: " + s);
        cmdSent = true;
      }
    } else {
      println( "recieved: " + val );
    }
  }
}