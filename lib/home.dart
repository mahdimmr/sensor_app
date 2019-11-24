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
  bool is_connect = false;
  bool is_sub = false;

  bool _brokerAddressValidate = false;
  final _brokerAddressController = TextEditingController();
  bool _topicValidate = false;
  final _topicController = TextEditingController();
  bool _messageValidate = false;
  final _messageController = TextEditingController();

  String message = "";
  int distance;
  Color color;

  void _createClient() {
    setState(() {
      _brokerAddressController.text.isEmpty
          ? _brokerAddressValidate = true
          : _brokerAddressValidate = false;
      _topicController.text.isEmpty
          ? _topicValidate = true
          : _topicValidate = false;
    });
    if (_brokerAddressValidate == false && _topicValidate == false) {
      setState(() {
        this.client = MqttClient(_brokerAddressController.text,
            "Client" + Random().nextInt(6).toString());
        this.client.connect();
      });
      setState(() {
        this.is_connect = true;
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
        try {
          this.distance = int.parse(this.message);
          if (this.distance >= 13) {
            this.color = Colors.green;
          } else if (5 < this.distance) {
            this.color = Colors.blue;
          } else if (this.distance < 5) {
            this.color = Colors.redAccent;
          }
          this.message = this.distance.toString() + " cm";
        } catch (e) {}
      });
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    });
  }

  _publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    print('EXAMPLE::Publishing our topic');
    this.client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
  }

  _disconnect() {
    this.client.disconnect();
    setState(() {
      this.color = Colors.black;
      this.is_connect = false;
      this.is_sub = false;
      this.message = "";
    });
  }

  _subScribe() {
    print('EXAMPLE::Subscribing to the ${_topicController.text} topic');
    this.client.subscribe(_topicController.text, MqttQos.exactlyOnce);
    this._onMessage();
    setState(() {
      this.is_sub = true;
    });
  }

  _subUnScribe(topic) {
    print("uNNNNNNNNNNN");
    this.client.unsubscribe(topic);
    setState(() {
      this.is_sub = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.developer_board),
              onPressed: () {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white24,
                      elevation: 10,
                      content: Text("Developed by Mehdi MohammadRezayi"),
                    );
                  },
                );
              },
            ),
            SizedBox(
              width: 10.0,
            ),
            Text("MController"),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(left: 6.0, right: 6.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _brokerAddressController,
                    decoration: InputDecoration(
                        suffix: Icon(Icons.message, color: Colors.white24),
                        hintText: "Broker Address",
                        errorText: _brokerAddressValidate
                            ? "Insert borker address."
                            : null),
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                  ),
                  TextField(
                    controller: _topicController,
                    decoration: InputDecoration(
                        suffix: Icon(Icons.subject, color: Colors.white24),
                        hintText: "Topic",
                        errorText: _topicValidate
                            ? "Insert the topic you want send message to it!"
                            : null),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                  ),
                  TextField(
                    enabled: this.is_connect,
                    controller: _messageController,
                    decoration: InputDecoration(
                        suffix: Icon(Icons.email, color: Colors.white24),
                        hintText: "Message",
                        errorText:
                            _messageValidate ? "Insert the message." : null),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: _createClient,
                child: Text("Connect"),
              ),
              FlatButton(
                child: Text("Publish"),
                onPressed: this.is_connect
                    ? () {
                        setState(() {
                          _messageController.text.isEmpty
                              ? _messageValidate = true
                              : _messageValidate = false;
                          _topicController.text.isEmpty
                              ? _topicValidate = true
                              : _topicValidate = false;
                        });
                        if (_messageController.text.isNotEmpty &&
                            _topicController.text.isNotEmpty) {
                          this._publish(
                              _topicController.text, _messageController.text);
                        }
                      }
                    : null,
              ),
              FlatButton(
                onPressed: is_connect
                    ? () {
                        if (is_sub) {
                          this._subUnScribe(_topicController.text);
                        } else {
                          this._subScribe();
                        }
                      }
                    : null,
                child: Text(this.is_sub ? "UnSubscribe" : "Subscribe"),
              ),
              FlatButton(
                onPressed: this.is_connect ? _disconnect : null,
                child: Text("Disconnect"),
              ),
            ],
          ),
          Text(message.isEmpty ? "" : message)
        ],
      ),
    );
  }
}

// 192.168.1.37
