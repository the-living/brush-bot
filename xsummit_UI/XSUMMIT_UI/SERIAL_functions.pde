
//------------------------------------------------------------------------------
// SERIAL FUNCTIONS
//------------------------------------------------------------------------------
// Functions for communicating over the serial port

// MONITOR CONNECTIONS
//----------------------------------------
// Checks connection status
void monitorConnection() {
  if (!connected) serialConnect();
  else serialRun();
}

// SERIAL CONNECT
//----------------------------------------
// Searches through available serial ports
// and connects if one is available
void serialConnect() {
  String[] ports = Serial.list();

  if ( ports.length > 0 ) {
    port = ports[0];
    myPort = new Serial(this, port, 115200);
    connected = true;
  } else {
    connected = false;
  }
}


// SERIAL RUN
//----------------------------------------
// Issues commands to serial port if port is
// available and if there is data to send
void serialRun() {

  if (myPort.available() > 0) {
    val = myPort.readString();

    //Arduino firmware signals readiness with a ">"
    if (val.equals("\n> ") ) {

      lastSent="";

      //Check if paused
      if (!paused) {
        if ( interrupt.size() > 0 ) {
          String s = interrupt.sendNext();
          myPort.write(s);
          println("sent: " + s);
          lastSent = s;
        }
        //check if commands are available
        else if (running && GB.size() > 0 ) {
          String s = GB.sendNext();
          myPort.write(s);
          //Echo command to debug panel
          println("sent: " + s);
          lastSent = s;
        } else {
          lineNum = "";
          running = false;
        }
      } else {
        //check if interrupt commands are available
        if ( interrupt.size() > 0 ) {
          String s = interrupt.sendNext();
          myPort.write(s);
          lastSent = s;
        }
      }
    } else {
      println( "recieved: " + val );

      if (val.length() > 0 && val != " ") {
        String[] temp = split(val, "\n");
        lastVal.clear();
        for (int i = 0; i < temp.length; i++) {
          if (temp[i].length() > 1) {
            lastVal.append(temp[i]);
            println( temp[i] );
            if (report && temp[i].contains("M1: ")) {
              
              extractPositions(temp[i]);
            }
          }
        }
      }
    }
  }
}

//EXTRACT POSITIONS
//----------------------------------------
// Extract motor step positions
void extractPositions(String msg) {
  m1 = int( parseNumber(msg, "M1: ", m1 ) );
  m2 = int( parseNumber(msg, "M2: ", m2 ) );
  m3 = int( parseNumber(msg, "M3: ", m3 ) );
  m4 = int( parseNumber(msg, "M4: ", m4 ) );
}