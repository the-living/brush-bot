//------------------------------------------------------------------------------
//brush-bot Drawing Robot
//based on Draw robot by dan@marginallyclever.com
//------------------------------------------------------------------------------
// Copyright at end of file.  Please see
// http://www.github.com/MarginallyClever/Makelangelo for more information.


//------------------------------------------------------------------------------
// CONSTANTS
//------------------------------------------------------------------------------
#define MOTHERBOARD 1  // Adafruit Motor Shield 1

// Increase this number to see more output
#define VERBOSE         (0)

// Comment out this line to disable findHome and limit switches
//#define USE_LIMIT_SWITCH  (1)


// which motor is on which pin?
//#define M1_PIN          (1)
//#define M2_PIN          (2)
//#define M3_PIN          (3)
//#define M4_PIN          (4)
//FLIPPED OPTION
#define M1_PIN          (2)
#define M2_PIN          (1)
#define M3_PIN          (4)
#define M4_PIN          (3)

// which limit switch is on which pin?
//#define L_PIN           (A3)
//#define R_PIN           (A5)
//FLIPPED OPTION
#define L_PIN           (A5)
#define R_PIN           (A3)

// NEMA17 are 200 steps (1.8 degrees) per turn.  If a spool is 0.8 diameter
// then it is 2.5132741228718345 circumference, and
// 2.5132741228718345 / 200 = 0.0125663706 thread moved each step.
// NEMA17 are rated up to 3000RPM.  Adafruit can handle >1000RPM.
// These numbers directly affect the maximum velocity.
#define STEPS_PER_TURN  (200.0)


#define NUM_TOOLS  (6)


// *****************************************************************************
// *** Don't change the constants below unless you know what you're doing.   ***
// *****************************************************************************

// switch sensitivity
#define SWITCH_HALF     (512)

// servo angles for pen control
#define PEN_UP_ANGLE    (0)
#define PEN_DOWN_ANGLE  (10)  // Some servos don't like 0 degrees
#define PEN_DELAY       (250)  // in ms

#define MAX_STEPS_S     (STEPS_PER_TURN*MAX_RPM/60.0)  // steps/s

#define MAX_FEEDRATE    (200)
#define MIN_FEEDRATE    (0.01) // steps / second

// for arc directions
#define ARC_CW          (1)
#define ARC_CCW         (-1)
// Arcs are split into many line segments.  How long are the segments?
#define CM_PER_SEGMENT   (0.2)

// Serial communication bitrate
#define BAUD            (57600)
// Maximum length of serial input message.
#define MAX_BUF         (64)

// servo pin differs based on device
#define SERVO_PIN       (9)
//#define SOLND_PIN       (9)

#define TIMEOUT_OK      (1000)  // 1/4 with no instruction?  Make sure PC knows we are waiting.

#ifndef USE_SD_CARD
#define File int
#endif


#if MOTHERBOARD == 1
#define M1_STEP  m1.step
#define M2_STEP  m2.step
#define M3_STEP  m3.step
#define M1_ONESTEP(x)  m1.onestep(x)
#define M2_ONESTEP(x)  m2.onestep(x)
#define M3_ONESTEP(x)  m3.onestep(x)
#define M4_ONESTEP(x)  m4.onestep(x)
#endif
#if MOTHERBOARD == 2
#define M1_STEP  m1->step
#define M2_STEP  m2->step
#define M3_STEP  m3->step
#define M4_STEP  m4->step
#define M1_ONESTEP(x)  m1->onestep(x,INTERLEAVE)
#define M2_ONESTEP(x)  m2->onestep(x,INTERLEAVE)
#define M3_ONESTEP(x)  m3->onestep(x,INTERLEAVE)
#define M4_ONESTEP(x)  m4->onestep(x,INTERLEAVE)
// stacked motor shields have different addresses. The default is 0x60
#define SHIELD_ADDRESS (0x60)
#endif

//------------------------------------------------------------------------------
// EEPROM MEMORY MAP
//------------------------------------------------------------------------------
#define EEPROM_VERSION   4             // Increment EEPROM_VERSION when adding new variables
#define ADDR_VERSION     0             // address of the version number (one byte)
#define ADDR_UUID        1             // address of the UUID (long - 4 bytes)
#define ADDR_SPOOL_DIA1  5             // address of the spool diameter (float - 4 bytes)
#define ADDR_SPOOL_DIA2  9             // address of the spool diameter (float - 4 bytes)
#define ADDR_SPOOL_DIA3  13            // address of the spool diameter (float - 4 bytes)
#define ADDR_SPOOL_DIA4  17            // address of the spool diameter (float - 4 bytes)

