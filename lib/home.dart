import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:math';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MqttClient client;
  bool _brokerAddressValidate = false;
  final _brokerAddressController = TextEditingController();
  String message = "None";

  void _createClient() {
    setState(() {
      _brokerAddressController.text.isEmpty
          ? _brokerAddressValidate = true
          : _brokerAddressValidate = false;
    });
    if (_brokerAddressValidate == false) {
      setState(() {
        this.client = MqttClient(_brokerAddressController.text,
            "Client" + Random().nextInt(6).toString());
        this.client.connect();
      });
    }
  }

  _onMessage() {
    this.client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      setState(() {
        this.message = pt;
      });
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    });
  }

  _publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('EXAMPLE::Subscribing to the ${topic} topic');
    client.subscribe(topic, MqttQos.exactlyOnce);

    print('EXAMPLE::Publishing our topic');
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.settings_remote),
            SizedBox(
              width: 10.0,
            ),
            Text("MController")
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextField(
              controller: _brokerAddressController,
              decoration: InputDecoration(
                  suffix: Icon(Icons.email, color: Colors.white24),
                  hintText: "Broker Address",
                  errorText:
                      _brokerAddressValidate ? "Insert borker address." : null),
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: _createClient,
                child: Text("Connect"),
              ),
              FlatButton(
                onPressed: () {
                  this._publish("/hello", "hellllllo");
                  this._onMessage();
                },
                child: Text("Publish"),
              ),
              FlatButton(
                onPressed: () {
                  this.client.disconnect();
                },
                child: Text("Disconnect"),
              ),
            ],
          ),
          Text(message)
        ],
      ),
    );
  }
}

// 192.168.1.37
