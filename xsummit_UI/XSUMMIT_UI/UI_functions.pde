
//------------------------------------------------------------------------------
// UX FUNCTIONS
//------------------------------------------------------------------------------
// Functions that control UX behavior

// CONTROLP5 INTERFACE CONTROLS
// - - - - - - - - - - - - - - - - - - - - - - - - - -
// Functions are handled via triggering "events"
void controlEvent( ControlEvent theEvent ) {
  if ( theEvent.isController() ) {

    String eventName = theEvent.getName();

    switch( eventName ) {

      //PREVIEW AREA COMMANDS
    case "report":
      report = !report;
      break;

      //MANUAL CONTROL COMMANDS
    case "y+100":
      relativeMove(0, 100);
      break;
    case "y+10":
      relativeMove(0, 10);
      break;
    case "y-10":
      relativeMove(0, -10);
      break;
    case "y-100":
      relativeMove(0, -100);
      break;
    case "x+100":
      relativeMove(100, 0);
      break;
    case "x+10":
      relativeMove(10, 0);
      break;
    case "x-10":
      relativeMove(-10, 0);
      break;
    case "x-100":
      relativeMove(-100, 0);
      break;
    case "home":
      relativeMove(-posx, -posy);
      break;
    case "reelout-x1":
      spool(-1);
      break;
    case "reelout-x2":
      spool(-5);
      break;
    case "reelin-x1":
      spool(1);
      break;
    case "reelin-x2":
      spool(5);
      break;
    case "sprayOff":
      spraying = false;
      interrupt.write( gcodeSprayOff() );
      break;
    case "sprayOn":
      spraying = true;
      interrupt.write( gcodeSprayOn() );
      break;
    case "origin":
      interrupt.write( gcodeTeleportTo(0, 0) );
      break;
    case "cmdEntry":
      manualEntry();
      break;
    case "run-test":
      testPattern();
      break;
    default:
      break;
    }
  }
}

// MANUAL ENTRY
// - - - - - - - - - - - - - - - - - - - - - - - - - -
// Issues manually entered command to run immediately
void manualEntry() {
  String cmd = cP5.get(Textfield.class, "cmdEntry").getText();
  interrupt.write( cmd );
}

// RELATIVE MOVE
// - - - - - - - - - - - - - - - - - - - - - - - - - -
// Generates a move command relative to current position
// using directional move buttons
void relativeMove( float x, float y ) {
  posx += x;
  posy += y;
  String code = gcodeLine( posx, posy, false );
  interrupt.write( code );
}

// SPOOL IN/OUT
// - - - - - - - - - - - - - - - - - - - - - - - - - -
// Sends relative move command to one or more motors
void spool( int multiplier ) {
  for(int i = 0; i < 4; i++){
    String label = "m" + str(i+1);
    motors[i] = cP5.get(Toggle.class, label).getState();
    println(label + ": " + motors[i] );
  }
  int a = 0;
  int b = 0;
  int c = 0;
  int d = 0;
  if(motors[0]) a = multiplier * spoolStep;
  if(motors[1]) b = multiplier * spoolStep;
  if(motors[2]) c = multiplier * spoolStep;
  if(motors[3]) d = multiplier * spoolStep;

  //StringList codes = motorSpool(a,b,c,d);
  StringList codes = oldSpool(a,b,c,d);

  for(int i = 0; i < codes.size(); i++){
    interrupt.write( codes.get(i) );
  }

}

// TEST PATTERN
// - - - - - - - - - - - - - - - - - - - - - - - - - -
// Custom pattern for machine testing
void testPattern() {
  int repeats = 101;
  int dist = 5000;
  int selected = 0;
  
  for(int i = 0; i < 4; i++){
    String label = "m" + str(i+1);
    motors[i] = cP5.get(Toggle.class, label).getState();
    println(label + ": " + motors[i] );
  }
  
  if(motors[0]) selected = 1;
  else if(motors[1]) selected = 2;
  else if(motors[2]) selected = 3;
  else if(motors[3]) selected = 4;
  else{
    println( "NO MOTOR SELECTED" );
    return;
  }
  int dir = 1;
  int mult = 2;
  int total = 0;
  for( int i = 0; i < repeats; i++ ){
    if( i == 0 || i == repeats-1 ){
      mult = 1;
    } else {
      mult = 2;
    }
    total += mult*dist;
    String code = "M"+str(selected*10)+" S"+str(dir*mult*dist);
    interrupt.write(code);
    
    dir *= -1;
  }
  println("TOTAL STEPS: " + total);
}
  
  

// RELABEL BUTTON
// - - - - - - - - - - - - - - - - - - - - - - - - - -
// Allows relabeling of button and changing color
void relabelButton(Bang button, String newlabel){
  button.getCaptionLabel().setText(newlabel);
}

// RECOLOR BUTTON
// - - - - - - - - - - - - - - - - - - - - - - - - - -
// Allows recoloring of button default & active (hover) colors
void recolorButton(Bang button, color c1, color c2){
  button.setColorForeground(c1)
  .setColorActive(c2);
}