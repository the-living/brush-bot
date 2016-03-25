//---------------------------------------------------------------------------
//
// ControlP5 UX Objects Setup
//
//---------------------------------------------------------------------------

void setupControls(){
  //global control panel settings
  cP5.setFont( fontS );
  cP5.setColorForeground( fgColor );
  cP5.setColorBackground( bgColor );
  cP5.setColorValueLabel( bgColor );
  cP5.setColorCaptionLabel( bgColor );
  cP5.setColorActive( activeColor );

  //MANUAL COMMAND ENTRY
  //---------------------------------------------------------------------------
  //Issues typed out GCODE command
  cP5.addTextfield("cmd_entry")
  .setPosition( 50, 650 )
  .setSize( 700, 50 )
  .setFont( fontL )
  .setFocus( true )
  .setColor( color(0) )
  .setAutoClear( true )
  //caption settings
  .getCaptionLabel()
  .setColor(255)
  .setFont(fontM)
  .alignX(ControlP5.LEFT)
  .setText("Manual GCODE Entry")
  ;

  //MOTOR TOGGLES
  //---------------------------------------------------------------------------
  //M1 TOGGLE - Top-Left
  cP5.addToggle("m1")
  .setPosition(50, 50)
  .setSize(50, 50)
  //caption settings
  .getCaptionLabel()
  .alignX(ControlP5.LEFT)
  .setColor(0)
  .setFont(fontM)
  .setText("M1")
  ;
  //M2 TOGGLE - Top-Right
  cP5.addToggle("m2")
  .setPosition(500, 50)
  .setSize(50, 50)
  //caption settings
  .getCaptionLabel()
  .alignX(ControlP5.RIGHT)
  .setColor(0)
  .setFont(fontM)
  .setText("M2")
  ;
  //M3 TOGGLE - Bottom-Right
  cP5.addToggle("m3")
  .setPosition(500, 500)
  .setSize(50, 50)
  //caption settings
  .getCaptionLabel()
  .alignX(ControlP5.RIGHT)
  .setColor(0)
  .setFont(fontM)
  .setText("M3")
  ;
  //M4 TOGGLE - Bottom-Left
  cP5.addToggle("m4")
  .setPosition(50, 500)
  .setSize(50, 50)
  //caption settings
  .getCaptionLabel()
  .alignX(ControlP5.LEFT)
  .setColor(0)
  .setFont(fontM)
  .setText("M4")
  ;

  //MOTOR JOGGING
  //---------------------------------------------------------------------------
  //JOG FORWARD BUTTON
  //Send jog forward signal to all selected motors
  cP5.addBang("jog_forward")
  .setPosition(600, 50)
  .setSize(200, 45)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontM)
  .setText("FORWARD")
  ;

  //JOG BACKWARD BUTTON
  //Send jog backward signal to all selected motors
  cP5.addBang("jog_backward")
  .setPosition(600, 100)
  .setSize(200, 45)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontM)
  .setText("BACKWARD")
  ;

  //MOTOR ENABLE/DISABLE
  //---------------------------------------------------------------------------
  //DISABLE BUTTON
  //Send disengage signal to all selected motors
  cP5.addBang("disable")
  .setPosition(600, 200)
  .setSize(98, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("MOTOR OFF")
  ;

  //ENABLE BUTTON
  //Send engage signal to all selected motors
  cP5.addBang("enable")
  .setPosition(702, 200)
  .setSize(98, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("MOTOR ON")
  ;

  //SPRAYER ENABLE/DISABLE
  //---------------------------------------------------------------------------
  //DISABLE BUTTON
  //Turns off sprayer
  cP5.addBang("spray_off")
  .setPosition(600, 300)
  .setSize(98, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("SPRAY OFF")
  ;

  //ENABLE BUTTON
  //Turns on sprayer
  cP5.addBang("spray_on")
  .setPosition(702, 300)
  .setSize(98, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("SPRAY ON")
  ;

  //TELEPORT
  //---------------------------------------------------------------------------

  //Send teleport signal
  cP5.addBang("teleport")
  .setPosition(600, 450)
  .setSize(200, 45)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontM)
  .setText("SET ORIGIN (0,0)")
  ;

  //AXIAL MOVE COMMANDS
  //---------------------------------------------------------------------------

  //X +100 BUTTON
  cP5.addBang("x_100")
  .setPosition(500, 275)
  .setSize(50, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("X +100")
  ;

  //X +10 BUTTON
  cP5.addBang("x_10")
  .setPosition(445, 275)
  .setSize(50, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("X +10")
  ;

  //X -100 BUTTON
  cP5.addBang("x_-100")
  .setPosition(50, 275)
  .setSize(50, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("X -100")
  ;

  //X -10 BUTTON
  cP5.addBang("x_-10")
  .setPosition(105, 275)
  .setSize(50, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("X -10")
  ;

  //X +100 BUTTON
  cP5.addBang("y_100")
  .setPosition(275, 50)
  .setSize(50, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("Y +100")
  ;

  //Y +10 BUTTON
  cP5.addBang("y_10")
  .setPosition(275, 105)
  .setSize(50, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("Y +10")
  ;

  //Y -100 BUTTON
  cP5.addBang("y_-100")
  .setPosition(275,500)
  .setSize(50, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("Y -100")
  ;

  //Y -10 BUTTON
  cP5.addBang("y_-10")
  .setPosition(275, 445)
  .setSize(50, 50)
  .setTriggerEvent(Bang.RELEASE)
  //caption settings
  .getCaptionLabel()
  .align(ControlP5.CENTER, ControlP5.CENTER)
  .setColor(255)
  .setFont(fontS)
  .setText("Y -10")
  ;
}
