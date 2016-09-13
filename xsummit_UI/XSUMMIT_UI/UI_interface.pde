//------------------------------------------------------------------------------
// UX Interface
//------------------------------------------------------------------------------
// Functions for generating US


//DISPLAY UI
//----------------------------------------
//Draws user non-cP5 interface elements
void displayUI() {
  //background(white);

  //SETUP PREVIEW AREA
  //canvas area
  noStroke();
  fill(black);
  rect(600, 0, 900, 900);
  fill(grey);
  rect(650,50,800,800);
  //draw grid
  noFill();
  stroke(white);
  strokeWeight(1);
  for (float x = 0; x < 400; x+=33.333) {
    line(origin.x + x, origin.y-400, origin.x + x, origin.y+400);
    line(origin.x - x, origin.y-400, origin.x - x, origin.y+400);
  }
  for (float y = 0; y < 400; y+=33.333) {
    line(origin.x - 400, origin.y + y, origin.x + 400, origin.y + y);
    line(origin.x - 400, origin.y - y, origin.x + 400, origin.y - y);
  }
  strokeWeight(3);
  line(origin.x, origin.y - 400, origin.x, origin.y + 400);
  line(origin.x - 400, origin.y, origin.x + 400, origin.y);
  //frame canvas
  strokeWeight(3);
  rect(origin.x - 400, origin.y - 400, 800, 800);
  
  //MANUAL CONTROLS AREA
  //controller area
  noStroke();
  fill(grey);
  rect(0,0,600,900);
  fill(black);
  textFont(font24,24);
  textAlign(LEFT);
  text("MANUAL CONTROLS", 15, 30);
  //console area
  fill(black);
  rect(0,375,590,525);
  noFill();
  stroke(charcoal);
  strokeWeight(1);
  rect(15,40,320,320);
  
}

//RENDER NOZZLE POSITION
//----------------------------------------
//Draws nozzle position in the preview pane
void renderNozzle(){
  stroke(red);
  if(spraying) stroke(blue);
  fill(white,50);
  strokeWeight(3);
  ellipse(origin.x+(posx*scalar), origin.y-(posy*scalar),10,10);
  noFill();
  strokeWeight(0.5);
  ellipse(origin.x+(posx*scalar), origin.y-(posy*scalar),20,20);
  
  //Current Position
  String pos = "( "+posx+", "+posy+" )";
  fill(red);
  if( spraying ) fill(blue);
  textFont(font14,14);
  textAlign(CENTER);
  text(pos,origin.x+(posx*scalar),origin.y - (posy*scalar) + 24.0);
}

//DISPLAY STATS
//----------------------------------------
//Draws dynamic text elements elements
void displayStats(){
  //PREVIEW AREA
  
  
  //TX Command
  noStroke();
  fill(green);
  textAlign(LEFT);
  textFont(font24,24);
  text(lastSent, 15, 490);
  
  //RX Command
  noStroke();
  fill(red);
  textAlign(LEFT);
  textFont(font18,18);
  for(int i = 0; i < lastVal.size(); i++){
    text( lastVal.get(i), 15, 520 + 20*i );
  }
  
  ////SERIAL Status
  String status;
  textFont(font18,18);
  if(!connected){
    status = "NOT CONNECTED";
    fill(red);
    text(status,15,890);
  } else {
    status = "CONNECTED ON " + port;
    fill(green);
    text(status, 15, 890);
  }
  
  ////MOTOR POSITION Status
  if(true){
    noStroke();
    fill(white);
    textAlign(LEFT);
    textFont(font18,18);
    text( m1, 625, 35 );
    text( m4, 625, 885);
    textAlign(RIGHT);
    text( m2, 1475, 35 );
    text( m3, 1475, 885 );
  }
}

void initFonts() {
  font24 = loadFont("Roboto-Regular-24.vlw");
  font18 = loadFont("Roboto-Regular-18.vlw");
  font16i = loadFont("Roboto-Italic-16.vlw");
  font14 = loadFont("Roboto-Regular-14.vlw");
  font12 = loadFont("Roboto-Regular-12.vlw");
}

void initColors() {
  black = color(0);
  white = color(255);
  grey = color(220);
  charcoal = color(100);
  red = color(237, 28, 36);
  green = color(57, 181, 74);
  blue = color(80, 150, 225);
}

