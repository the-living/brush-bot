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

      //generate spiral test pattern

      int factor = 10;
      int x = 0;
      int y = 0;

      for (int i = 0; i < 80; i++) {
        if (i%2 == 0) {
          //flip sign
          x *= -1;
        } else {
          y *= -1;
        }

        if (i%4 == 0) {
          //add factor
          x += factor;
        }
        if ((i-1)%4 == 0) {
          y -= factor;
        }

        String cmd = gcodeLine(x, y, true);
        GB.write( cmd );
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

      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeMotorBackward( i + 1 );
          GB.write( cmd );
        }
      }
    }


    // MOTOR ENABLING
    //--------------------------------------------------------------------------
    //DISENGAGE MOTOR(S)
    if ( theEvent.getName().equals("disable") ) {
      //update motor selection array
      motors[0] = cP5.get( Toggle.class, "m1").getState();
      motors[1] = cP5.get( Toggle.class, "m2").getState();
      motors[2] = cP5.get( Toggle.class, "m3").getState();
      motors[3] = cP5.get( Toggle.class, "m4").getState();

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

      for ( int i = 0; i < motors.length; i++ ) {
        if ( motors[i] ) {
          String cmd = gcodeMotorOn( i + 1 );
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

    // AXIAL MOVE COMMANDS
    //--------------------------------------------------------------------------
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

