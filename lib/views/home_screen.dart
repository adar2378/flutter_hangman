import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hangman/models/body_parts.dart';
import 'package:hangman/models/painter_model.dart';
import 'package:hangman/widgets/custom_painter.dart';
import 'package:hangman/widgets/virtual_keyboard.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Map<BodyPart, PainterModel> painterModels = {};

  List<AnimationController> animationControllerList = [];
  List<Animation<double>> animationList = [];
  Animation<double> decimalVariation;
  int wrongAnswerCounter = 0;
  String guessedLetter = "";

  List<String> fieldLetters;
  String targetWord = "TowTow".toLowerCase();
  AudioCache audioCache = AudioCache();
  @override
  void initState() {
    super.initState();
    fieldLetters = List.generate(6, (i) => "");
    assignControllers();
  }

  Future playSound() async {
    await audioCache.play('/sound/effect.mp3', mode: PlayerMode.LOW_LATENCY);
  }

  void assignControllers() {
    for (int i = 0; i < 6; i++) {
      painterModels[BodyPart.values[i]] = PainterModel(0, false);
      animationControllerList.add(AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1400),
        upperBound: 1,
        lowerBound: 0,
      ));
      animationList.add(Tween<double>(begin: 0.0, end: 100).animate(
          CurvedAnimation(
              parent: animationControllerList[i],
              curve: Curves.easeInCirc,
              reverseCurve: Curves.easeOut)));
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < 6; i++) {
      animationControllerList[i].dispose();
    }
    super.dispose();
  }

  void drawBodyPart(BodyPart bodyPart) async {
    await playSound();
    animationControllerList[bodyPart.index].forward();
    animationList[bodyPart.index].addListener(() {
      setState(() {
        if (!painterModels[bodyPart].shouldPaint) {
          painterModels[bodyPart].shouldPaint = true;
        }
        painterModels[bodyPart].percentage =
            animationList[bodyPart.index].value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: ScreenUtil.getInstance().setHeight(50),
          ),
          Center(
            child: Container(
              height: ScreenUtil.getInstance().setHeight(200),
              width: ScreenUtil.getInstance().setWidth(130),
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width,
                    ScreenUtil.getInstance().setWidth(130)),
                painter: MyPainter(
                  circlePainter: painterModels[BodyPart.head],
                  bodyPainter: painterModels[BodyPart.body],
                  leftHandPainter: painterModels[BodyPart.leftHand],
                  leftLegPainter: painterModels[BodyPart.leftLeg],
                  rightHandPainter: painterModels[BodyPart.rightHand],
                  rightLegPainter: painterModels[BodyPart.rightLeg],
                ),
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil.getInstance().setHeight(16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _generateFields(),
            ),
          ),
          SizedBox(
            height: ScreenUtil.getInstance().setHeight(16),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                guessedLetter,
                style: TextStyle(fontSize: 30, color: Colors.black54),
              )),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: VirtualKeyBoard(onTap: (letter) {
              setState(() {
                guessedLetter = letter;
                checkAndReveal(guessedLetter);
              });
            }),
          )
        ],
      ),
    );
  }

  checkAndReveal(String character) {
    bool found = false;
    for (int i = 0; i < 6; i++) {
      if (fieldLetters[i].length == 0) {
        if (character == targetWord[i]) {
          fieldLetters[i] = character;
          found = true;
        }
      }
    }
    if (!found) {
      drawBodyPart(BodyPart.values[wrongAnswerCounter]);
      wrongAnswerCounter++;

      if (wrongAnswerCounter == 6) {
        Future.delayed(Duration(seconds: 2), () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Game Over"),
                );
              });
        });
      }
    }
    setState(() {});
  }

  List<Widget> _generateFields() {
    var result = <Widget>[];
    for (int i = 0; i < 6; i++) {
      result.add(Container(
        height: ScreenUtil.getInstance().setHeight(40),
        width: ScreenUtil.getInstance().setHeight(30),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Center(
            child: Text(
          fieldLetters[i],
          style: TextStyle(color: Colors.black, fontSize: 20),
        )),
      ));
    }
    return result;
  }
}