void setupControls() {
  //Initialize CP5 UX
  cP5 = new ControlP5(this);

  //global control panel settings
  cP5.setFont( font12 );
  cP5.setColorForeground( black );
  cP5.setColorBackground( white );
  cP5.setColorValueLabel( white );
  cP5.setColorCaptionLabel( white );
  cP5.setColorActive( blue );
  
  //SETUP PREVIEW CONTROLS
  //---------------------------
  //REPORT toggle
  cP5.addToggle("report")
  .setPosition(1000,10)
  .setSize(100,25)
  .setValue(true)
  .setColorForeground(blue)
  .setColorBackground(blue)
  .setColorActive(white)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(black)
  .setFont(font12)
  .setText("REPORT")
  ;
  
  //SETUP MANUAL CONTROLS
  //---------------------------
  //Y+100 button
  cP5.addBang("y+100")
  .setPosition(150,50)
  .setSize(50,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font12)
  .setText("Y+100")
  ;
  //Y+10 button
  cP5.addBang("y+10")
  .setPosition(150,105)
  .setSize(50,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font12)
  .setText("Y+10")
  ;
  //Y-100 button
  cP5.addBang("y-100")
  .setPosition(150,300)
  .setSize(50,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font12)
  .setText("Y-100")
  ;
  //Y-10 button
  cP5.addBang("y-10")
  .setPosition(150,245)
  .setSize(50,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font12)
  .setText("Y-10")
  ;
  //X-100 button
  cP5.addBang("x-100")
  .setPosition(25,175)
  .setSize(50,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font12)
  .setText("X-100")
  ;
  //X-10 button
  cP5.addBang("x-10")
  .setPosition(80,175)
  .setSize(50,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font12)
  .setText("X-10")
  ;
  //X+100 button
  cP5.addBang("x+100")
  .setPosition(275,175)
  .setSize(50,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font12)
  .setText("X+100")
  ;
  //X+10 button
  cP5.addBang("x+10")
  .setPosition(220,175)
  .setSize(50,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font12)
  .setText("X+10")
  ;
  
  //GO HOME button
  cP5.addBang("home")
  .setPosition(140,165)
  .setSize(70,70)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font12)
  .setText("GO HOME")
  ;
  
  //M1 MOTOR toggle
  cP5.addToggle("m1")
  .setPosition(25,50)
  .setSize(50,50)
  .setColorForeground(blue)
  .setColorBackground(white)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(black)
  .setFont(font12)
  .setText("M1")
  ;
  //M2 MOTOR toggle
  cP5.addToggle("m2")
  .setPosition(275,50)
  .setSize(50,50)
  .setColorForeground(blue)
  .setColorBackground(white)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(black)
  .setFont(font12)
  .setText("M2")
  ;
  //M3 MOTOR toggle
  cP5.addToggle("m3")
  .setPosition(275,300)
  .setSize(50,50)
  .setColorForeground(blue)
  .setColorBackground(white)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(black)
  .setFont(font12)
  .setText("M3")
  ;
  //M4 MOTOR toggle
  cP5.addToggle("m4")
  .setPosition(25,300)
  .setSize(50,50)
  .setColorForeground(blue)
  .setColorBackground(white)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(black)
  .setFont(font12)
  .setText("M4")
  ;
  
  //REEL OUT (x1) button
  cP5.addBang("reelout-x1")
  .setPosition(345,50)
  .setSize(120,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font14)
  .setText("REEL OUT")
  ;
  //REEL OUT (x2) button
  cP5.addBang("reelout-x2")
  .setPosition(345,105)
  .setSize(120,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font14)
  .setText("REEL OUT (x2)")
  ;
  //REEL IN (x1) button
  cP5.addBang("reelin-x1")
  .setPosition(470,50)
  .setSize(120,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font14)
  .setText("REEL IN")
  ;
  //REEL IN (x2) button
  cP5.addBang("reelin-x2")
  .setPosition(470,105)
  .setSize(120,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font14)
  .setText("REEL IN (x2)")
  ;
  
  //BLAST OFF button
  cP5.addBang("sprayOff")
  .setPosition(345,175)
  .setSize(120,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font14)
  .setText("SPRAY OFF")
  ;
  //BLAST ON button
  cP5.addBang("sprayOn")
  .setPosition(470,175)
  .setSize(120,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font14)
  .setText("SPRAY ON")
  ;  
  //SET ORIGIN button
  cP5.addBang("origin")
  .setPosition(345,300)
  .setSize(245,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(black)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(white)
  .setFont(font14)
  .setText("SET ORIGIN (0,0)")
  ;
  
  //RUN TEST PATTER button
  cP5.addBang("run-test")
  .setPosition(345,245)
  .setSize(245,50)
  .setTriggerEvent(Bang.RELEASE)
  .setColorForeground(green)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(black)
  .setFont(font14)
  .setText("RUN TEST PATTERN")
  ;
  
  //MANUAL ENTRY field
  cP5.addTextfield("cmdEntry")
  .setPosition( 15, 390 )
  .setSize( 560, 50 )
  .setFont( font24 )
  .setFocus( true )
  .setColor( black )
  .setAutoClear( true )
  //caption settings
  .getCaptionLabel()
  .setColor(white)
  .setFont(font14)
  .alignX(ControlP5.LEFT)
  .setText("MANUAL GCODE ENTRY")
  ;

}