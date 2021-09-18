 Firefighting-Robot-Simulation2
This program simulates a firefighting robot travelling down a maze in search of a fire utilizing 2 servo motors temp and range sensor and a Arduino.
//Date: January 22th 2021
//Name: Muad Abdinur
//Program title: firefighting robot
//This program simulates a robot
//travelling down a maze and finding a flame
#include<Servo.h>

const int trigPin = 4;
const int echoPin = 3;
const int servoRightPin = 12;
const int servoLeftPin = 11;
const int servoFanPin = 13;
Servo servoLeft;                             // Declare left servo signal
Servo servoRight;                            // Declare right servo signal
Servo servoFan;                              // Declare Fan servo signal
int sensorValue = 0;

int celsius, delay_t;
int maxtemp=0;
int maxpposition=0;

double temperatures[] = {0, 0, 0, 0, 0, 0, 0, 0, 0};

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT); 
  pinMode(7,OUTPUT);
  Serial.begin(9600);
}

void loop() {
  Serial.println("Start Simulation");
  
  servoLeft.attach(servoLeftPin);                      // Attach left signal to pin 13
  servoRight.attach(servoRightPin);                     // Attach right signal to pin 12
  
  //start spinning wheels clockwise (move forward)
  servoLeft.write(80);          
  servoRight.write(80);   
  
  //wait for first wall
  Serial.println("Waiting for first wall");
  waitForWall();
  
  //turn right
  Serial.println("Turning right at first wall");
  servoRight.write(120);  //right wheel spins faster than left counterclock wise
  delay(500);

  Serial.println("Move Curser away from first wall");
  delay(1000);
  
  //move forward again
  Serial.println("Moving towards second wall");
  servoLeft.write(80);  
  servoRight.write(80);  

  
  //wait for second wall
  Serial.println("Waiting for second wall");
  waitForWall();
  
  //turn left
  Serial.println("Turning left at second wall");
  servoLeft.write(120); ////right wheel spins faster than left counterclockwise
  delay(500);
  
  Serial.println("Move Curser away from second wall");
  delay(2000);
  
  //move forward again 
  Serial.println("Move forward");
  servoLeft.write(80);    
  servoRight.write(80);  
  delay(1500);
  
  //stop motor and scan for the flame
  servoLeft.detach();        
  servoRight.detach();
  Serial.println("scanning for flame");

  maxtemp = 0;
  for (int i = 0; i < 9; i++) {
    // Converts the temperature sensor value into celsius
    temperatures[i] = map(((analogRead(A5) - 20) * 3.04), 0, 1023, -40, 125);
    Serial.print("Temperature: ");
    Serial.println(temperatures[i]);
    
    if(temperatures[i]>maxtemp) {
      maxtemp=temperatures[i];
      maxpposition=i; 
    }
    
    servoRight.attach(servoRightPin);
    servoRight.write(80);
    delay(55);
    servoRight.write(93);
  }
  
  //move right servo to max position then stop
  servoRight.attach(servoRightPin);
  servoRight.write(106);
  delay((9-maxpposition)*55);
  servoRight.write(93);
  
  
  //move both servos forward
  servoLeft.attach(servoLeftPin);
  servoRight.attach(servoRightPin);
  servoRight.write(80);
  servoLeft.write(80);
  delay(1000);
  
  //stop servos
  servoRight.write(93);
  servoLeft.write(93);
  
  
  servoFan.attach(servoFanPin);
  servoFan.write(0); //turns fan on
  delay(1000);
  servoFan.detach(); //turns fan off
  delay(1000);
 
  digitalWrite(7,HIGH); //turns led on (flame found)
  delay(2000);
  digitalWrite(7,LOW);
  delay(4000);
  while(1){
  }  
}
 
  

float ultrasonicSensor(){
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  float duration = pulseIn(echoPin, HIGH);
  float distance = (duration*.0343)/2;
  return distance;
}

void waitForWall(){
  float distance = 40; //ultrasonicSensor();

  while(distance > 20){
    delay(100);
    distance = ultrasonicSensor();
  }
}
