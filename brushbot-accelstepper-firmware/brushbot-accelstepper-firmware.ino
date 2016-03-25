// /////////////////////////////////////////////////////////////////////////////
//
// brush-bot Drawing Robot | The Living | 2016
//
// /////////////////////////////////////////////////////////////////////////////

//------------------------------------------------------------------------------
// ACKNOWLEDGEMENTS
//------------------------------------------------------------------------------
// Serial communication, GCODE parsing, and movement methods
// inspired by DrawBot robot by dan@marginallyclever.com
// http://www.github.com/MarginallyClever/Makelangelo


//------------------------------------------------------------------------------
// EXTERNAL DEPENDENCIES
//------------------------------------------------------------------------------

//AccelStepper and MultiStepper libraries
//For stepper motor control
//http://www.airspayce.com/mikem/arduino/AccelStepper/index.html
#include <AccelStepper.h>
#include <MultiStepper.h>

//Default Arduino servo library
#include <Servo.h>

//------------------------------------------------------------------------------
// CONSTANTS
//------------------------------------------------------------------------------
//define serial communication protocol
//serial comm bitrate
#define BAUD          (57600)
//serial input buffer size
#define MAX_BUF       (64)
//timeout length
#define TIMEOUT_OK    (1000)

//define motor pins
//based on RAMPS pinout
//http://reprap.org/wiki/RAMPS_1.4#Firmware_and_Pin_Assignments

//M1 - Top left
#define M1_STEP       (54)  //M1 Stepping Signal
#define M1_DIR        (55)  //M1 Direction Signal
#define M1_ENABLE     (38) //M1 Engage Signal

//M2 - Top right
#define M2_STEP       (60)  //M2 Stepping Signal
#define M2_DIR        (61)  //M2 Direction Signal
#define M2_ENABLE     (56) //M2 Engage Signal
//M3 - Bottom right
#define M3_STEP       (26)  //M3 Stepping Signal
#define M3_DIR        (28)  //M3 Direction Signal
#define M3_ENABLE     (24) //M3 Engage Signal
//M4 - Bottom left
#define M4_STEP       (36)  //M4 Stepping Signal
#define M4_DIR        (34)  //M4 Direction Signal
#define M4_ENABLE     (30) //M4 Engage Signal

//define motor specs
#define STEPS_PER_TURN  (200) // Steps per full revolution
#define MAX_SPEED     (200) // Steps per second

//define forward motor direction
// 0 == clockwise
// 1 == counterclockwise
#define M1_FORWARD    (1) //M1 Forward Direction
#define M2_FORWARD    (0) //M2 Forward Direction
#define M3_FORWARD    (1) //M3 Forward Direction
#define M4_FORWARD    (0) //M4 Forward Direction


//define servo pins
#define SERVO_PIN     (11)
#define PEN_UP_ANGLE  (0) //Servo angle to disengage trigger
#define PEN_DOWN_ANGLE  (10) //Servo angle to engage trigger
#define PEN_DELAY     (250) //delay to allow servo movement, in ms



//define geometry motions and resolution
//for arc directions
#define ARC_CW      (1)
#define ARC_CCW     (-1)
//arcs are constructed by subdivision into line segments
//define length of segment for subdivision (in mm)
#define MM_PER_SEGMENT  (2.0)

//------------------------------------------------------------------------------
// VARIABLES
//------------------------------------------------------------------------------

// initialize stepper motors as AccelStepper objects
// http://www.airspayce.com/mikem/arduino/AccelStepper/classAccelStepper.html
static AccelStepper m1( AccelStepper::DRIVER, M1_STEP, M1_DIR );
static AccelStepper m2( AccelStepper::DRIVER, M2_STEP, M2_DIR );
static AccelStepper m3( AccelStepper::DRIVER, M3_STEP, M3_DIR );
static AccelStepper m4( AccelStepper::DRIVER, M4_STEP, M4_DIR );

static int motor_speed = 100; //steps per s
static int motor_accel = 50;
static int jog_dist = 20;

