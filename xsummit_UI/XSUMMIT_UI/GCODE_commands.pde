//------------------------------------------------------------------------------
// GCODE Commands
//------------------------------------------------------------------------------
// Functions that generate GCODE commands

// G00/G01 - LINE COMMAND
String gcodeLine(float x, float y, boolean spray){
  if( spray ) return "G01 X"+str(x) + " Y"+str(y);
  else return "G00 X"+str(x) + " Y"+str(y);
}

// G02/G03 - ARC COMMANDS
String gcodeArc(float cx, float cy, float x, float y, boolean dir){
  //clockwise = 2 ... counterclockwise = 3
  if( dir ) return "G02 I"+str(cx) + " J"+str(cy) + " X"+str(x) + " Y"+str(y);
  else return "G03 I" + str(cx) + " J" + str(cy) + " X" + str(x) + " Y" + str(y);
}

// G04/G05 - PAUSE/DWELL COMMAND
String gcodeDwell( float time, boolean spray ){
  if(spray){
    return "G05 P" + str(time);
  } else {
    return "G04 P" + str(time);
  }
}

//M9 SPOOL
StringList motorSpool( int a, int b, int c, int d ){
  return new StringList( "M9 A"+a+" B"+b+" C"+c+" D"+d );
}

//M10-20-30-40
StringList oldSpool( int a, int b, int c, int d ){
  StringList codes = new StringList();
  if( a != 0 ) codes.append("M10 S"+a);
  if( b != 0 ) codes.append("M20 S"+b);
  if( c != 0 ) codes.append("M30 S"+c);
  if( d != 0 ) codes.append("M40 S"+d);

  return codes;
}

//M50 SPRAY ON
String gcodeSprayOn(){
  return "M50";
}

//M51 SPRAY OFF
String gcodeSprayOff(){
  return "M51";
}

String gcodeTeleportTo( float x, float y ){
  return "M100 X" + str(x) + " Y" + str(y);
}

String reportPosition(){
  return "D30";
}