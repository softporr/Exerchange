import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Exerchange',
      theme: ThemeData(textTheme: GoogleFonts.ibmPlexSansThaiTextTheme()),
      home: const RandomGenerate());
}

class RandomGenerate extends StatefulWidget {
  const RandomGenerate({super.key});

  @override
  State<RandomGenerate> createState() => _RandomGenerateState();
}

class _RandomGenerateState extends State<RandomGenerate> {
  late final TextEditingController _controller = TextEditingController();
  List<String> player = [];
  List<String> randomPlayer = [];
  String user = '';
  int aniStep = 0;
  int moveStep = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Color(0xFF0D062C),
        child: Scaffold(body: LayoutBuilder(builder: ((context, constraints) {
          // 1. รองรับหน้าจอ Desktop ทั่วไป
          if (constraints.maxWidth > 600) {
            return desktopLayout();
          } else {
            //  2. รองรับหน้าจอมือถือ (Android / IOS)
            return mobileLayout();
          }
        }))
            // appBar: AppBar(
            //     centerTitle: true,
            //     title: Text('โปรแกรมการสุ่มทีมบาส'),
            //     backgroundColor: Colors.deepOrange,
            //     foregroundColor: Colors.black
            // ),
            // body:
            // mainAxisAlignment: MainAxisAlignment.center,children: [
            //   Container(
            //     margin: EdgeInsets.all(100),
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(colors: <Color>[
            //         Color(0xFF0D062C),
            //         Color(0xFFC73A1D)
            //       ])
            //     ),
            //     child: Center(
            //       child: Text(player.toString(),style: TextStyle(color: Colors.white,
            //           fontSize: 50,fontWeight: FontWeight.bold)),
            //     ),
            //   ),
            //   SizedBox(
            //     width: 150,
            //     child: TextField(
            //         controller: _textcontroller,
            //         decoration: InputDecoration(
            //           labelText: 'ชื่อเล่นนักบาส', border: OutlineInputBorder(),
            //           enabledBorder: inputBorder(),labelStyle: TextStyle(color: Colors.white)
            //           ,),
            //         style:
            //         TextStyle(color: Colors.white70)),
            //   )
            //   ,
            //   MaterialButton(onPressed: () {
            //     user = addPlayer() as String;
            //     player.last.toString();
            //   },color: Colors.deepOrange,
            //       padding: EdgeInsets.all(20)
            //       ,child: const Text('เพิ่มนักบาส',style: TextStyle(color: Colors.black87))),
            //   MaterialButton(onPressed: (){
            //     player = restorePlayer();
            //     player.toString();
            //   },color: Colors.deepOrange,
            //       padding: EdgeInsets.all(20)
            //       ,child: const Text('เล่นอีกครั้ง',style: TextStyle(color: Colors.black87))),
            // ]
            ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     setState(() {
        //       player = randomPlayerFunction(3);
        //     });
        //   },
        //   backgroundColor: Colors.deepOrange,
        //   foregroundColor: Colors.black87,
        //   child: Text('สุ่มทีม'),
        // ),
        // )
      );

  Widget mobileLayout() {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: <Color>[Color(0xFF0D062C), Color(0xFFC73A1D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        ),
        AnimatedAlign(
          alignment: moveStep == 0
              ? AlignmentGeometry.center
              : moveStep == 1
                  ? AlignmentGeometry.topStart
                  : AlignmentGeometry.bottomCenter,
          duration: Duration(milliseconds: 1000),
          curve: aniStep == 1 ? Curves.bounceOut : Curves.linear,
          child: SafeArea(
              child: Padding(
            padding: EdgeInsetsGeometry.only(
                top: 80, left: 20, right: 20, bottom: 120),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 6.0,
                runSpacing: 12.0,
                alignment: WrapAlignment.spaceEvenly,
                children: player.map((name) {
                  return Container(
                    width: (MediaQuery.of(context).size.width - 40 - 12) / 2,
                    // constraints: const BoxConstraints(minWidth: 100),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3), width: 1),
                    ),
                    child: Text(name,
                        style: const TextStyle(
                          color: Color(0xFFE1D4D5),
                          fontSize: 18, // ขนาดตัวอักษร
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                  );
                }).toList(),
              ),
            ),
          )),
        ),
        AnimatedAlign(
          alignment: player.isEmpty
              ? AlignmentGeometry.center
              : AlignmentGeometry.bottomCenter,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutBack,
          child: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: NameBoxMessage(
                    controller: _controller,
                    onAddPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        setState(() {
                          player.add(_controller.text.trim());
                          moveStep = 1;
                          aniStep = 1;
                        });

                        _controller.clear();
                      }
                    },
                  ))),
        )
      ],
    ));
  }

  Widget desktopLayout() {
    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Color(0xFF0D062C), Color(0xFFC73A1D)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
            ),
            AnimatedAlign(
              alignment: moveStep == 0
                  ? AlignmentGeometry.center
                  : moveStep == 1
                  ? AlignmentGeometry.topStart
                  : AlignmentGeometry.bottomCenter,
              duration: Duration(milliseconds: 1000),
              curve: aniStep == 1 ? Curves.bounceOut : Curves.linear,
              child: SafeArea(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(
                        top: 80, left: 20, right: 20, bottom: 120),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 12.0,
                        alignment: WrapAlignment.spaceEvenly,
                        children: player.map((name) {
                          return Container(
                            width: (MediaQuery.of(context).size.width - 40 - 12) / 2,
                            // constraints: const BoxConstraints(minWidth: 100),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3), width: 1),
                            ),
                            child: Text(name,
                                style: const TextStyle(
                                  color: Color(0xFFE1D4D5),
                                  fontSize: 18, // ขนาดตัวอักษร
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center),
                          );
                        }).toList(),
                      ),
                    ),
                  )),
            ),
            AnimatedAlign(
              alignment: player.isEmpty
                  ? AlignmentGeometry.center
                  : AlignmentGeometry.bottomCenter,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOutBack,
              child: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: NameBoxMessage(
                        controller: _controller,
                        onAddPressed: () {
                          if (_controller.text.trim().isNotEmpty) {

                            setState(() {
                              player.add(_controller.text.trim());
                              moveStep = 1;
                              aniStep = 1;
                            });

                            _controller.clear();
                          }
                        },
                      ))),
            )
          ],
        ));
  }

  List<String> addPlayer() {
    player.add(_controller.text);
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

  restorePlayer() {
    player.addAll(randomPlayer);
    randomPlayer.clear();
    return player;
  }

  OutlineInputBorder inputBorder() {
    return OutlineInputBorder(borderSide: BorderSide(color: Colors.white));
  }
}

