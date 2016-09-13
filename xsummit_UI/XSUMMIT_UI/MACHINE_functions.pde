//------------------------------------------------------------------------------
// MACHINE FUNCTIONS
//------------------------------------------------------------------------------
// Functions for emulating or interfacing with robot

//ATAN3
//----------------------------------------
// Return angle from a given dx/dy
float atan3( float dy, float dx ){
  float a = atan2(dy,dx);
  if( a < 0 ) a += TWO_PI;
  return a;
}