//initialize Multistepper object
// http://www.airspayce.com/mikem/arduino/AccelStepper/classMultiStepper.html
static MultiStepper steppers;

// initialize servo
// https://www.arduino.cc/en/Reference/Servo
static Servo s1;

// plotter dimensions
// all distances are measured relative to the calibration point of the plotter
// (normally, this is located in the center of the drawing)
// measurement is in millimeters
static float limit_top = 585; //distance to top motor axle centers
static float limit_bottom = -585; //distance to bottom motor axle centers
static float limit_right = 570; //distance to right motor axle centers
static float limit_left = -570; //distance to left motor axle centers

// margin dimensions
// safe area inset from plotter extents
static float margin_top = 0;
static float margin_bottom = 0;
static float margin_right = 0;
static float margin_left = 0;

static boolean useLimits = false;

// gondola dimensions
// all distances are measured relative to the nozzle center
// and assume string attachment at corners
// (normally, cthe nozzle is centered in the gondola)
static float gondola_top = 45; //distance to top string attachments
static float gondola_bottom = -45; //distance to bottom string attachments
static float gondola_right = 45; //distance to right string attachments
static float gondola_left = -45; //distance to left string attachments

// set spool dimensions
// and setup values for determining feed rate
float SPOOL_DIAMETER1 = 30.0;
float THREADPERSTEP1;
float SPOOL_DIAMETER2 = 30.0;
float THREADPERSTEP2;
float SPOOL_DIAMETER3 = 30.0;
float THREADPERSTEP3;
float SPOOL_DIAMETER4 = 30.0;
float THREADPERSTEP4;

//plotter position
static float posx, posy;
static float posz; //pen state

//motor position
static long laststep1, laststep2, laststep3, laststep4;

//serial communication reception
static char buffer[ MAX_BUF + 1 ]; // Serial buffer
static int sofar; //Serial buffer progress counter
static long last_cmd_time; //timeout counter
long line_number; //current line in multi-line GCODE

//------------------------------------------------------------------------------
// METHODS
//------------------------------------------------------------------------------

// MACHINE SETTING FUNCTIONS
//------------------------------------------------------------------------------
static void adjustSpoolDiameter(float diameter1,float diameter2,float diameter3,float diameter4) {
  //update the spool diameters
  SPOOL_DIAMETER1 = diameter1;
  float SPOOL_CIRC = SPOOL_DIAMETER1*PI;  // circumference
  THREADPERSTEP1 = SPOOL_CIRC/STEPS_PER_TURN;  // thread per step

  SPOOL_DIAMETER2 = diameter2;
  SPOOL_CIRC = SPOOL_DIAMETER2*PI;  // circumference
  THREADPERSTEP2 = SPOOL_CIRC/STEPS_PER_TURN;  // thread per step

  SPOOL_DIAMETER3 = diameter3;
  SPOOL_CIRC = SPOOL_DIAMETER3*PI;  // circumference
  THREADPERSTEP3 = SPOOL_CIRC/STEPS_PER_TURN;  // thread per step

  SPOOL_DIAMETER4 = diameter4;
  SPOOL_CIRC = SPOOL_DIAMETER4*PI;  // circumference
  THREADPERSTEP4 = SPOOL_CIRC/STEPS_PER_TURN;  // thread per step]
}


// TRIGONOMETRIC FUNCTIONS
//------------------------------------------------------------------------------

static float atan3( float dy, float dx ){
  //return angle of dy/dx as a value from 0 to 2PI
  float a = atan2( dy, dx );
  if ( a < 0 ) a = ( PI * 2.0 ) + a;
  return a;
}


static float stringLength( float dx, float dy, float spool){
  //convert x,y-offsets and spool diameter to length of unspooled string
  //pythagorean solution = A^2 = C^2 - B^2
  return sqrt( (dx*dx + dy*dy) - (spool / 2.0)*(spool / 2.0) );
}


// INVERSE KINEMATICS
//------------------------------------------------------------------------------