//------------------------------------------------------------------------------
// INCLUDES
//------------------------------------------------------------------------------
#if MOTHERBOARD == 1
#include <SPI.h>  // pkm fix for Arduino 1.5
// Adafruit motor driver library
#include <AFMotorDrawbot.h>
#endif

// Default servo library
#include <Servo.h>

// Saving config
#include <EEPROM.h>
#include <Arduino.h>  // for type definitions

#include "Vector3.h"


//------------------------------------------------------------------------------
// VARIABLES
//------------------------------------------------------------------------------
#if MOTHERBOARD == 1
// Initialize Adafruit stepper controller
static AF_Stepper m1((int)STEPS_PER_TURN, M1_PIN);
static AF_Stepper m2((int)STEPS_PER_TURN, M2_PIN);
static AF_Stepper m3((int)STEPS_PER_TURN, M3_PIN);
static AF_Stepper m4((int)STEPS_PER_TURN, M4_PIN);
#endif

static Servo s1;

// robot UID
int robot_uid=0;

// plotter limits
// all distances are relative to the calibration point of the plotter.
// (normally this is the center of the drawing area)
static float limit_top = 540;  // distance to top of drawing area.
static float limit_bottom = -660;  // Distance to bottom of drawing area.
static float limit_right = 620;  // Distance to right of drawing area.
static float limit_left = -620;  // Distance to left of drawing area.

//gondola dimensions
//all distances (mm) of string attachment relative to pen position
//(normally this is the centered in the gondola)
static float gondola_top = 76; //distance to top string attachment on gondola
static float gondola_bottom = -76; //distance to bottom string attachment on gondola
static float gondola_right = 76; //distance to right string attachment on gondola
static float gondola_left = -76; //distance to left string attachment on gondola

// what are the motors called?
// motors are labelled clockwise from top left
char m1d='A'; // top left
char m2d='B'; // top right
char m3d='C'; // bottom right
char m4d='D'; // bottom left

// which way are the spools wound, relative to motor movement?
int M1_REEL_IN  = BACKWARD;
int M1_REEL_OUT = FORWARD;
int M2_REEL_IN  = FORWARD;
int M2_REEL_OUT = BACKWARD;
int M3_REEL_IN = FORWARD;
int M3_REEL_OUT = BACKWARD;
int M4_REEL_IN = FORWARD;
int M4_REEL_OUT = BACKWARD;

// calculate some numbers to help us find feed_rate
float SPOOL_DIAMETER1 = 20.0;
float THREADPERSTEP1;  // thread per step

float SPOOL_DIAMETER2 = 20.0;
float THREADPERSTEP2;  // thread per step

float SPOOL_DIAMETER3 = 20.0;
float THREADPERSTEP3;

float SPOOL_DIAMETER4 = 20.0;
float THREADPERSTEP4;

// plotter position.
static float posx, velx;
static float posy, vely;
static float posz;  // pen state
static float feed_rate=0;
static long step_delay;


// motor position
static long laststep1, laststep2;

static char absolute_mode=1;  // absolute or incremental programming mode?
static float mode_scale;   // mm or inches?
static char mode_name[3];


// Serial comm reception
static char buffer[MAX_BUF+1];  // Serial buffer
static int sofar;               // Serial buffer progress
static long last_cmd_time;      // prevent timeouts

Vector3 tool_offset[NUM_TOOLS];
int current_tool=0;

long line_number;


//Servo myservo;

