String arduinoCode = '''/*
1-read distance and assign it 
2-move forward till curr_dist = 10cm
3-U_turn
4-read distance and compare it with prevoius read
5-same ? yes --> step 2
         no  --> obstacile_detected
*/
#include<Servo.h>
//---Motor_driver---
#define en1 6 //PWM
#define in1 7
#define in2 8

#define en2 5 //PWM
#define in3 3
#define in4 4
//---Ultrasonic---
#define echo A3
#define trig 13
//---Horizontal_IR---
#define R_IR A0
#define L_IR A1 
//---Vertical_IR---
#define V_IR A2
//---Sweep & mop---
#define sweep 10
#define mop   11 
//---Variables---
byte DIR = 1 ;
byte bumpcount = 0 ; 
int t=0;
float d=0;
float F_dist=0;
float R_dist=0;
float L_dist=0;
float Room_width=0;
Servo servo;
//---Function_prototype---
void bluetooth();
void Forward();
void Backward();
void Left();
void Right();
void Stop();
float Distance();
void Direction_detected();
void navigation();
void U_Turn();
void bump();
void obstacle_detected();

void setup() {
  //---Bluetooth---
  Serial.begin(9600);
  //---Motor_driver---
  pinMode(en1,OUTPUT);
  pinMode(in1,OUTPUT);
  pinMode(in2,OUTPUT);

  pinMode(en2,OUTPUT);
  pinMode(in3,OUTPUT);
  pinMode(in4,OUTPUT);
  //---Ultrasonic---
  pinMode(trig,OUTPUT);
  pinMode(echo,INPUT);
  //---SERVO---
  servo.attach(9); //PWM
  //---init_values---
  servo.write(85);
  analogWrite(sweep,150);
  analogWrite(mop,150);
  //---init_Functions---
  Direction_detect();
}

void loop() {
  //while(Serial.available()){bluetooth();}
  navigation();
}

void bluetooth()
{
    char rec = Serial.read();
    if(rec == 'A'){Forward();}
    if(rec == 'B'){Backward();}
    if(rec == 'C'){Left();}
    if(rec == 'D'){Right();}
    if(rec == 'E'){Stop();}
}

void Forward()
{
  analogWrite(en1,255);
  digitalWrite(in1,HIGH);
  digitalWrite(in2,LOW);
  
  analogWrite(en2,255);
  digitalWrite(in3,HIGH);
  digitalWrite(in4,LOW);
}

void Backward()
{
  analogWrite(en1,255);
  digitalWrite(in1,LOW);
  digitalWrite(in2,HIGH);
  
  analogWrite(en2,255);
  digitalWrite(in3,LOW);
  digitalWrite(in4,HIGH);
}

void Left()
{
  analogWrite(en1,150);
  digitalWrite(in1,HIGH);
  digitalWrite(in2,LOW);
  
  analogWrite(en2,150);
  digitalWrite(in3,LOW);
  digitalWrite(in4,HIGH);
}

void Right()
{
  analogWrite(en1,150);
  digitalWrite(in1,LOW);
  digitalWrite(in2,HIGH);
  
  analogWrite(en2,150);
  digitalWrite(in3,HIGH);
  digitalWrite(in4,LOW);
}

void Stop()
{
  analogWrite(en1,0);
  digitalWrite(in1,LOW);
  digitalWrite(in2,LOW);
  
  analogWrite(en2,0);
  digitalWrite(in3,LOW);
  digitalWrite(in4,LOW);
}

float Distance()
{
  digitalWrite(trig,LOW);
  delayMicroseconds(10);
  digitalWrite(trig,HIGH);
  delayMicroseconds(10);
  digitalWrite(trig,LOW);
  t=pulseIn(echo,HIGH);
  d=t/58.0 ;
  return d ;
}

void Direction_detect()
{
  Room_width = Distance();
  
  servo.write(180);
  delay(100);
  L_dist=Distance();
  delay(100);
  servo.write(0);
  delay(100);
  R_dist=Distance();
  
  if( R_dist >=  L_dist){DIR == 1;}
  if( R_dist <  L_dist){DIR == -1;}
  
  servo.write(85);
  
}
void U_Turn()
{
  if(DIR == 1){
    Right();
    bump();
    delay(100);
    Stop();
    delay(100);
    Forward();
    delay(100);
    Stop();
    delay(100);
    Right();
    delay(100);
  }
  if(DIR == -1){
    Left();
    bump();
    delay(100);
    Stop();
    delay(100);
    Forward();
    delay(100);
    Stop();
    delay(100);
    Left();
    delay(100);
  }
  DIR = DIR * -1 ;
}

void obstacle_detected()
{
  F_dist=Distance();
  while(F_dist > 10)
  {
      Forward();
      delay(10);
      F_dist=Distance();
      delay(10);
  }
  servo.write(130);
  delay(100);
  L_dist=Distance();
  delay(100);
  servo.write(40);
  delay(100);
  R_dist=Distance();
  
  if( R_dist >=  L_dist)
  {
    Right();
    delay(100);
    Stop();
    delay(100);
    Forward();
    delay(100);
    Stop();
    delay(100);
    Left();
    delay(100);
    while(L_IR == 0){Forward();}
    Stop();
    delay(100);
    Left();
    delay(100);
    Stop();
    delay(100);
    Right();
    delay(100);
  }
  if( R_dist <  L_dist)
  {
    Left();
    delay(100);
    Stop();
    delay(100);
    Forward();
    delay(100);
    Stop();
    delay(100);
    Right();
    delay(100);
    while(R_IR == 0){Forward();}
    Stop();
    delay(100);
    Right();
    delay(100);
    Stop();
    delay(100);
    Left();
    delay(100);
  }

  servo.write(85);
}

void bump()
{
  F_dist=Distance();
  if(F_dist < 10){ bumpcount++ ;}
}
void navigation()
{
  if(bumpcount != 2){
      F_dist=Distance();
      if(abs(F_dist-Room_width) < 5){
          while(F_dist > 10)
          {
            Forward();
            delay(10);
            F_dist=Distance();
            delay(10);
          }
          U_Turn();
      }
      else
      {
        obstacle_detected();
      }
  }
  else
  {
    Stop();
  }
}

      
''';
const String flutterBleutoothCode  = '''import 'dart:async';
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
          'Unable to reach the HC-05 module.Please check the connection and try again');
      setState(() {
        reachData = false;
        dataStatus =
            'unable to reach the HC-05 module.please check the connection and try again';
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
 
''';