static void IK(float x, float y, long &l1, long &l2, long &l3, long &l4){
  //IK - turns xy coordinates into lengths L1, L2, L3, L4

  //find offset distance in all four directions (up, down, left, right)
  float dy_up = y - limit_top - gondola_top;
  float dy_dn = y - limit_bottom - gondola_bottom;
  float dx_r = x - limit_right - gondola_right;
  float dx_l = x - limit_left - gondola_left;

  //find length to M1, M2, M3, M4
  l1 = floor( stringLength(dx_l, dy_up, SPOOL_DIAMETER1) / THREADPERSTEP1 );
  l2 = floor( stringLength(dx_r, dy_up, SPOOL_DIAMETER2) / THREADPERSTEP2 );
  l3 = floor( stringLength(dx_r, dy_dn, SPOOL_DIAMETER3) / THREADPERSTEP3 );
  l4 = floor( stringLength(dx_l, dy_dn, SPOOL_DIAMETER4) / THREADPERSTEP4 );
}


// MOVEMENT
//------------------------------------------------------------------------------

void pause( long ms ){

  delay( ms / 1000 ); //whole second delay
  delayMicroseconds( ms % 1000 ); //microsecond delay for remainder
}

static void line( float x, float y, float z){
  //Line drawing method

  //limit destinations to safe canvas area
  if( useLimits ){
    x = min( max( x, limit_left + margin_left), limit_right - margin_right );
    y = min( max( y, limit_bottom + margin_bottom ), limit_top - margin_top );
  }

  long positions[4]; //array of desired string lengths
  IK( x, y, positions[0], positions[1], positions[2], positions[3] );

  steppers.moveTo( positions ); //set positions for each motor

  steppers.runSpeedToPosition(); //Blocks until all steppers are in position

  posx = x;
  posy = y;
  posz = z;

  laststep1 = positions[0];
  laststep2 = positions[1];
  laststep3 = positions[2];
  laststep4 = positions[3];
}

static void line_safe( float x, float y, float z ){
  //Subdivided line drawing method

  //measure length of line to be drawn
  float dx = x - posx;
  float dy = y - posy;

  float len = sqrt( dx*dx + dy*dy );

  // check if line is within allowable resolution
  if ( len <= MM_PER_SEGMENT ) {
    //if so, draw line
    line( x, y, z);
    return;
  }

  // if too long, subdivide into smaller segments
  long pieces = floor( len / MM_PER_SEGMENT );
  float x0 = posx;
  float y0 = posy;
  float z0 = posz;
  float a;

  //draw sequential line segments
  for ( long j = 1; j < pieces; j++ ){
    a = (float)j / (float)pieces;

    line( (x - x0)*a + x0, (y - y0)*a + y0, (z - z0)*a + z0);
  }

  line( x, y, z ); //draw final line segment

}


static void arc( float cx, float cy, float x, float y, float z, float dir ){
  //Arc drawing method
  //Assumes fixed radius and max angle of 180 degrees (PI radians)

  //determine radius
  float dx = posx - cx;
  float dy = posy - cy;
  float radius = sqrt( dx*dx + dy*dy );

  //determine angle of arc (sweep)
  float angle1 = atan3( dy, dx );
  float angle2 = atan3( y - cy, x - cx );
  float theta = angle2 - angle1;

  if( dir > 0 && theta < 0 ) angle2 += 2 * PI;
  else if( dir < 0 && theta > 0) angle1 += 2 * PI;

  theta = angle2 - angle1;

  //determine length of arc
  float len = abs(theta) * radius;

  //subdivide arc into safe line segments
  int i, segments = floor( len / MM_PER_SEGMENT );

  float nx, ny, nz, angle3, scale;

  for ( i = 0; i < segments; ++i ){
    //interpolate line segments around the arc
    scale = ((float)i / (float)segments);

    angle3 = ( theta * scale ) + angle1;
    nx = cx + cos(angle3) * radius;
    ny = cy + sin(angle3) * radius;
    nz = ( z - posz) * scale + posz;

    //send to line command
    line( nx, ny, nz );
  }

  //draw final line segment
  line( x, y, z );
}

