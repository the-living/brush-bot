//---------------------------------------------------------------------------
//
// ControlP5 UX Objects Behavior
//
//---------------------------------------------------------------------------

//CONTROLP5 INTERFACE CONTROLS
//Functions are handled via triggering "events"
void controlEvent( ControlEvent theEvent ) {

  if ( theEvent.isController() ) {

    //MANUAL GCODE ENTRY
    //--------------------------------------------------------------------------
    if ( theEvent.getName().equals("cmd_entry") ) {

      //pull value from text entry box
      String cmd = cP5.get(Textfield.class, "cmd_entry").getText();
      GB.write( cmd );
    }

    //RESET ORIGIN
    //--------------------------------------------------------------------------
    if ( theEvent.getName().equals("teleport") ) {
      String cmd = gcodeTeleportOrigin();
      GB.write( cmd );
      //reset position VARIABLES
      posx = 0;
      posy = 0;
    }

    //RUN TEST PATTERN
    //--------------------------------------------------------------------------
    if ( theEvent.getName().equals("test_pattern") ) {

      String lines[] = loadStrings("hallo.txt");
      for (int i = 0; i < lines.length; i++) {
        GB.write( lines[i] );
      }
      
    }



    // JOGGING
    //--------------------------------------------------------------------------
    //FORWARD JOG
    if ( theEvent.getName().equals("jog_forward") ) {
      //update motor selection array
      motors[0] = cP5.get( Toggle.class, "m1").getState();
      motors[1] = cP5.get( Toggle.class, "m2").getState();
      motors[2] = cP5.get( Toggle.class, "m3").getState();
      motors[3] = cP5.get( Toggle.class, "m4").getState();

      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeMotorForward( i + 1, 1 );
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

      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeMotorBackward( i + 1, 1 );
          GB.write( cmd );
        }
      }
    }

    //FORWARD JOG
    if ( theEvent.getName().equals("jog_forward_ff") ) {
      //update motor selection array
      motors[0] = cP5.get( Toggle.class, "m1").getState();
      motors[1] = cP5.get( Toggle.class, "m2").getState();
      motors[2] = cP5.get( Toggle.class, "m3").getState();
      motors[3] = cP5.get( Toggle.class, "m4").getState();

      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeMotorForward( i + 1, 5 );
          GB.write( cmd );
        }
      }
    }

    //BACKWARD JOG
    if ( theEvent.getName().equals("jog_backward_ff") ) {
      //update motor selection array
      motors[0] = cP5.get( Toggle.class, "m1").getState();
      motors[1] = cP5.get( Toggle.class, "m2").getState();
      motors[2] = cP5.get( Toggle.class, "m3").getState();
      motors[3] = cP5.get( Toggle.class, "m4").getState();

      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeMotorBackward( i + 1, 5 );
          GB.write( cmd );
        }
      }
    }


    // MOTOR ENABLING
    //--------------------------------------------------------------------------
    //DISENGAGE MOTOR(S)
    if ( theEvent.getName().equals("step_f") ) {
      //update motor selection array
      motors[0] = cP5.get( Toggle.class, "m1").getState();
      motors[1] = cP5.get( Toggle.class, "m2").getState();
      motors[2] = cP5.get( Toggle.class, "m3").getState();
      motors[3] = cP5.get( Toggle.class, "m4").getState();

      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeStepForward( i + 1 );
          GB.write( cmd );
        }
      }
    }

    //ENGAGE MOTOR(S)
    if ( theEvent.getName().equals("step_b") ) {
      //update motor selection array
      motors[0] = cP5.get( Toggle.class, "m1").getState();
      motors[1] = cP5.get( Toggle.class, "m2").getState();
      motors[2] = cP5.get( Toggle.class, "m3").getState();
      motors[3] = cP5.get( Toggle.class, "m4").getState();

      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeStepBackward( i + 1 );
          GB.write( cmd );
        }
      }
    }

    // SPRAYER COMMANDS
    //--------------------------------------------------------------------------
    // ENABLE SPRAYER
    if ( theEvent.getName().equals("spray_on") ) {
      String cmd = gcodeSprayOn();
      GB.write( cmd );
    }
    // DISABLE SPRAYER
    if ( theEvent.getName().equals("spray_off") ) {
      String cmd = gcodeSprayOff();
      GB.write( cmd );
    }
    
    // SPEED COMMANDS
    //--------------------------------------------------------------------------
    // FAST MODE
    if ( theEvent.getName().equals("fast_mode") ) {
      String cmd;
      
      if( theEvent.controller().getValue()==1 ){
        cmd = gcodeSpeedSetting( fast_speed );
      } else{
        cmd = gcodeSpeedSetting( draw_speed );
      }
      
      GB.write( cmd );
    }

    // AXIAL MOVE COMMANDS
    //--------------------------------------------------------------------------
    // GO HOME
    if ( theEvent.getName().equals("go_home") ) {
      posx = 0;
      posy = 0;
      String cmd = gcodeLine(posx, posy, false);
      GB.write( cmd );
    }
    
    // X+100 MOVE
    if ( theEvent.getName().equals("x_100") ) {
      posx += 100;
      String cmd = gcodeLine(posx, posy, false);
      GB.write( cmd );
    }

    // X+10 MOVE
    if ( theEvent.getName().equals("x_10") ) {
      posx += 10;
      String cmd = gcodeLine(posx, posy, false);
      GB.write( cmd );
    }

    // X-100 MOVE
    if ( theEvent.getName().equals("x_-100") ) {
      posx -= 100;
      String cmd = gcodeLine(posx, posy, false);
      GB.write( cmd );
    }

    // X-10 MOVE
    if ( theEvent.getName().equals("x_-10") ) {
      posx -= 10;
      String cmd = gcodeLine(posx, posy, false);
      GB.write( cmd );
    }
    // Y+100 MOVE
    if ( theEvent.getName().equals("y_100") ) {
      posy += 100;
      String cmd = gcodeLine(posx, posy, false);
      GB.write( cmd );
    }

    // Y+10 MOVE
    if ( theEvent.getName().equals("y_10") ) {
      posy += 10;
      String cmd = gcodeLine(posx, posy, false);
      GB.write( cmd );
    }

    // Y-100 MOVE
    if ( theEvent.getName().equals("y_-100") ) {
      posy -= 100;
      //generate G00 command to position X+100
      String cmd = gcodeLine(posx, posy, false);
      GB.write( cmd );
    }

    // Y-10 MOVE
    if ( theEvent.getName().equals("y_-10") ) {
      posy -= 10;
      //generate G00 command to position X+100
      String cmd = gcodeLine(posx, posy, false);
      GB.write( cmd );
    }
  }
}