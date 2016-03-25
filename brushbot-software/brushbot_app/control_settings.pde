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


  //DISABLE BUTTON
  //Send disengage signal to all selected motors
  cP5.addBang("disable")
    .setPosition(600, 200)
    .setSize(200, 45)
    .setTriggerEvent(Bang.RELEASE)
    //caption settings
    .getCaptionLabel()
    .align(ControlP5.CENTER, ControlP5.CENTER)
    .setColor(255)
    .setFont(fontM)
    .setText("MOTOR OFF")
    ;
  
  //ENABLE BUTTON
  //Send engage signal to all selected motors
  cP5.addBang("enable")
    .setPosition(600, 250)
    .setSize(200, 45)
    .setTriggerEvent(Bang.RELEASE)
    //caption settings
    .getCaptionLabel()
    .align(ControlP5.CENTER, ControlP5.CENTER)
    .setColor(255)
    .setFont(fontM)
    .setText("MOTOR ON")
    ;

  //TELEPORT BUTTON
  //Send teleport signal
  cP5.addBang("teleport")
    .setPosition(600, 350)
    .setSize(200, 45)
    .setTriggerEvent(Bang.RELEASE)
    //caption settings
    .getCaptionLabel()
    .align(ControlP5.CENTER, ControlP5.CENTER)
    .setColor(255)
    .setFont(fontM)
    .setText("TELEPORT")
    ;
    
  //TELEPORT X INPUT
  //x-position to teleport to
  cP5.addTextfield("teleport_x")
    .setPosition( 600, 400 )
    .setSize( 95, 45 )
    .setFont( fontL )
    .setFocus( false )
    .setColor( color(0) )
    .setAutoClear( false )
    //caption settings
    .getCaptionLabel()
    .setColor(0)
    .setFont(fontM)
    .alignX(ControlP5.CENTER)
    .setText("X")
    ;
  //TELEPORT Y INPUT
  //y-position to teleport to
  cP5.addTextfield("teleport_y")
    .setPosition( 700, 400 )
    .setSize( 95, 45 )
    .setFont( fontL )
    .setFocus( false )
    .setColor( color(0) )
    .setAutoClear( false )
    //caption settings
    .getCaptionLabel()
    .setColor(0)
    .setFont(fontM)
    .alignX(ControlP5.CENTER)
    .setText("Y")
    ;
}