static void teleport( float x, float y ){
  //Position reset method (no movement)

  posx = x;
  posy = y;

  //calculate stepper positions from coordinates
  long L1, L2, L3, L4;
  IK( posx, posy, L1, L2, L3, L4);

  //update stepper positions
  laststep1 = L1;
  laststep2 = L2;
  laststep3 = L3;
  laststep4 = L4;
  m1.setCurrentPosition(L1);
  m2.setCurrentPosition(L2);
  m3.setCurrentPosition(L3);
  m4.setCurrentPosition(L4);

}

void disable_motors() {
  // disengage motors
  m1.disableOutputs();
  //digitalWrite(M1_ENABLE, HIGH);
  m2.disableOutputs();
  //digitalWrite(M2_ENABLE, HIGH);
  m3.disableOutputs();
  //digitalWrite(M3_ENABLE, HIGH);
  m4.disableOutputs();
  //digitalWrite(M4_ENABLE, HIGH);
}

void activate_motors() {
  // engage motors
  m1.enableOutputs();
  //digitalWrite(M1_ENABLE, LOW);
  m2.enableOutputs();
  //digitalWrite(M2_ENABLE, LOW);
  m3.enableOutputs();
  //digitalWrite(M3_ENABLE, LOW);
  m4.enableOutputs();
  //digitalWrite(M4_ENABLE, LOW);
}


// COMMAND METHODS
//------------------------------------------------------------------------------

float parsenumber( char code, float val ){
  //method for parsing GCODE command type

  char *ptr = buffer;
  while( ptr && *ptr && ptr < buffer + sofar ){
    if( *ptr == code ){
      return atof( ptr + 1 );
    }
    ptr = strchr( ptr, ' ') + 1;
  }
  return val;
}

