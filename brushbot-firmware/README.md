#Serial Comm Baud Rate
57600

#GCODE Commands

##Move / Draw Commands
###G01 - Move
Moves from current position to given (x, y) position (no spray)
```
G00 X100.0 Y200.0
```

###G01 - Line
Draws a line from current position to given (x, y) positions
```
G01 X100.0 Y200.0
```

###G02 - Arc (Clockwise)
Draws an arc from current position to a given (x, y) position around center (i, j) in a clockwise direction
Sweep of arc must not be greater than 180 degrees (PI radians)
```
G02 I50.0 J10.0 X100.0 Y200.0
```

###G03 - Arc (Counter-clockwise)
Draws an arc from current position to a given (x, y) position around center (i, j) in a counter-clockwise direction
Sweep of arc must not be greater than 180 degrees (PI radians)
```
G03 I50.0 J10.0 X100.0 Y200.0
```

###G04 - Wait
Waits for a given amount of time in milliseconds
```
G04 P2500.0
```

##Motor Override Commands
###M00 - Disengage Motors
Disengages all motors. Motors will spin freely, and will not register positional changes.
```
M00
```

###M01 - Engage Motors
Engages all motors. Motors will resist movement.
```
M01
```

###M10 - Forward Jog (Stepper 1)
Moves Stepper 1 (top-left corner) forward one step.
```
M10
```

###M11 - Backward Jog (Stepper 1)
Moves Stepper 1 (top-left corner) backward one step.
```
M11
```

###M12 - Disengage Motor (Stepper 1)
Disengages Stepper 1 (top-left corner). Motor will spin freely, and will not register positional changes.
```
M12
```

###M13 - Engage Motor (Stepper 1)
Engages Stepper 1 (top-left corner). Motor will resist movement.
```
M13
```

###M20 - Forward Jog (Stepper 2)
Moves Stepper 2 (top-right corner) forward one step.
```
M20
```

###M21 - Backward Jog (Stepper 2)
Moves Stepper 2 (top-right corner) backward one step.
```
M21
```

###M22 - Disengage Motor (Stepper 2)
Disengages Stepper 2 (top-right corner). Motor will spin freely, and will not register positional changes.
```
M22
```

###M23 - Engage Motor (Stepper 2)
Engages Stepper 2 (top-right corner). Motor will resist movement.
```
M23
```

###M30 - Forward Jog (Stepper 3)
Moves Stepper 3 (bottom-right corner) forward one step.
```
M30
```

###M31 - Backward Jog (Stepper 3)
Moves Stepper 3 (bottom-right corner) backward one step.
```
M31
```

###M32 - Disengage Motor (Stepper 3)
Disengages Stepper 3 (bottom-right corner). Motor will spin freely, and will not register positional changes.
```
M32
```

###M33 - Engage Motor (Stepper 3)
Engages Stepper 3 (bottom-right corner). Motor will resist movement.
```
M33
```

###M40 - Forward Jog (Stepper 4)
Moves Stepper 4 (bottom-left corner) forward one step.
```
M40
```

###M41 - Backward Jog (Stepper 4)
Moves Stepper 4 (bottom-left corner) backward one step.
```
M41
```

###M42 - Disengage Motor (Stepper 4)
Disengages Stepper 1 (bottom-left corner). Motor will spin freely, and will not register positional changes.
```
M42
```

###M43 - Engage Motor (Stepper 4)
Engages Stepper 4 (bottom-left corner). Motor will resist movement.
```
M43
```

###M50 - Engage Sprayer
Engages sprayer servo.
```
M50
```

###M51 - Disengage Sprayer
Disengages sprayer servo.
```
M51
```

###M100 - Teleport
Manually sets motor positions to given location (without movement).
*Set to origin (0, 0):*
```
M100
```
*Set to position (x, y):*
```
M100 X50.0 Y100.0
```
