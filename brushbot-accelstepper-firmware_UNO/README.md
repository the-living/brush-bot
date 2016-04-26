##Serial Comm Baud Rate
57600

##GCODE Commands

##Move / Draw Commands
####G01 - Move
Moves from current position to given (x, y) position (no spray)
```
G00 X100.0 Y200.0
```
####G01 - Line
Draws a line from current position to given (x, y) positions
```
G01 X100.0 Y200.0
```
####G02-G03 - Arc
Draws an arc from current position to a given (x, y) position around center (i, j)
Sweep of arc must not be greater than 180 degrees (PI radians)

*clockwise arc*
```
G02 I50.0 J10.0 X100.0 Y200.0
```
*counter-clockwise arc*
```
G03 I50.0 J10.0 X100.0 Y200.0
```
####G04 - Wait
Waits for a given amount of time in milliseconds
```
G04 P2500.0
```
##Motor Override Commands
####M00 - Disengage Motors
Disengages all motors. Motors will spin freely, and will not register positional changes.
```
M00
```
####M01 - Engage Motors
Engages all motors. Motors will resist movement.
```
M01
```
####M10-M20-M30-M40 - Forward Jog
Moves single stepper motor forward one step.

*M1 (top-left)*
```
M10
```
*M2 (top-right)*
```
M20
```
*M3 (bottom-right)*
```
M30
```
*M4 (bottom-left)*
```
M40
```
####M11-M21-M31-M41 - Backward Jog (Stepper 1)
Moves single stepper motor backward one step.

*M1 (top-left)*
```
M11
```
*M2 (top-right)*
```
M21
```
*M3 (bottom-right)*
```
M31
```
*M4 (bottom-left)*
```
M41
```
####M12-M22-M32-M42 - Disengage Motor
Disengages single stepper motor. Motor will spin freely, and will not register positional changes.

*M1 (top-left)*
```
M12
```
*M2 (top-right)*
```
M22
```
*M3 (bottom-right)*
```
M32
```
*M4 (bottom-left)*
```
M42
```
####M13-M23-M33-M43 - Engage Motor
Engages single stepper motor. Motor will resist movement.

*M1 (top-left)*
```
M13
```
*M2 (top-right)*
```
M23
```
*M3 (bottom-right)*
```
M33
```
*M4 (bottom-left)*
```
M43
```

####M50 - Engage Sprayer
Engages sprayer servo.
```
M50
```
####M51 - Disengage Sprayer
Disengages sprayer servo.
```
M51
```
####M100 - Teleport
Manually sets motor positions to given location (without movement).

*Set to origin (0, 0):*
```
M100
```
*Set to position (x, y):*
```
M100 X50.0 Y100.0
```
##Machine Setting Commands
####D01 - Update Plotter Dimensions
Updates plotter dimensions in firmware (mm).
```
D01 T500.0 B-500.0 R450.0 L-450.0
```
####D05 - Update Spool Diameters
Updates all spool diameters in firmware (mm).
```
D05 S40.0
```
####D10 - Update Motor Max Speed
Updates max motor speed in firmware (steps/s).
```
D10 S150.0
```
