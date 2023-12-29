import 'package:arrow_pad/arrow_pad.dart';
import 'package:flutter/material.dart';

class ControlDirection extends StatefulWidget {
  ControlDirection({Key? key}) : super(key: key);

  @override
  State<ControlDirection> createState() => _ControlDirectionState();
}

class _ControlDirectionState extends State<ControlDirection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ArrowPad(
            arrowPadIconStyle: ArrowPadIconStyle.arrow,
            width: 200,
            onPressedUp: () {
              print('up');
            },
            onPressedLeft: () {
              print('left');
            },
            onPressedRight: () {
              print('right');
            },
            onPressedDown: () {
              print('down');
            }),
      ),
    );
  }
}
