import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(const MainExerChangeApp());
}

class MainExerChangeApp extends StatelessWidget {
  const MainExerChangeApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'ExerChange',
      theme: ThemeData(textTheme: GoogleFonts.ibmPlexSansThaiTextTheme()),
      home: const RandomGeneratePage());
}

// Phase 1 : RandomGenerate Page (หน้าสุ่มทีมบาส)
class RandomGeneratePage extends StatefulWidget {
  const RandomGeneratePage({super.key});

  @override
  State<RandomGeneratePage> createState() => _RandomGenerateState();
}

// Phase 1 : RandomGenerate Function (สุ่มทีมบาส)
class _RandomGenerateState extends State<RandomGeneratePage>
    with TickerProviderStateMixin {
  late final TextEditingController _controller = TextEditingController();
  late ShakeDetector _shakeDetector;
  late AnimationController _controllerAnimation;
  late AnimationController _colorLogoAnimation;
  late FocusNode focusSpaceBar = FocusNode();
  List<String> player = [];
  List<String> blueTeam = [];
  List<String> redTeam = [];
  bool isTeamAssigned = false;
  bool isShuffling = false;
  bool startWithBlue = true;
  bool extraOnLeft = true;
  int lastAssignedCount = 0;

  @override
  void dispose() {
    _controller.dispose();
    _controllerAnimation.dispose();
    _colorLogoAnimation.dispose();
    focusSpaceBar.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    focusSpaceBar = FocusNode();

    _controllerAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);

    _colorLogoAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);

    if (kIsWeb) {
      if (MediaQuery.of(context).size.width > 600) {
        HardwareKeyboard.instance.addHandler(handleKeyEvent);
      } else {
        _shakeDetector = ShakeDetector.autoStart(
          shakeThresholdGravity: 3.0,
          onPhoneShake: (event) {
            onShakeDetected();
          },
        );
      }
    } else {
      if (Platform.isAndroid || Platform.isIOS) {
        _shakeDetector = ShakeDetector.autoStart(
          shakeThresholdGravity: 3.0,
          onPhoneShake: (event) {
            onShakeDetected();
          },
        );
      } else {
        HardwareKeyboard.instance.addHandler(handleKeyEvent);
      }
    }
  }

  bool handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      if (focusSpaceBar.hasFocus) {
        return false;
      } else {
        onShakeDetected();
        return true;
      }
    }
    return false;
  }

  void onShakeDetected() async {
    if (player.length >= 4) {
      if (isShuffling) return;
      setState(() {
        List<String> shuffleList = List.from(player);
        int half = shuffleList.length ~/ 2;
        int blueCount =
            half + (shuffleList.length % 2 != 0 && extraOnLeft ? 1 : 0);

        isShuffling = true;
        shuffleList.shuffle();
        extraOnLeft = Random().nextBool();

        blueTeam.clear();
        redTeam.clear();

        for (int i = 0; i < shuffleList.length; i++) {
          if (i < blueCount) {
            blueTeam.add(shuffleList[i]);
          } else {
            redTeam.add(shuffleList[i]);
          }
        }

        lastAssignedCount = player.length;
      });

      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() {
        player.shuffle();
        isShuffling = false;
        isTeamAssigned = true;
      });
    } else {
      Fluttertoast.showToast(
          msg: "ต้องมีผู้เล่นอย่างน้อย 4 คน",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFFF44336).withValues(alpha: 0.35),
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  @override
  Widget build(BuildContext context) => Material(
      color: Color(0xFF0D062C),
      child: Scaffold(body: LayoutBuilder(builder: ((context, constraints) {
        bool isMobileScreen = constraints.maxWidth > 600;

        if (kIsWeb) {
          if (isMobileScreen) {
            return desktopRandomLayout();
          } else {
            return mobileRandomLayout();
          }
        } else {
          if (Platform.isAndroid || Platform.isIOS) {
            return mobileRandomLayout();
          } else {
            return desktopRandomLayout();
          }
        }
      }))));

  // กล่องรายชื่อผู้เล่น
  Widget playerBox(String playerName, int index, {Color? boxColor}) {
    Color colorBoxInit = const Color(0xFFD9D9D9).withValues(alpha: 0.15);

    if (isTeamAssigned && index < lastAssignedCount) {
      bool isLastItem = (index == lastAssignedCount - 1);
      bool isOddTotal = (lastAssignedCount % 2) != 0;

      if (isLastItem && isOddTotal) {
        colorBoxInit = extraOnLeft
            ? Colors.blue.withValues(alpha: 0.3)
            : Colors.red.withValues(alpha: 0.3);
      } else {
        if (index % 2 == 0) {
          colorBoxInit = Colors.blue.withValues(alpha: 0.3);
        } else {
          colorBoxInit = Colors.red.withValues(alpha: 0.3);
        }
      }
    }

    return Container(
      width: (MediaQuery.of(context).size.width - 40 - 12) / 2,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: isShuffling
            ? const Color(0xFFD9D9D9).withValues(alpha: 0.15)
            : colorBoxInit,
        borderRadius: BorderRadius.circular(10.0),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
      ),
      child: isShuffling
          ? const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            )
          : Text(
              playerName,
              style: const TextStyle(
                color: Color(0xFFE1D4D5),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
    );
  }

  Widget randomStatusRow(String message, IconData icon, bool isMobile) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      isMobile
          ? Transform.rotate(
              angle: 25 * (pi * 180),
              child: Icon(
                      (isShuffling ? Icons.access_time_filled_rounded : icon)
                          as IconData?,
                      color: Color(0xFFE1D4D5).withAlpha(75))
                  .animate(
                      onPlay: ((controller) =>
                          controller.repeat(reverse: true)))
                  .shake(duration: const Duration(milliseconds: 600), hz: 4)
                  .rotate(
                      begin: -0.1,
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.easeInOutCubic),
            )
          : Icon(
              (isShuffling ? Icons.access_time_filled_rounded : icon)
                  as IconData?,
              color: Color(0xFFE1D4D5).withAlpha(75)),
      const SizedBox(width: 10.0),
      Text(isShuffling ? "กำลังสุ่มทีม..." : message,
          style: TextStyle(
            color: Color(0xFFE1D4D5).withAlpha(75),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center)
    ]);
  }

  Widget mobileRandomLayout() {
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
        SafeArea(
          child: SizedBox.expand(
            child: Stack(
              children: [
                // 🚀 1. ส่วนหัวข้อ EXERCHANGE (ใช้ AnimatedAlign แทน Positioned)
                Padding(
                  padding: const EdgeInsetsGeometry.only(top: 25, bottom: 75),
                  child:
                  AnimatedAlign(
                    alignment: player.isEmpty
                        ? AlignmentGeometry.center
                        : AlignmentGeometry.topCenter,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOutBack,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: player.isEmpty
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          AnimatedBuilder(
                            animation: _colorLogoAnimation,
                            builder: (context, child) {
                              return ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Color.lerp(
                                        const Color(0xFFFFDAD0),
                                        const Color(0xFF99837D),
                                        _colorLogoAnimation.value)!,
                                    Color.lerp(
                                        const Color(0xFF99837D),
                                        const Color(0xFFFFDAD0),
                                        _colorLogoAnimation.value)!,
                                  ],
                                  begin: AlignmentGeometry.centerLeft,
                                  end: AlignmentGeometry.centerRight,
                                ).createShader(Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height)),
                                child: child,
                              );
                            },
                            child: TweenAnimationBuilder(
                                tween: Tween<double>(
                                    begin: 48, end: player.isEmpty ? 48 : 28),
                                duration: const Duration(milliseconds: 1000),
                                builder: (context, currentSize, child) {
                                  return Text.rich(TextSpan(
                                    text: "EXER",
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: currentSize,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.white,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "CHANGE",
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: currentSize,
                                          fontWeight: FontWeight.w100,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ));
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. Player box
                if (player.isNotEmpty)
                  Positioned(
                    top: 95,
                    left: 20,
                    right: 20,
                    bottom: 135,
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 12.0,
                        alignment: WrapAlignment.start,
                        children: () {
                          List<Widget> widgetList = [];

                          for (int i = 0; i < player.length; i++) {
                            int index = i;
                            String name = player[i];
                            bool isLastItem = (index == player.length - 1);
                            bool isOddTotal = (player.length % 2) != 0;

                            if (isLastItem && isOddTotal && !extraOnLeft) {
                              double boxWidth =
                                  (MediaQuery.of(context).size.width -
                                          40 -
                                          12) /
                                      2;
                              widgetList.add(SizedBox(
                                width: boxWidth,
                                height: 1,
                              ));
                            }

                            widgetList.add(TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.bounceOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                    scale: value, child: child);
                              },
                              child: playerBox(name, index),
                            ));
                          }

                          return widgetList;
                        }(),
                      ),
                    ),
                  ),

                // 3. Box Message
                Padding(
                    padding: const EdgeInsetsGeometry.only(top: 100),
                    child: AnimatedAlign(
                      alignment: player.isEmpty
                          ? AlignmentGeometry.center
                          : AlignmentGeometry.bottomCenter,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOutBack,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (player.length >= 4) ...[
                              const SizedBox(height: 8.0),
                              isShuffling
                                  ? randomStatusRow("เขย่าโทรศัพท์เพื่อสุ่มทีม",
                                      Icons.vibration_rounded, true)
                                  : FadeTransition(
                                      opacity: _controllerAnimation,
                                      child: randomStatusRow(
                                          "เขย่าโทรศัพท์เพื่อสุ่มทีม",
                                          Icons.vibration_rounded,
                                          true)),
                              const SizedBox(height: 12.0),
                            ],

                            // กล่องพิมพ์ข้อความ
                            NameBoxMessage(
                              controller: _controller,
                              focusSpaceBar: focusSpaceBar,
                              onAddPressed: () {
                                if (_controller.text.trim().isNotEmpty) {
                                  setState(() {
                                    player.add(_controller.text.trim());
                                  });

                                  _controller.clear();
                                }
                                focusSpaceBar.unfocus();
                              },
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        )
      ],
    ));
  }

  Widget desktopRandomLayout() {
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
        SafeArea(
          child: SizedBox.expand(
            child: Stack(
              children: [
                // 🚀 1. ส่วนหัวข้อ EXERCHANGE (ใช้ AnimatedAlign แทน Positioned)
                Padding(
                  padding: const EdgeInsetsGeometry.only(top: 10, bottom: 75),
                  child: AnimatedAlign(
                    alignment: player.isEmpty
                        ? AlignmentGeometry.center
                        : AlignmentGeometry.topCenter,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOutBack,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: player.isEmpty
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          AnimatedBuilder(
                            animation: _colorLogoAnimation,
                            builder: (context, child) {
                              return ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Color.lerp(
                                        const Color(0xFFFFDAD0),
                                        const Color(0xFF99837D),
                                        _colorLogoAnimation.value)!,
                                    Color.lerp(
                                        const Color(0xFF99837D),
                                        const Color(0xFFFFDAD0),
                                        _colorLogoAnimation.value)!,
                                  ],
                                  begin: AlignmentGeometry.centerLeft,
                                  end: AlignmentGeometry.centerRight,
                                ).createShader(Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height)),
                                child: child,
                              );
                            },
                            child: TweenAnimationBuilder(
                                tween: Tween<double>(
                                    begin: 48, end: player.isEmpty ? 48 : 28),
                                duration: const Duration(milliseconds: 1000),
                                builder: (context, currentSize, child) {
                                  return Text.rich(TextSpan(
                                    text: "EXER",
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: currentSize,
                                      fontWeight: FontWeight.w200,
                                      color: Colors.white,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "CHANGE",
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: currentSize,
                                          fontWeight: FontWeight.w100,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ));
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. Player box
                if (player.isNotEmpty)
                  Positioned(
                    top: 95,
                    left: 20,
                    right: 20,
                    bottom: 135,
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 12.0,
                        alignment: WrapAlignment.start,
                        children: () {
                          List<Widget> widgetList = [];

                          for (int i = 0; i < player.length; i++) {
                            int index = i;
                            String name = player[i];
                            bool isLastItem = (index == player.length - 1);
                            bool isOddTotal = (player.length % 2) != 0;

                            if (isLastItem && isOddTotal && !extraOnLeft) {
                              double boxWidth =
                                  (MediaQuery.of(context).size.width -
                                          40 -
                                          12) /
                                      2;
                              widgetList.add(SizedBox(
                                width: boxWidth,
                                height: 1,
                              ));
                            }

                            widgetList.add(TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.bounceOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                    scale: value, child: child);
                              },
                              child: playerBox(name, index),
                            ));
                          }

                          return widgetList;
                        }(),
                      ),
                    ),
                  ),

                // 3. Box Message
                Padding(
                    padding: const EdgeInsetsGeometry.only(top: 100),
                    child: AnimatedAlign(
                      alignment: player.isEmpty
                          ? AlignmentGeometry.center
                          : AlignmentGeometry.bottomCenter,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOutBack,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (player.length >= 4) ...[
                              const SizedBox(height: 8.0),
                              isShuffling
                                  ? randomStatusRow(
                                      "กดปุ่ม SpaceBar เพื่อสุ่มทีม",
                                      Icons.space_bar_rounded,
                                      false)
                                  : FadeTransition(
                                      opacity: _controllerAnimation,
                                      child: randomStatusRow(
                                          "กดปุ่ม SpaceBar เพื่อสุ่มทีม",
                                          Icons.space_bar_rounded,
                                          false),
                                    ),
                              const SizedBox(height: 12.0),
                            ],

                            // กล่องพิมพ์ข้อความ
                            NameBoxMessage(
                              controller: _controller,
                              focusSpaceBar: focusSpaceBar,
                              onAddPressed: () {
                                if (_controller.text.trim().isNotEmpty) {
                                  setState(() {
                                    player.add(_controller.text.trim());
                                  });

                                  _controller.clear();
                                }
                                focusSpaceBar.unfocus();
                              },
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
        )
      ],
    ));
  }
}

// ส่วนกล่องพิมพ์ชื่อผู้เล่น
class NameBoxMessage extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusSpaceBar;
  final VoidCallback onAddPressed;

  const NameBoxMessage(
      {super.key,
      required this.controller,
      required this.onAddPressed,
      required this.focusSpaceBar});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ClipRRect(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(10.0)),
          child: TextField(
              focusNode: focusSpaceBar,
              controller: controller,
              maxLength: 15,
              decoration: InputDecoration(
                  counterText: '',
                  fillColor: Color(0xFFD9D9D9).withValues(alpha: 0.15),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide.none),
                  hintText: 'พูดหรือกรอกชื่อเล่น...',
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
