// import 'dart:async';
// import 'dart:io';
// import 'package:mqtt_client/mqtt_client.dart';

// class InternalMQTT extends MqttClient {
//   MqttClient client;

//   InternalMQTT(this.client) : super('', '');

//   publish() {
//     const String pubTopic = '/hello';
//     final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
//     builder.addString('Hello from mqtt_client');

//     print('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
//     client.subscribe(pubTopic, MqttQos.exactlyOnce);

//     print('EXAMPLE::Publishing our topic');
//     client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload);
//   }

//   void disconnect() {
//     if (client.connectionStatus.state == MqttConnectionState.connected) {
//       client.disconnect();
//     } else {
//       print("Client is not connected!");
//     }
//   }

//   customConnect() async {
//     this.client.keepAlivePeriod = 3;
//     void onConnected() {
//       print(
//           'EXAMPLE::OnConnected client callback - Client connection was sucessful');
//     }

//     this.client.onConnected = onConnected;
//     final MqttConnectMessage connMess = MqttConnectMessage()
//         .withClientIdentifier(this.client.clientIdentifier)
//         .keepAliveFor(3) // Must agree with the keep alive set above or not set
//         .withWillTopic(
//             'willtopic') // If you set this you must set a will message
//         .withWillMessage('My Will message')
//         .startClean() // Non persistent session for testing
//         .withWillQos(MqttQos.atLeastOnce);
//     print('EXAMPLE::Mosquitto client connecting....');
//     client.connectionMessage = connMess;
//   }

//   bool is_connected() {
//     if (this.client.connectionStatus.state == MqttConnectionState.connected) {
//       print('EXAMPLE::Mosquitto client connected');
//       return true;
//     } else {
//       print(
//           'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${this.client.connectionStatus}');

//       return false;
//     }
//   }
// }
