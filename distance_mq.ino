#include "MQTTClient.h"


const int TRIG_PIN = 13;
const int ECHO_PIN = 15;
const int blue = 12;
const int green = 14;
const int red = 16;


void setup() {
  Serial.begin(9600);
  pinMode(TRIG_PIN,OUTPUT);
  pinMode(red,OUTPUT);
  pinMode(blue,OUTPUT);
  pinMode(green,OUTPUT);
  pinMode(ECHO_PIN,INPUT);
}
 
void loop()
{
  long duration, distanceCm, distanceIn;
 
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, LOW);
  duration = pulseIn(ECHO_PIN, HIGH);
  Serial.print("duration");
  Serial.println(duration);
  
  distanceCm = duration / 29.1 / 2 ;
  distanceIn = duration / 74 / 2;

  if (distanceCm <= 0){
    Serial.println("Out of range");
  } else {
    Serial.print(distanceIn);
    Serial.print("in: ");
    Serial.print(distanceCm);
    Serial.print("cm");
    Serial.println();
  };


  if (distanceCm >= 13) {
    digitalWrite(red, LOW);
    digitalWrite(blue, LOW);
    digitalWrite(green, HIGH);
    Serial.println("green");
  }
  else if ( 6 <= distanceCm && distanceCm <= 12){
    digitalWrite(red, LOW);
    digitalWrite(blue, HIGH);
    digitalWrite(green, LOW);
    Serial.println("blue");
  }
  else {
    digitalWrite(red, HIGH);
    digitalWrite(blue, LOW);
    digitalWrite(green, LOW);
    Serial.println("red");
  };

  delay(500);
}

