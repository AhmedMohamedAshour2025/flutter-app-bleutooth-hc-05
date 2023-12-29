import 'package:control_arduino/arduinocode.dart';
import 'package:control_arduino/bleutootharduino.dart';
import 'package:control_arduino/constant.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    // Initialize the pages list after selectedIndex is available
    updatePages();
  }

  void updatePages() {
    setState(() {
      pages = [
        const ArduinoBleutooth(),
        
        CodeHighlight(selectedIndex,arduinoCode,'arduino'),
        CodeHighlight(selectedIndex,flutterBleutoothCode,'dart'),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Colors.blue,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
              updatePages();
            });
          },
          items: const [
            BottomNavigationBarItem(
                label: 'Bleutooth', icon: Icon(Icons.bluetooth)),
            BottomNavigationBarItem(
                label: 'Arduino Code', icon: Icon(Icons.code)),
            BottomNavigationBarItem(label: 'Flutter Code', icon: Icon(Icons.code)),
          ]),
      body: pages.elementAt(selectedIndex),
    );
  }
}
