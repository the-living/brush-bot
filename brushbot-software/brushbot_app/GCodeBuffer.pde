//GCODE BUFFER CLASS
//ArrayList object containing GCODE commands to be
//passed to Arduino. Functions allow for commands to
//be added and extracted on a FIFO (First in, First out) basis

class GCodeBuffer {
  
  ArrayList<String> GCode = new ArrayList<String>();
  
  //Initializer
  GCodeBuffer(){
    
  }
  
  //WRITE function
  //for adding GCode command to buffer
  void write( String code ){
    String gcode;
    
    //***NOTE***//
    //Line numbers and checksums have been disabled for
    //single-pass testing
    
    //Generate Line Number
    //String ln = "N" + str( GCode.size());
    //gcode = ln + " " + code;
    
    //String cs = generateChecksum(gcode);
    //gcode += cs;
    
    gcode = code + "\n";
    
    GCode.add(gcode);
  }
  
  //SEND NEXT function
  //Returns next available command as String
  //on FIFO basis and removes it from the buffer
  String sendNext () {
    String r = GCode.get(0);
    GCode.remove(0);
    
    return r;
  }
  
  //GET END function
  //Returns whether buffer is empty
  boolean getEnd() {
    return GCode.size() <= 0;
  }
  
  //FLUSH BUFFER function
  //Clears buffer
  void flushBuffer(){
    for (int i = GCode.size() - 1; i >= 0; i--){
      GCode.remove(i);
    }
  }
  
  //SIZE function
  //Returns length of Buffer
  int size(){
    return GCode.size();
  }

}