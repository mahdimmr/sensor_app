
void reconnect() {
  digitalWrite(LED_BUILTIN, HIGH);
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (client.connect("clinetid")) {
      Serial.println("connected");
      client.publish("distance","hello from esp");
      client.subscribe("hello");
      digitalWrite(LED_BUILTIN, LOW);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      
    }
  }
}


void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i=0;i<length;i++) {
    Serial.print((char)payload[i]);
  }
}
