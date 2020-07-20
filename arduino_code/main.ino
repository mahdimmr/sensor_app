#include "ESP8266WiFi.h"
#include <PubSubClient.h>

const int TRIG_PIN = 13;
const int ECHO_PIN = 15;
const int blue = 12;
const int green = 14;
const int red = 16;

const char* ssid = "\\  -_-  /";
const char* password = "*******";

WiFiClient wifiClient;
PubSubClient client(wifiClient);

void distanceDo(long distanceCm, long distanceIn) {
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
  }
  else if ( 6 <= distanceCm && distanceCm <= 12){
    digitalWrite(red, LOW);
    digitalWrite(blue, HIGH);
    digitalWrite(green, LOW);
  }
  else {
    digitalWrite(red, HIGH);
    digitalWrite(blue, LOW);
    digitalWrite(green, LOW);
  };
  
  char *str = (char*)malloc(13 * sizeof(char));;
  sprintf(str, "%ld", distanceCm);
  digitalWrite(LED_BUILTIN, HIGH);
  client.publish("/distance", str);
  delayMicroseconds(50);
  digitalWrite(LED_BUILTIN, LOW);
//  char *str2 = (char*)malloc(13 * sizeof(char));;
//  sprintf(str2, "%ld inch", distanceIn);
//  client.publish("/distance", str2);
}


void setup() {
  Serial.begin(9600);
  pinMode(LED_BUILTIN, HIGH);
  pinMode(TRIG_PIN,OUTPUT);
  pinMode(red,OUTPUT);
  pinMode(blue,OUTPUT);
  pinMode(green,OUTPUT);
  pinMode(ECHO_PIN,INPUT);
  client.setServer("192.168.1.36", 1883);
  client.setCallback(callback);
  Serial.print(WiFi.localIP());
  Serial.println("");
  Serial.println("WiFi connection Successful");
  Serial.print("The IP Address of ESP8266 Module is: ");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) 
  {
     digitalWrite(LED_BUILTIN, HIGH);
     delay(500);
     digitalWrite(LED_BUILTIN, LOW);
     delay(500);
     Serial.print("*");
  }
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
}

void loop()
{
  long duration, distanceCm, distanceIn;
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(2);
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  
  duration = pulseIn(ECHO_PIN, HIGH);
  distanceCm = duration / 29.1 / 2 ;
  distanceIn = duration / 74 / 2;
  distanceDo(distanceCm, distanceIn);
}
