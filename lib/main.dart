import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'โปรแกรมการสุ่มทีมบาส',
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            textTheme: GoogleFonts.chakraPetchTextTheme()
        ),
        home: const RandomGenerate(),
        darkTheme: ThemeData.dark(););
  }
}

class RandomGenerate extends StatefulWidget {
  const RandomGenerate({super.key});

  @override
  State<RandomGenerate> createState() => _RandomGenerateState();
}

class _RandomGenerateState extends State<RandomGenerate> {
  final _textcontroller = TextEditingController();
  List<String> player = [];
  List<String> randomPlayer = [];
  String user = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('โปรแกรมการสุ่มทีมบาส')),
      body: Container(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.center,children: [
              Container(
                child: Center(
                  child: Text(player.toString(),style: TextStyle(color: Colors.white,
                      fontSize: 50,fontWeight: FontWeight.bold)),
                ),margin: EdgeInsets.all(100),
              ),
              SizedBox(
                width: 150,
                  child: TextField(
                      controller: _textcontroller,
                      decoration: InputDecoration(
                        labelText: 'ชื่อเล่นนักบาส', border: OutlineInputBorder(),
                        enabledBorder: inputBorder(),labelStyle: TextStyle(color: Colors.white)
                        ,),
                      style:
                      TextStyle(color: Colors.white70)),
              )
              ,
          MaterialButton(onPressed: () {
            user = addPlayer();
            player.last.toString();
          },color: Colors.deepOrange,
          padding: EdgeInsets.all(20)
          ,child: const Text('เพิ่มนักบาส',style: TextStyle(color: Colors.black87))),
          MaterialButton(onPressed: (){
            player = restorePlayer();
            player.toString();
          },color: Colors.deepOrange,
          padding: EdgeInsets.all(20)
          ,child: const Text('เล่นอีกครั้ง',style: TextStyle(color: Colors.black87))),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            player = randomPlayerFunction(3);
          });
        },
        child: Text('สุ่มทีม'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.black87,
      ),
    );
  }
  addPlayer() {
    player.add(_textcontroller.text);
    return player;
  }

  randomPlayerFunction(int length) {
    Random random = new Random();
    for (String i in player) {
      int value = random.nextInt(player.length);
      randomPlayer.add(player[value]);
      player.remove(player[value]);
    }
    return randomPlayer;
  }

  restorePlayer(){
    player.addAll(randomPlayer);
    randomPlayer.clear();
    return player;
  }

  OutlineInputBorder inputBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white)
    );
  }
}