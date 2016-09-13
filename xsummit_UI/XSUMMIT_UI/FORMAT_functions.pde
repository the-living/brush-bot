//------------------------------------------------------------------------------
// FORMATTING FUNCTIONS
//------------------------------------------------------------------------------
// Functions for formatting and parsing values

// FLOAT FORMAT
//----------------------------------------
// Returns a given float with a specified
// number of decimal places
float floatFormat( float f, int digits ){
  return round(f * pow(10,digits)) / pow(10, digits);
}

// FLOAT FORMAT (FROM STRING)
//----------------------------------------
// Returns a given string as a float with
// a specified number of decimal places
float floatFormatS( String s, int digits ){
  return round( float(s) * pow(10,digits)) / pow(10, digits);
}

// PARSE NUMBER FROM STRING
//----------------------------------------
// Searches a string for an identifier code
// and returns associated value as a float
float parseNumber(String s, String C, float f) {
  int index = s.indexOf(C);

  if ( index == -1 ) {
    return f;
  }

  int endIndex = s.indexOf(" ", index);

  if ( endIndex == -1 ) {
    endIndex = s.length();
  }  

  String val = s.substring( index+1, endIndex );

  return float(val);
}

// PARSE STRING FROM STRING
//----------------------------------------
// Searches a string for an identifier code
// and returns associated value as a string
String parseString( String s, String C, String d) {
  int index = s.indexOf(C);

  if ( index == -1 ) {
    return d;
  }

  int endIndex = s.indexOf(" ", index);

  if ( endIndex == -1 ) {
    endIndex = s.length();
  }  

  String val = s.substring( index+1, endIndex );

  return val;
}