class NameBoxMessage extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAddPressed;

  const NameBoxMessage(
      {super.key, required this.controller, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ClipRRect(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(10.0)),
          child: TextField(
              controller: controller,
              maxLength: 15,
              decoration: InputDecoration(
                  fillColor: Color(0xFFD9D9D9).withValues(alpha: 0.15),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none),
                  hintText: 'พูดหรือกรอกชื่อนักบาส...',
                  hintStyle: TextStyle(
                      color: Color(0xFFBF9E9F).withValues(alpha: 0.35),
                      fontWeight: FontWeight.bold),
                  suffixIcon: Padding(
                    padding: EdgeInsetsGeometry.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //   ปุ่มที่ 1 : ปุ่มไมค์
                        IconButton(
                          icon: Icon(Icons.mic),
                          color: Color(0xFFBF9E9F),
                          onPressed: () {
                            onAddPressed();
                          },
                        ),
                        //   ปุ่มที่ 2 : ปุ่มเพิ่มชื่อ
                        IconButton(
                          icon: Icon(Icons.add),
                          color: Color(0xFFBF9E9F),
                          onPressed: () {
                            onAddPressed();
                          },
                        ),
                      ],
                    ),
                  )),
              style: TextStyle(
                  color: Color(0xFFBF9E9F), fontWeight: FontWeight.bold),
              cursorColor: Color(0xFFBF9E9F))),
    );
  }
}
