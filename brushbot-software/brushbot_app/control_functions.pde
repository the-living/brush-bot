//CONTROLP5 INTERFACE CONTROLS
//Functions are handled via triggering "events"
void controlEvent( ControlEvent theEvent ) {

  if ( theEvent.isController() ) {
    
    //MANUAL GCODE ENTRY
    if ( theEvent.getName().equals("cmd_entry") ) {
      
      //pull value from text entry box
      String cmd = cP5.get(Textfield.class, "cmd_entry").getText();
      GB.write( cmd );
    }
    
    //FORWARD JOG
    if ( theEvent.getName().equals("jog_forward") ) {
      //update motor selection array
      motors[0] = cP5.get( Toggle.class, "m1").getState();
      motors[1] = cP5.get( Toggle.class, "m2").getState();
      motors[2] = cP5.get( Toggle.class, "m3").getState();
      motors[3] = cP5.get( Toggle.class, "m4").getState();
      
      //println( motors );
      
      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeMotorForward( i + 1 );
          GB.write( cmd );
        }
      }
    }
    
    //BACKWARD JOG
    if ( theEvent.getName().equals("jog_backward") ) {
      //update motor selection array
      motors[0] = cP5.get( Toggle.class, "m1").getState();
      motors[1] = cP5.get( Toggle.class, "m2").getState();
      motors[2] = cP5.get( Toggle.class, "m3").getState();
      motors[3] = cP5.get( Toggle.class, "m4").getState();
      
      //println( motors );
      
      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeMotorBackward( i + 1 );
          GB.write( cmd );
        }
      }
    }
    
    //DISENGAGE MOTOR(S)
    if ( theEvent.getName().equals("disable") ) {
      //update motor selection array
      motors[0] = cP5.get( Toggle.class, "m1").getState();
      motors[1] = cP5.get( Toggle.class, "m2").getState();
      motors[2] = cP5.get( Toggle.class, "m3").getState();
      motors[3] = cP5.get( Toggle.class, "m4").getState();
      
      //println( motors );
      
      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeMotorOff( i + 1 );
          GB.write( cmd );
        }
      }
    }
    
    //ENGAGE MOTOR(S)
    if ( theEvent.getName().equals("enable") ) {
      //update motor selection array
      motors[0] = cP5.get( Toggle.class, "m1").getState();
      motors[1] = cP5.get( Toggle.class, "m2").getState();
      motors[2] = cP5.get( Toggle.class, "m3").getState();
      motors[3] = cP5.get( Toggle.class, "m4").getState();
      
      //println( motors );

      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeMotorOn( i + 1 );
          GB.write( cmd );
        }
      }
    }
  }
}