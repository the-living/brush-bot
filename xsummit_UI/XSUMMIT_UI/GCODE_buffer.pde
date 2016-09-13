
//------------------------------------------------------------------------------
// GCODE BUFFER CLASS
//------------------------------------------------------------------------------
// Object for storing and retrieving GCODE commands to pass to
// Arduino. Commands are added and removed on a FIFO basis

class GCODEbuffer {

  StringList GCode = new StringList();
  String time_estimate;

  GCODEbuffer() {
    //initialize as blank object
  }

  //WRITE
  //Write a command to the buffer
  void write( String code ) {
    String gcode;

    gcode = code;

    GCode.append( gcode );
    
    if( report ){
      GCode.append( reportPosition() );
    }
  }

  //SEND NEXT
  //Returns next available command to pass to Arduino
  String sendNext() {
    String r = GCode.get(0);
    GCode.remove(0);

    //parse metadata
    lineNum = parseString(r, "N", lineNum);

    //extract final position of command
    posx = parseNumber(r, "X", posx);
    posy = parseNumber(r, "Y", posy);

    int startIndex = 0;
    if ( r.charAt(0) == 'N' ) startIndex = r.indexOf(" ")+1;
    int endIndex = r.indexOf(" *");
    if ( endIndex == -1 ) endIndex = r.length();
    return r.substring(startIndex, endIndex) + "\n";
  }

  //GET END
  //Checks if buffer is empty
  boolean getEnd() {
    return GCode.size() <= 0;
  }
  
  //GET ITEM
  String get(int i){
    return GCode.get(i);
  }
  
  //DUPLICATE BUFFER
  //Clears all data in buffer
  void copyBuffer(GCODEbuffer g) {
    flushBuffer();
    for ( int i = 0; i < g.size(); i++ ) {
      write( g.get(i) );
    }
  }
  
  //FLUSH BUFFER
  //Clears all data in buffer
  void flushBuffer() {
    for ( int i = GCode.size()-1; i >= 0; i-- ) {
      GCode.remove(i);
    }
  }

  //SIZE
  //Returns size of GCode Buffer
  int size() {
    return GCode.size();
  }

}