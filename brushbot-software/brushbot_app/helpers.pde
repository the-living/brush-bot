//CHECKSUM GENERATOR
//Used to ensure no data loss in transfer
//when issuing multiple commands
protected String generateChecksum(String line) {
  byte checksum=0;
  for ( int i=0; i<line.length (); ++i ) {
    checksum ^= line.charAt(i);
  }
  return "*"+((int)checksum);
}