static void processCommand() {
  //method for parsing GCODE commands

  //skip blank lines
  if( buffer[0] == ';' ) return;

  long cmd;

  // SEQUENCE CHECKS
  //---------------------------
  cmd = parsenumber( 'N', -1);
  //check for line number
  //line number must appear first on the line
  if( cmd != -1 && buffer[0] == 'N' ) {
    if( cmd != line_number ) {
      //indicate wrong line number and return
      Serial.print( "BADLINENUM " );
      Serial.println( line_number );
      return;
    }

    //check for checksum
    if( strchr( buffer, '*' ) != 0 ){
      //check validity
      unsigned char checksum = 0;
      int c = 0;
      while( buffer[c] != '*' && c < MAX_BUF ) checksum ^= buffer[ c++ ];
      c++; //skip checksum indicator (*)
      unsigned char against = (unsigned char)strtod( buffer + c, NULL );
      if( checksum != against ) {
        //indicate wrong checksum and return
        Serial.print( "BADCHECKSUM " );
        Serial.println( line_number );
        return;
      }
    } else {
      Serial.print( "NOCHECKSUM " );
      Serial.println( line_number );
      return;
    }

    //indicate command recieved and OK
    Serial.print( "OK " );
    Serial.println( line_number );
    line_number++;

  }

  // MACHINE SETTINGS COMMANDS
  //---------------------------
  cmd = parsenumber( 'D', -1 );
  switch( cmd ){
    case 1: { //update machine dimensions
      limit_top = parsenumber( 'T', limit_top );
      limit_bottom = parsenumber( 'B', limit_bottom );
      limit_right = parsenumber( 'R', limit_right );
      limit_left = parsenumber( 'L', limit_left );

      teleport( posx, posy ); //update motor positions

      break;
    }

    case 5: { //update spool diameters
      adjustSpoolDiameter(parsenumber( 'S', SPOOL_DIAMETER1 ),
                          parsenumber( 'S', SPOOL_DIAMETER2 ),
                          parsenumber( 'S', SPOOL_DIAMETER3 ),
                          parsenumber( 'S', SPOOL_DIAMETER4 )
                          );

      teleport( posx, posy ); //update motor positions
      break;
    }

    case 10: { //update motor max speed
      motor_speed = min( parsenumber( 'S', motor_speed ), MAX_SPEED);
      m1.setMaxSpeed( motor_speed );
      m2.setMaxSpeed( motor_speed );
      m3.setMaxSpeed( motor_speed );
      m4.setMaxSpeed( motor_speed );
      break;
    }
  }


  // MOTOR OVERRIDE COMMANDS
  //---------------------------
  cmd = parsenumber( 'M', -1 );
  switch( cmd ) {
    case 0: disable_motors(); break; //disengage all steppers
    case 1: activate_motors(); break; //engage all steppers

    case 10: m1.move(jog_dist); m1.runToPosition(); break; //jog M1 stepper forward
    case 11: m1.move(-jog_dist); m1.runToPosition(); break; //jog M1 stepper backward
    case 12: m1.disableOutputs(); break; //disengage M1 stepper
    case 13: m1.enableOutputs(); break; //engage M1 stepper

    case 20: m2.move(jog_dist); m2.runToPosition(); break; //jog M2 stepper forward
    case 21: m2.move(-jog_dist); m2.runToPosition(); break; //jog M2 stepper backward
    case 22: m2.disableOutputs(); break; //disengage M2 stepper
    case 23: m2.enableOutputs(); break; //engage M2 stepper

    case 30: m3.move(jog_dist); m3.runToPosition(); break; //jog M3 stepper forward
    case 31: m3.move(-jog_dist); m3.runToPosition(); break; //jog M3 stepper backward
    case 32: m3.disableOutputs(); break; //disengage M3 stepper
    case 33: m3.enableOutputs(); break; //engage M3 stepper

    case 40: m4.move(jog_dist); m4.runToPosition(); break; //jog M4 stepper forward
    case 41: m4.move(-jog_dist); m4.runToPosition(); break; //jog M4 stepper backward
    case 42: m4.disableOutputs(); break; //disengage M4 stepper
    case 43: m4.enableOutputs(); break; //engage M4 stepper

    case 50: s1.write( PEN_DOWN_ANGLE ); break; //engage sprayer servo
    case 51: s1.write( PEN_UP_ANGLE ); break; //disengage sprayer servo

    case 100: { //M100 - set stepper positions manually
      teleport( parsenumber( 'X', 0 ), parsenumber( 'Y', 0 ) );
      break;
    }
  }

  // MOVE/DRAW COMMANDS
  //---------------------------
  cmd = parsenumber( 'G', -1 );
  switch(cmd) {
    case 0: //move command (no spray)
    case 1: { //G01 - Line command

      //enable sprayer if G01 command
      if( cmd == 1){
        s1.write( PEN_DOWN_ANGLE );
      } else {
        s1.write( PEN_UP_ANGLE );
      }

      line_safe( parsenumber( 'X', posx ), parsenumber( 'Y', posy ), parsenumber( 'Z', posz ) );

      //disengage sprayer
      s1.write( PEN_UP_ANGLE );
      break;
    }
    case 2: //G02 - CW Arc command
    case 3: { //G03 - CCW Arc command
      //enable sprayer
      s1.write( PEN_DOWN_ANGLE );

      arc( parsenumber( 'I', posx ),
           parsenumber( 'J', posy ),
           parsenumber( 'X', posx ),
           parsenumber( 'Y', posy ),
           parsenumber( 'Z', posz ),
           ( cmd == 2 ) ? ARC_CCW : ARC_CW );

      //disable sprayer
      s1.write( PEN_UP_ANGLE );

      break;
    }
    case 4: { //G04 - Pause command
      pause( parsenumber( 'S', 0 ) + parsenumber( 'P', 0 ) * 1000.0f );
      break;
    }
  }
}