//------------------------------------------------------------------------------
// METHODS
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
// calculate max velocity, threadperstep.
static void adjustSpoolDiameter(float diameter1,float diameter2,float diameter3,float diameter4) {
  SPOOL_DIAMETER1 = diameter1;
  float SPOOL_CIRC = SPOOL_DIAMETER1*PI;  // circumference
  THREADPERSTEP1 = SPOOL_CIRC/STEPS_PER_TURN;  // thread per step

  SPOOL_DIAMETER2 = diameter2;
  SPOOL_CIRC = SPOOL_DIAMETER2*PI;  // circumference
  THREADPERSTEP2 = SPOOL_CIRC/STEPS_PER_TURN;  // thread per step

  SPOOL_DIAMETER3 = diameter3;
  SPOOL_CIRC = SPOOL_DIAMETER3*PI;  // circumference
  THREADPERSTEP3 = SPOOL_CIRC/STEPS_PER_TURN;  // thread per step
[
  SPOOL_DIAMETER4 = diameter4;
  SPOOL_CIRC = SPOOL_DIAMETER4*PI;  // circumference
  THREADPERSTEP4 = SPOOL_CIRC/STEPS_PER_TURN;  // thread per step]

#if VERBOSE > 2
  Serial.print(F("SpoolDiameter1 = "));  Serial.println(SPOOL_DIAMETER1,3);
  Serial.print(F("SpoolDiameter2 = "));  Serial.println(SPOOL_DIAMETER2,3);
  Serial.print(F("SpoolDiameter3 = "));  Serial.println(SPOOL_DIAMETER3,3);
  Serial.print(F("SpoolDiameter4 = "));  Serial.println(SPOOL_DIAMETER4,3);
  Serial.print(F("THREADPERSTEP1="));  Serial.println(THREADPERSTEP1,3);
  Serial.print(F("THREADPERSTEP2="));  Serial.println(THREADPERSTEP2,3);
  Serial.print(F("THREADPERSTEP3="));  Serial.println(THREADPERSTEP3,3);
  Serial.print(F("THREADPERSTEP4="));  Serial.println(THREADPERSTEP4,3);
  Serial.print(F("MAX_VEL="));  Serial.println(MAX_VEL,3);
#endif
}


//------------------------------------------------------------------------------
// returns angle of dy/dx as a value from 0...2PI
static float atan3(float dy,float dx) {
  float a=atan2(dy,dx);
  if(a<0) a=(PI*2.0)+a;
  return a;
}


//------------------------------------------------------------------------------
static char readSwitches() {
#ifdef USE_LIMIT_SWITCH
  // get the current switch state
  return ( (analogRead(L_PIN) < SWITCH_HALF) | (analogRead(R_PIN) < SWITCH_HALF) );
#else
  return 0;
#endif  // USE_LIMIT_SWITCH
}


//------------------------------------------------------------------------------
// feed rate is given in units/min and converted to cm/s
static void setFeedRate(float v) {
  if(feed_rate==v) return;
  feed_rate=v;

  if(v > MAX_FEEDRATE) v = MAX_FEEDRATE;
  if(v < MIN_FEEDRATE) v = MIN_FEEDRATE;

  step_delay = 1000000.0 / v;

#if VERBOSE > 1
  Serial.print(F("feed_rate="));  Serial.println(feed_rate);
  Serial.print(F("step_delay="));  Serial.println(step_delay);
#endif
}


//------------------------------------------------------------------------------
static void printFeedRate() {
  Serial.print(F("F"));
  Serial.println(feed_rate);
}


//------------------------------------------------------------------------------
// Change pen state.
static void setPenAngle(int pen_angle) {
  if(posz!=pen_angle) {
    posz=pen_angle;

    if(posz<PEN_DOWN_ANGLE){
        posz=PEN_DOWN_ANGLE;
//        digitalWrite(SOLND_PIN, HIGH);
    }
    if(posz>PEN_UP_ANGLE  ) {
      posz=PEN_UP_ANGLE;
//      digitalWrite(SOLND_PIN, LOW);
    }

    s1.write( (int)posz );
    delay(PEN_DELAY);
  }
}

//------------------------------------------------------------------------------
// Change airbrush state


//------------------------------------------------------------------------------
// Inverse Kinematics - turns XY coordinates into lengths L1,L2
static void IK(float x, float y, long &l1, long &l2) {
  // find length to M1
  float dy = y - limit_top;
  float dx = x - limit_left;
  l1 = floor( sqrt(dx*dx+dy*dy) / THREADPERSTEP1 );
  // find length to M2
  dx = limit_right - x;
  l2 = floor( sqrt(dx*dx+dy*dy) / THREADPERSTEP2 );
}

//Inverse Kinematics motor version - turns xy coordinates into lengths L1, L2, L3, L4
static void IK4(float x, float y, long &l1, long &l2, long &l3, long &l4){
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

//convert x,y-offsets and spool diameter to length
static float stringLength( float dx, float dy, float spool){
  //pythagorean solution = A^2 = C^2 - B^2
  return sqrt( (dx*dx + dy*dy) - (spool / 2.0)*(spool / 2.0) )
}


//------------------------------------------------------------------------------
// Forward Kinematics - turns L1,L2 lengths into XY coordinates
// use law of cosines: theta = acos((a*a+b*b-c*c)/(2*a*b));
// to find angle between M1M2 and M1P where P is the plotter position.
static void FK(float l1, float l2,float &x,float &y) {
  float a = l1 * THREADPERSTEP1;
  float b = (limit_right-limit_left);
  float c = l2 * THREADPERSTEP2;

  // slow, uses trig
  //float theta = acos((a*a+b*b-c*c)/(2.0*a*b));
  //x = cos(theta)*l1 + limit_left;
  //y = sin(theta)*l1 + limit_top;
  // but we know that cos(acos(i)) = i
  // and we know that sin(acos(i)) = sqrt(1-i*i)
  float i=(a*a+b*b-c*c)/(2.0*a*b);
  x = i * l1 + limit_left;
  y = sqrt(1.0 - i*i)*l1 + limit_top;
}


//------------------------------------------------------------------------------
void pause(long ms) {
  delay(ms/1000);
  delayMicroseconds(ms%1000);
}


//------------------------------------------------------------------------------
static void line(float x,float y,float z) {
  long l1,l2;
  IK(x,y,l1,l2);
  long d1 = l1 - laststep1;
  long d2 = l2 - laststep2;

  long ad1=abs(d1);
  long ad2=abs(d2);
  int dir1=d1<0?M1_REEL_IN:M1_REEL_OUT;
  int dir2=d2<0?M2_REEL_IN:M2_REEL_OUT;
  long over=0;
  long i;

//  setPenAngle((int)z);

  // bresenham's line algorithm.
  if(ad1>ad2) {
    for(i=0;i<ad1;++i) {
      M1_ONESTEP(dir1);
      over+=ad2;
      if(over>=ad1) {
        over-=ad1;
        M2_ONESTEP(dir2);
      }
      delayMicroseconds(step_delay);
      if(readSwitches()) return;
    }
  } else {
    for(i=0;i<ad2;++i) {
      M2_ONESTEP(dir2);
      over+=ad1;
      if(over>=ad2) {
        over-=ad2;
        M1_ONESTEP(dir1);
      }
      delayMicroseconds(step_delay);
      if(readSwitches()) return;
    }
  }

  laststep1=l1;
  laststep2=l2;
  posx=x;
  posy=y;
  posz=z;
}


//------------------------------------------------------------------------------
static void line_safe(float x,float y,float z) {
  // split up long lines to make them straighter?
  float dx=x-posx;
  float dy=y-posy;

  float len=sqrt(dx*dx+dy*dy);

  if(len<=CM_PER_SEGMENT) {
    line(x,y,z);
    return;
  }

  // too long!
  long pieces=floor(len/CM_PER_SEGMENT);
  float x0=posx;
  float y0=posy;
  float z0=posz;
  float a;
  for(long j=1;j<pieces;++j) {
    a=(float)j/(float)pieces;

    line((x-x0)*a+x0,
         (y-y0)*a+y0,
         (z-z0)*a+z0);
  }
  line(x,y,z);
}


//------------------------------------------------------------------------------
// This method assumes the limits have already been checked.
// This method assumes the start and end radius match.
// This method assumes arcs are not >180 degrees (PI radians)
// cx/cy - center of circle
// x/y - end position
// dir - ARC_CW or ARC_CCW to control direction of arc
static void arc(float cx,float cy,float x,float y,float z,float dir) {
  // get radius
  float dx = posx - cx;
  float dy = posy - cy;
  float radius=sqrt(dx*dx+dy*dy);

  // find angle of arc (sweep)
  float angle1=atan3(dy,dx);
  float angle2=atan3(y-cy,x-cx);
  float theta=angle2-angle1;

  if(dir>0 && theta<0) angle2+=2*PI;
  else if(dir<0 && theta>0) angle1+=2*PI;

  theta=angle2-angle1;

  // get length of arc
  // float circ=PI*2.0*radius;
  // float len=theta*circ/(PI*2.0);
  // simplifies to
  float len = abs(theta) * radius;

  int i, segments = floor( len / CM_PER_SEGMENT );

  float nx, ny, nz, angle3, scale;

  for(i=0;i<segments;++i) {
    // interpolate around the arc
    scale = ((float)i)/((float)segments);

    angle3 = ( theta * scale ) + angle1;
    nx = cx + cos(angle3) * radius;
    ny = cy + sin(angle3) * radius;
    nz = ( z - posz ) * scale + posz;
    // send it to the planner
    line(nx,ny,nz);
  }

  line(x,y,z);
}


//------------------------------------------------------------------------------
// instantly move the virtual plotter position
// does not validate if the move is valid
static void teleport(float x,float y) {
  posx=x;
  posy=y;

  // @TODO: posz?
  long L1,L2;
  IK(posx,posy,L1,L2);
  laststep1=L1;
  laststep2=L2;
}


//------------------------------------------------------------------------------
static void help() {
  Serial.print(F("\n\nHELLO WORLD! I AM DRAWBOT #"));
  Serial.println(robot_uid);
  Serial.println(F("M100 - display this message"));
  Serial.println(F("M101 [Tx.xx] [Bx.xx] [Rx.xx] [Lx.xx]"));
  Serial.println(F("       - display/update board dimensions."));
  Serial.println(F("As well as the following G-codes (http://en.wikipedia.org/wiki/G-code):"));
  Serial.println(F("G00,G01,G02,G03,G04,G28,G90,G91,G92,M18,M114"));
}


//------------------------------------------------------------------------------
// find the current robot position and
static void FindHome() {
#ifdef USE_LIMIT_SWITCH
  Serial.println(F("Homing..."));

  if(readSwitches()) {
    Serial.println(F("** ERROR **"));
    Serial.println(F("Problem: Plotter is already touching switches."));
    Serial.println(F("Solution: Please unwind the strings a bit and try again."));
    return;
  }

  int home_step_delay=300;
  int safe_out=50;

  // reel in the left motor until contact is made.
  Serial.println(F("Find left..."));
  do {
    M1_STEP(1,M1_REEL_IN );
    M2_STEP(1,M2_REEL_OUT);
    delayMicroseconds(home_step_delay);
  } while(!readSwitches());
  laststep1=0;

  // back off so we don't get a false positive on the next motor
  int i;
  for(i=0;i<safe_out;++i) {
    M1_STEP(1,M1_REEL_OUT);
    delayMicroseconds(home_step_delay);
  }
  laststep1=safe_out;

  // reel in the right motor until contact is made
  Serial.println(F("Find right..."));
  do {
    M1_STEP(1,M1_REEL_OUT);
    M2_STEP(1,M2_REEL_IN );
    delay(step_delay);
    laststep1++;
  } while(!readSwitches());
  laststep2=0;

  // back off so we don't get a false positive that kills line()
  for(i=0;i<safe_out;++i) {
    M2_STEP(1,M2_REEL_OUT);
    delay(step_delay);
  }
  laststep2=safe_out;

  Serial.println(F("Centering..."));
  line(0,0,posz);
#endif // USE_LIMIT_SWITCH
}


//------------------------------------------------------------------------------
static void where() {
  Serial.print(F("X"));
  Serial.print(posx);
  Serial.print(F(" Y"));
  Serial.print(posy);
  Serial.print(F(" Z"));
  Serial.print(posz);
  printFeedRate();
  Serial.print(F("\n"));
}


//------------------------------------------------------------------------------
static void printConfig() {
  Serial.print(m1d);              Serial.print(F("="));
  Serial.print(limit_top);        Serial.print(F(","));
  Serial.print(limit_left);       Serial.print(F("\n"));
  Serial.print(m2d);              Serial.print(F("="));
  Serial.print(limit_top);        Serial.print(F(","));
  Serial.print(limit_right);      Serial.print(F("\n"));
  Serial.print(F("Bottom="));     Serial.println(limit_bottom);
  where();
}


//------------------------------------------------------------------------------
// from http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1234477290/3
void EEPROM_writeLong(int ee, long value) {
  byte* p = (byte*)(void*)&value;
  for (int i = 0; i < sizeof(value); i++)
  EEPROM.write(ee++, *p++);
}


//------------------------------------------------------------------------------
// from http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1234477290/3
float EEPROM_readLong(int ee) {
  long value = 0;
  byte* p = (byte*)(void*)&value;
  for (int i = 0; i < sizeof(value); i++)
  *p++ = EEPROM.read(ee++);
  return value;
}


//------------------------------------------------------------------------------
static void SaveUID() {
  EEPROM_writeLong(ADDR_UUID,(long)robot_uid);
}

//------------------------------------------------------------------------------
static void SaveSpoolDiameter() {
  EEPROM_writeLong(ADDR_SPOOL_DIA1,SPOOL_DIAMETER1*10000);
  EEPROM_writeLong(ADDR_SPOOL_DIA2,SPOOL_DIAMETER2*10000);
}


//------------------------------------------------------------------------------
static void LoadConfig() {
  char version_number=EEPROM.read(ADDR_VERSION);
  if(version_number<3 || version_number>EEPROM_VERSION) {
    // If not the current EEPROM_VERSION or the EEPROM_VERSION is sullied (i.e. unknown data)
    // Update the version number
    EEPROM.write(ADDR_VERSION,EEPROM_VERSION);
    // Update robot uuid
    robot_uid=0;
    SaveUID();
    // Update spool diameter variables
    SaveSpoolDiameter();
  }
  if(version_number==3) {
    // Retrieve Stored Configuration
    robot_uid=EEPROM_readLong(ADDR_UUID);
    adjustSpoolDiameter((float)EEPROM_readLong(ADDR_SPOOL_DIA1)/10000.0f,
                        (float)EEPROM_readLong(ADDR_SPOOL_DIA1)/10000.0f);   //3 decimal places of percision is enough
    // save the new data so the next load doesn't screw up one bobbin size
    SaveSpoolDiameter();
    // update the EEPROM version
    EEPROM.write(ADDR_VERSION,EEPROM_VERSION);
  } else if(version_number==EEPROM_VERSION) {
    // Retrieve Stored Configuration
    robot_uid=EEPROM_readLong(ADDR_UUID);
    adjustSpoolDiameter((float)EEPROM_readLong(ADDR_SPOOL_DIA1)/10000.0f,
                        (float)EEPROM_readLong(ADDR_SPOOL_DIA2)/10000.0f);   //3 decimal places of percision is enough
  } else {
    // Code should not get here if it does we should display some meaningful error message
    Serial.println(F("An Error Occurred during LoadConfig"));
  }
}


void disable_motors() {
#if MOTHERBOARD == 1
  m1.release();
  m2.release();
#endif
#if MOTHERBOARD == 2
  m1->release();
  m2->release();
#endif
}


void activate_motors() {
  M1_STEP(1,1);  M1_STEP(1,-1);
  M2_STEP(1,1);  M2_STEP(1,-1);
}


/**
 * Look for character /code/ in the buffer and read the float that immediately follows it.
 * @return the value found.  If nothing is found, /val/ is returned.
 * @input code the character to look for.
 * @input val the return value if /code/ is not found.
 **/
float parsenumber(char code,float val) {
  char *ptr=buffer;
  while(ptr && *ptr && ptr<buffer+sofar) {
    if(*ptr==code) {
      return atof(ptr+1);
    }
    ptr=strchr(ptr,' ')+1;
  }
  return val;
}




//------------------------------------------------------------------------------
void set_tool_offset(int axis,float x,float y,float z) {
  tool_offset[axis].x=x;
  tool_offset[axis].y=y;
  tool_offset[axis].z=z;
}


//------------------------------------------------------------------------------
Vector3 get_end_plus_offset() {
  return Vector3(tool_offset[current_tool].x + posx,
                 tool_offset[current_tool].y + posy,
                 tool_offset[current_tool].z + posz);
}


//------------------------------------------------------------------------------
void tool_change(int tool_id) {
  if(tool_id < 0) tool_id=0;
  if(tool_id > NUM_TOOLS) tool_id=NUM_TOOLS;
  current_tool=tool_id;
}


//------------------------------------------------------------------------------
void processConfig() {
  limit_top=parsenumber('T',limit_top);
  limit_bottom=parsenumber('B',limit_bottom);
  limit_right=parsenumber('R',limit_right);
  limit_left=parsenumber('L',limit_left);

  char gg=parsenumber('G',m1d);
  char hh=parsenumber('H',m2d);
  char i=parsenumber('I',0);
  char j=parsenumber('J',0);
  if(i!=0) {
    if(i>0) {
      M1_REEL_IN  = HIGH;
      M1_REEL_OUT = LOW;
    } else {
      M1_REEL_IN  = LOW;
      M1_REEL_OUT = HIGH;
    }
  }
  if(j!=0) {
    if(j>0) {
      M2_REEL_IN  = HIGH;
      M2_REEL_OUT = LOW;
    } else {
      M2_REEL_IN  = LOW;
      M2_REEL_OUT = HIGH;
    }
  }

  // @TODO: check t>b, r>l ?
  printConfig();

  teleport(0,0);
}


//------------------------------------------------------------------------------
static void processCommand() {
  // blank lines
  if(buffer[0]==';') return;

  long cmd;

  // is there a line number?
  cmd=parsenumber('N',-1);
  if(cmd!=-1 && buffer[0] == 'N') {  // line number must appear first on the line
    if( cmd != line_number ) {
      // Wrong line number error
      Serial.print(F("BADLINENUM "));
      Serial.println(line_number);
      return;
    }


    // is there a checksum?

    if(strchr(buffer,'*')!=0) {
      // Yes.  Is it valid?
      unsigned char checksum=0;
      int c=0;
      while(buffer[c]!='*' && c<MAX_BUF) checksum ^= buffer[c++];
      c++; // skip *
      unsigned char against = (unsigned char)strtod(buffer+c,NULL);
      if( checksum != against ) {
        Serial.print(F("BADCHECKSUM "));
        Serial.println(line_number);
        return;
      }
    } else {
      Serial.print(F("NOCHECKSUM "));
      Serial.println(line_number);
      return;
    }

    //confirm command recieved and OK
    Serial.print(F("OK "));
    Serial.println(line_number);
    line_number++;

  }

  if(!strncmp(buffer,"UID",3)) {
    robot_uid=atoi(strchr(buffer,' ')+1);
    SaveUID();
  }

  cmd=parsenumber('M',-1);
  switch(cmd) {
  case 18:  disable_motors();  break;
  case 17:  activate_motors();  break;
  case 100:  help();  break;
  case 101:  processConfig();  break;
  case 110:  line_number = parsenumber('N',line_number);  break;
  case 114:  where();  break;
  case 115:  Serial.println(line_number);
  }

  cmd=parsenumber('G',-1);
  switch(cmd) {
  case 0:
  case 1: {  // line
      Vector3 offset=get_end_plus_offset();
      setFeedRate(parsenumber('F',feed_rate));

      //fire solenoid if G01
      if (cmd == 1){
//        digitalWrite(SOLND_PIN, HIGH);
          s1.write( PEN_DOWN_ANGLE );
      }
      else {
//        digitalWrite(SOLND_PIN, LOW);
          s1.write( PEN_UP_ANGLE );
      }

      line_safe( parsenumber('X',(absolute_mode?offset.x:0)*10)*0.1 + (absolute_mode?0:offset.x),
                 parsenumber('Y',(absolute_mode?offset.y:0)*10)*0.1 + (absolute_mode?0:offset.y),
                 parsenumber('Z',(absolute_mode?offset.z:0)) + (absolute_mode?0:offset.z) );
//      digitalWrite(SOLND_PIN, LOW);

          s1.write( PEN_UP_ANGLE );
    break;
    }
  case 2:
  case 3: {  // arc
      Vector3 offset=get_end_plus_offset();
      setFeedRate(parsenumber('F',feed_rate));

      //fire solenoid
//      digitalWrite(SOLND_PIN, HIGH);

      arc(parsenumber('I',(absolute_mode?offset.x:0)*10)*0.1 + (absolute_mode?0:offset.x),
          parsenumber('J',(absolute_mode?offset.y:0)*10)*0.1 + (absolute_mode?0:offset.y),
          parsenumber('X',(absolute_mode?offset.x:0)*10)*0.1 + (absolute_mode?0:offset.x),
          parsenumber('Y',(absolute_mode?offset.y:0)*10)*0.1 + (absolute_mode?0:offset.y),
          parsenumber('Z',(absolute_mode?offset.z:0)) + (absolute_mode?0:offset.z),
          (cmd==2) ? -1 : 1);

      //turn off solenoid
//      digitalWrite(SOLND_PIN, LOW);

      break;
    }
  case 4:  // dwell
    pause(parsenumber('S',0) + parsenumber('P',0)*1000.0f);
    break;
  case 20: // inches -> cm
    mode_scale=2.54f;  // inches -> cm
    strcpy(mode_name,"in");
    printFeedRate();
    break;
  case 21:
    mode_scale=0.1;  // mm -> cm
    strcpy(mode_name,"mm");
    printFeedRate();
    break;
  case 28:  FindHome();  break;
  case 54:
  case 55:
  case 56:
  case 57:
  case 58:
  case 59: {  // 54-59 tool offsets
    int tool_id=cmd-54;
    set_tool_offset(tool_id,parsenumber('X',tool_offset[tool_id].x),
                            parsenumber('Y',tool_offset[tool_id].y),
                            parsenumber('Z',tool_offset[tool_id].z));
    break;
    }
  case 90:  absolute_mode=1;  break;  // absolute mode
  case 91:  absolute_mode=0;  break;  // relative mode
  case 92: {  // set position (teleport)
      Vector3 offset = get_end_plus_offset();
      teleport( parsenumber('X',offset.x),
                         parsenumber('Y',offset.y)
                         //,
                         //parsenumber('Z',offset.z)
                         );
      break;
    }
  case 93: {
//    digitalWrite(SOLND_PIN, HIGH);
//    break;
  }
  case 94: {
//    digitalWrite(SOLND_PIN, LOW);
//    break;
  }
  }

  cmd=parsenumber('D',-1);
  switch(cmd) {
  case 0: {
      // move one motor
      char *ptr=strchr(buffer,' ')+1;
      int amount = atoi(ptr+1);
      int i, dir;
      if(*ptr == m1d) {
        dir = amount < 0 ? M1_REEL_IN : M1_REEL_OUT;
        amount=abs(amount);
        for(i=0;i<amount;++i) {  M1_STEP(1,dir);  delay(2);  }
      } else if(*ptr == m2d) {
        dir = amount < 0 ? M2_REEL_IN : M2_REEL_OUT;
        amount = abs(amount);
        for(i=0;i<amount;++i) {  M2_STEP(1,dir);  delay(2);  }
      }
    }
    break;
  case 1: {
      // adjust spool diameters
      float amountL=parsenumber('L',SPOOL_DIAMETER1);
      float amountR=parsenumber('R',SPOOL_DIAMETER2);

      float tps1=THREADPERSTEP1;
      float tps2=THREADPERSTEP2;
      adjustSpoolDiameter(amountL,amountR);
      if(THREADPERSTEP1 != tps1 || THREADPERSTEP2 != tps2) {
        // Update EEPROM
        SaveSpoolDiameter();
      }
    }
    break;
  case 2:
    Serial.print('L');  Serial.print(SPOOL_DIAMETER1);
    Serial.print(F(" R"));   Serial.println(SPOOL_DIAMETER2);
    break;
  }
}


//------------------------------------------------------------------------------
/**
 * prepares the input buffer to receive a new message and tells the serial connected device it is ready for more.
 */
void ready() {
  sofar=0;  // clear input buffer
  Serial.print(F("\n> "));  // signal ready to receive input
  last_cmd_time = millis();
}


//------------------------------------------------------------------------------
void tools_setup() {
  for(int i=0;i<NUM_TOOLS;++i) {
    set_tool_offset(i,0,0,0);
  }
}


//------------------------------------------------------------------------------
void setup() {
  LoadConfig();

  // initialize the read buffer
  sofar=0;
  // start communications
  Serial.begin(BAUD);
  Serial.print(F("\n\nHELLO WORLD! I AM DRAWBOT #"));
  Serial.println(robot_uid);

#ifdef USE_SD_CARD
  SD.begin();
  SD_ListFiles();
#endif

#if MOTHERBOARD == 2
  // start the shield
  AFMS0.begin();
  m1 = AFMS0.getStepper(STEPS_PER_TURN, M2_PIN);
  m2 = AFMS0.getStepper(STEPS_PER_TURN, M1_PIN);
#endif

  // initialize the scale
  strcpy(mode_name,"mm");
  mode_scale=0.1;

  setFeedRate(65.0);  // *30 because i also /2

  // servo should be on SER1, pin 10.
  s1.attach(SERVO_PIN);

//  myservo.attach(9);

  //setup Solenoid firing pin
//  pinMode(SOLND_PIN, OUTPUT);

  // turn on the pull up resistor
  digitalWrite(L_PIN,HIGH);
  digitalWrite(R_PIN,HIGH);

  tools_setup();

  // initialize the plotter position.
  teleport(0,0);
  velx=0;
  velx=0;
  setPenAngle(PEN_UP_ANGLE);

  // test Micro
  digitalWrite(9, HIGH);
  delay(50);
  digitalWrite(9, LOW);

  // display the help at startup.
  help();
  ready();
}


//------------------------------------------------------------------------------
// See: http://www.marginallyclever.com/2011/10/controlling-your-arduino-through-the-serial-monitor/
void Serial_listen() {
  // listen for serial commands
  while(Serial.available() > 0) {
    char c = Serial.read();
    if(sofar<MAX_BUF) buffer[sofar++]=c;
    if(c=='\n' || c=='\r') {
      buffer[sofar]=0;

#if VERBOSE > 0
      // echo confirmation
      Serial.println(buffer);
#endif

      // do something with the command
      processCommand();
      ready();
      break;
    }
  }
}


//------------------------------------------------------------------------------
void loop() {
  Serial_listen();

  // The PC will wait forever for the ready signal.
  // if Arduino hasn't received a new instruction in a while, send ready() again
  // just in case USB garbled ready and each half is waiting on the other.
  if( (millis() - last_cmd_time) > TIMEOUT_OK ) {
    ready();
  }
}
