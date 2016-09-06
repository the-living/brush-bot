//G00/G01 - LINE COMMAND
String gcodeLine(float x, float y, boolean spray){
  if( spray ) return "G01 X" + str(x) + " Y" + str(y);
  else return "G00 X" + str(x) + " Y" + str(y);
}

//G02/G03 - ARC COMMANDS
String gcodeArc(float cx, float cy, float x, float y, boolean dir){
  //clockwise
  if( dir ) return "G02 I" + str(cx) + " J" + str(cy) + " X" + str(x) + " Y" + str(y);
  else return "G03 I" + str(cx) + " J" + str(cy) + " X" + str(x) + " Y" + str(y);
}

//G04 - PAUSE COMMAND
String gcodePause( int time ){
  return "G04 P" + str(time);
}

//M00 - DISABLE ALL MOTORS COMMAND
String gcodeAllOff(){
  return "M00";
}

//M00 - ENABLE ALL MOTORS COMMAND
String gcodeAllOn(){
  return "M01";
}

//M10-M20-M30-M40 FORWARD JOG MOTOR
String gcodeMotorForward( int motor, int dist ){
  switch( motor ){
    case 1: return "M10 S" + dist; //Motor 1
    case 2: return "M20 S" + dist; //Motor 2
    case 3: return "M30 S" + dist; //Motor 3
    case 4: return "M40 S" + dist; //Motor 4
    default: return "";
  }
}

//M11-M21-M31-M41 BACKWARD JOG MOTOR
String gcodeMotorBackward( int motor, int dist ){
  switch( motor ){
    case 1: return "M11 S" + dist; //Motor 1
    case 2: return "M21 S" + dist; //Motor 2
    case 3: return "M31 S" + dist; //Motor 3
    case 4: return "M41 S" + dist; //Motor 4
    default: return "";
  }
}

//M15-M25-M35-M45 STEP MOTOR +1
String gcodeStepForward( int motor ){
  switch( motor ){
    case 1: return "M15"; //Motor 1
    case 2: return "M25"; //Motor 2
    case 3: return "M35"; //Motor 3
    case 4: return "M45"; //Motor 4
    default: return "";
  }
}

//M16-M26-M36-M46 ENABLE MOTOR
String gcodeStepBackward( int motor ){
  switch( motor ){
    case 1: return "M16"; //Motor 1
    case 2: return "M26"; //Motor 2
    case 3: return "M36"; //Motor 3
    case 4: return "M46"; //Motor 4
    default: return "";
  }
}

//M50 SPRAYER ON
String gcodeSprayOn(){
  return "M50";
}

//M51 SPRAYER OFF
String gcodeSprayOff(){
  return "M51";
}

//M100 Teleport
String gcodeTeleportOrigin(){
  return "M100";
}

String gcodeTeleportTo( float x, float y ){
  return "M100 X" + str(x) + " Y" + str(y);
}

String gcodeSpeedSetting( float s ){
  return "D10 S" + str(s);
}