void ready() {
  //Prepares input buffer for new messages and
  //signals serial device it is ready for a new command

  sofar = 0; //reset input buffer position
  Serial.print( "\n> " );
  last_cmd_time = millis();
}

void Serial_listen() {
  //Method for listening for commands over serial
  while( Serial.available() > 0 ) {
    char c = Serial.read();
    if( sofar < MAX_BUF ) buffer[ sofar++ ] = c;
    if( c == '\n' || c == '\r') {
      buffer[sofar] = 0;

      //echo command
      //Serial.println(buffer);

      processCommand();
      ready();
      break;
    }
  }
}

//------------------------------------------------------------------------------
//SETUP
//------------------------------------------------------------------------------
void setup(){

  //pin settings
  pinMode(M1_STEP, OUTPUT);
  pinMode(M1_DIR, OUTPUT);
  pinMode(M1_ENABLE, OUTPUT);

  digitalWrite(M1_ENABLE, LOW);
  digitalWrite(M1_DIR, LOW);

  pinMode(M2_STEP, OUTPUT);
  pinMode(M2_DIR, OUTPUT);
  pinMode(M2_ENABLE, OUTPUT);

  digitalWrite(M2_ENABLE, LOW);
  digitalWrite(M2_DIR, LOW);

  pinMode(M3_STEP, OUTPUT);
  pinMode(M3_DIR, OUTPUT);
  pinMode(M3_ENABLE, OUTPUT);

  digitalWrite(M3_ENABLE, LOW);
  digitalWrite(M3_DIR, LOW);

  pinMode(M4_STEP, OUTPUT);
  pinMode(M4_DIR, OUTPUT);
  pinMode(M4_ENABLE, OUTPUT);

  digitalWrite(M4_ENABLE, LOW);
  digitalWrite(M4_DIR, LOW);

  //initialize serial read buffer
  sofar = 0;
  Serial.begin( BAUD );
  Serial.println( F("\n\nHELLO WORLD! I AM BRUSHBOT"));

  //set stepper motor enable pins
  //m1.setEnablePin( M1_ENABLE );
  //m2.setEnablePin( M2_ENABLE );
  //m3.setEnablePin( M3_ENABLE );
  //m4.setEnablePin( M4_ENABLE );

  // set stepper directions
  m1.setPinsInverted(M1_FORWARD, false, false); //direction inversion for M1
  m2.setPinsInverted(M2_FORWARD, false, false); //direction inversion for M2
  m3.setPinsInverted(M3_FORWARD, false, false); //direction inversion for M3
  m4.setPinsInverted(M4_FORWARD, false, false); //direction inversion for M4

  activate_motors();

  // set stepper max speed
  m1.setMaxSpeed( motor_speed );
  m1.setAcceleration( motor_accel );
  m2.setMaxSpeed( motor_speed );
  m2.setAcceleration( motor_accel );
  m3.setMaxSpeed( motor_speed );
  m3.setAcceleration( motor_accel );
  m4.setMaxSpeed( motor_speed );
  m4.setAcceleration( motor_accel );

  // add individual steppers to MultiStepper object
  steppers.addStepper( m1 );
  steppers.addStepper( m2 );
  steppers.addStepper( m3 );
  steppers.addStepper( m4 );

  //initialize servo
  s1.attach( SERVO_PIN );
  s1.write( PEN_UP_ANGLE );

  //initialize plotter positions
  adjustSpoolDiameter(SPOOL_DIAMETER1, SPOOL_DIAMETER2, SPOOL_DIAMETER3, SPOOL_DIAMETER4);
  teleport( 0, 0 );

  //LET'S GO!
  Serial.println( "AND I AM READY TO DRAW");
  ready();
}

//------------------------------------------------------------------------------
//LOOP
//------------------------------------------------------------------------------
void loop() {
  Serial_listen();

  //TIMEOUT CHECK
  //If Arduino hasn't recieved new instructions in a while,
  //send a ready() signal again
  if( millis() - last_cmd_time > TIMEOUT_OK ){
    ready();
  }
}
