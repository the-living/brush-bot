// AFMotor_ConstantSpeed.pde
// -*- mode: C++ -*-
//
// Shows how to run AccelStepper in the simplest,
// fixed speed mode with no accelerations
// Requires the AFMotor library
// (https://github.com/adafruit/Adafruit-Motor-Shield-library)
// Caution, does not work with Adafruit Motor Shield V2
// See https://github.com/adafruit/Adafruit_Motor_Shield_V2_Library 
// for examples that work with Adafruit Motor Shield V2.

#include <AccelStepper.h>
//#include <AFMotor.h>


#define X_STEP_PIN         54
#define X_DIR_PIN          55
#define X_ENABLE_PIN       38

#define Y_STEP_PIN         60
#define Y_DIR_PIN          61
#define Y_ENABLE_PIN       56

#define E_STEP_PIN         26
#define E_DIR_PIN          28
#define E_ENABLE_PIN       24

#define Q_STEP_PIN         36
#define Q_DIR_PIN          34
#define Q_ENABLE_PIN       30

int sp = 10;

boolean b = true;


//AccelStepper stepper(forwardstep, backwardstep); // use functions to step
AccelStepper stepper1(1, X_STEP_PIN, X_DIR_PIN);
AccelStepper stepper2(1, Y_STEP_PIN, Y_DIR_PIN);
AccelStepper stepper3(1, E_STEP_PIN, E_DIR_PIN);
AccelStepper stepper4(1, Q_STEP_PIN, Q_DIR_PIN);


void setup()
{  
  
  
  pinMode(X_STEP_PIN  , OUTPUT);
  pinMode(X_DIR_PIN    , OUTPUT);
  pinMode(X_ENABLE_PIN    , OUTPUT);
  
  digitalWrite(X_ENABLE_PIN    , LOW);
  digitalWrite(X_DIR_PIN, LOW);
  
  pinMode(Y_STEP_PIN  , OUTPUT);
  pinMode(Y_DIR_PIN    , OUTPUT);
  pinMode(Y_ENABLE_PIN    , OUTPUT);
  
  digitalWrite(Y_ENABLE_PIN    , LOW);
  digitalWrite(Y_DIR_PIN, LOW);
  
  pinMode(E_STEP_PIN  , OUTPUT);
  pinMode(E_DIR_PIN    , OUTPUT);
  pinMode(E_ENABLE_PIN    , OUTPUT);
  
  digitalWrite(E_ENABLE_PIN    , LOW);
  digitalWrite(E_DIR_PIN, LOW);
  
  pinMode(Q_STEP_PIN  , OUTPUT);
  pinMode(Q_DIR_PIN    , OUTPUT);
  pinMode(Q_ENABLE_PIN    , OUTPUT);
  
  digitalWrite(Q_ENABLE_PIN    , LOW);
  digitalWrite(Q_DIR_PIN, LOW);
  
  
   Serial.begin(9600);           // set up Serial library at 9600 bps
   Serial.println("Stepper test!");
   
  stepper1.setMaxSpeed(50);
  stepper1.setAcceleration(50);
  stepper1.moveTo(20);
   
  stepper2.setMaxSpeed(50);
  stepper2.setAcceleration(50);
  stepper2.moveTo(-20);
   
  stepper3.setMaxSpeed(50);
  stepper3.setAcceleration(50);
  stepper3.moveTo(20);
   
  stepper4.setMaxSpeed(50);
  stepper4.setAcceleration(50);
  stepper4.moveTo(-20);
}

void loop()
{  
    stepper1.run();
    stepper2.run();
    stepper3.run();
    stepper4.run();
}
