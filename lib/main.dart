import 'package:control_arduino/homepage.dart';

import 'package:flutter/material.dart';

void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}




















//------------*********** data gonder end
// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   List<BluetoothDevice> _devices = [];
//   late BluetoothConnection connection;
//   String adr = "00:21:07:00:50:69"; // my bluetooth device MAC Adres
//   String connectionStatus = 'Not Connected'; // Track the connection status
//   TextEditingController controller = TextEditingController();
//   dynamic data = '';
//   @override
//   void initState() {
//     super.initState();
//     // _macAddressController = TextEditingController();

//     _loadDevices();
//   }

//   Future<void> _loadDevices() async {
//     List<BluetoothDevice> devices =
//         await FlutterBluetoothSerial.instance.getBondedDevices();

//     setState(() {
//       _devices = devices;
//     });
//   }

//   Future<void> sendData(String data) async {
//     data = data.trim();
//     print(data);
//     try {
//       List<int> list = data.codeUnits;
//       Uint8List bytes = Uint8List.fromList(list);
//       print(bytes);
//       connection.output.add(bytes);
//       await connection.output.allSent;
//       if (kDebugMode) {
//         print('Data sent successfully');
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text("Bluetooth Single LED Control"),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text("MAC Adress: 00:21:07:00:50:69"),

//               ElevatedButton(
//                 child: const Text("Connect"),
//                 onPressed: () {
//                   connect(adr);
//                 },
//               ),
//               const SizedBox(
//                 height: 10.0,
//               ),

//               Text(connectionStatus), // Display the connection status

//               const SizedBox(
//                 height: 10.0,
//               ),

//               ElevatedButton(
//                 child: const Text("OPEN LED"),
//                 onPressed: () {
//                   sendData("on");
//                 },
//               ),

//               const SizedBox(
//                 height: 10.0,
//               ),

//               ElevatedButton(
//                 child: const Text("CLOSE"),
//                 onPressed: () {
//                   sendData("off");
//                 },
//               ),
//               Text(data.trim()),
//               Row(
//                 children: [
//                   TextField(
//                     controller: controller,
//                     decoration:  InputDecoration(
//                         hintText: 'Enter a string data',
//                         suffixIcon: IconButton(
//                             onPressed: () {
//                               sendData(data);
//                             },
//                             icon:  const Icon(Icons.send))),
//                     onSubmitted: (value) {
//                       data = value;
//                       sendData(data);
//                       controller.clear();
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future connect(String address) async {
//     try {
//       connection = await BluetoothConnection.toAddress(address);

//       setState(() {
//         connectionStatus = 'Connected';
//       });

//       connection.input!.listen((Uint8List data) {
//         // Data entry point
//         // durum=ascii.decode(data);
//       });
//     } catch (exception) {
//       setState(() {
//         connectionStatus = 'Cannot connect, exception occurred';
//       });
//     }
//   }
// }
