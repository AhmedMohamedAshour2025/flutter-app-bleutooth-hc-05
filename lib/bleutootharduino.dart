import 'dart:async';
import 'package:arrow_pad/arrow_pad.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ArduinoBleutooth extends StatefulWidget {
  const ArduinoBleutooth({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ArduinoBleutoothState createState() => _ArduinoBleutoothState();
}

class _ArduinoBleutoothState extends State<ArduinoBleutooth> {
  List<BluetoothDevice> _devices = [];
  late BluetoothConnection connection;
  String adr = "00:23:09:01:4E:C5"; // my bluetooth device MAC Adres
  TextEditingController controller = TextEditingController();
  dynamic data = '';
  String connectionStatus = '';
  bool isConnected = false;
  String dataStatus = '';
  bool reachData = false;
  bool connecting = false;
  bool isRuning = true;
  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();

    setState(() {
      _devices = devices;
    });
  }

  Future<void> sendData(String data) async {
    data = data.trim();
    print('data $data');
    try {
      List<int> list = data.codeUnits;
      Uint8List bytes = Uint8List.fromList(list);
      connection.output.add(bytes);
      await connection.output.allSent;
      if (kDebugMode) {
        print('Data sent successfully');
        setState(() {
          reachData = true;
          dataStatus = 'Data sent successfully';
        });
      }
    } catch (e) {
      print(
          'Unable to reach the HC-05 module.\nPlease check the connection and try again');
      setState(() {
        reachData = false;
        dataStatus =
            'unable to reach the HC-05 module.\nplease check the connection and try again';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Arduino Bleutooth",
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("MAC Adress: 00:23:09:01:4E:C5"),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                child: const Text(
                  "Connect",
                ),
                onPressed: () {
                  connect(adr);
                },
              ),
              ArrowPad(
                innerColor: Colors.blue,
                arrowPadIconStyle: ArrowPadIconStyle.arrow,
                height: screenHeight / 3,
                onPressedUp: () {
                  sendData('A');
                  print('up');
                },
                onPressedDown: () {
                  sendData('B');
                  print('down');
                },
                onPressedLeft: () {
                  sendData('C');
                  print('left');
                },
                onPressedRight: () {
                  sendData('D');
                  print('right');
                },
              ),
              const SizedBox(
                height: 15.0,
              ),
              connecting
                  ? const CircularProgressIndicator()
                  : Text(
                      connectionStatus,
                      style: TextStyle(
                        color: isConnected ? Colors.green : Colors.red,
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          sendData('E');
                          print('E');
                        });
                      },
                      backgroundColor: Colors.blueGrey,
                      child: const Text('Stop'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: 'Enter data',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(1)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            sendMessage();
                          },
                          icon: const Icon(
                            Icons.send,
                            size: 30,
                            color: Colors.blueGrey,
                          ))),
                  onSubmitted: (value) {
                    sendMessage();
                  },
                ),
              ),
              Text(
                dataStatus,
                style:
                    TextStyle(color: (reachData) ? Colors.black : Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage() {
    String data = controller.text;
    if (data.isNotEmpty) {
      sendData(data);
      print(data);
    }

    controller.clear();
  }

  Future connect(String address) async {
    try {
      setState(() {
        connecting = true;
      });
      connection = await BluetoothConnection.toAddress(address);

      setState(() {
        isConnected = true;
        connecting = false;
        connectionStatus = 'Connected';
      });
      //sendData('111');
      //durum="Connected to the device";
      connection.input!.listen((Uint8List data) {
        //Data entry point
        // durum=ascii.decode(data);
      });
    } catch (exception) {
      // durum="Cannot connect, exception occured";
      setState(() {
        isConnected = false;
        connecting = false;
        connectionStatus = 'Cannot connect, exception occurred';
      });
    }
  }

// --------------**************data gonder
//Future send(Uint8List data) async {
//connection.output.add(data);
//await connection.output.allSent;
}
