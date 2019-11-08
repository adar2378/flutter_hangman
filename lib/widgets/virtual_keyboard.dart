import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VirtualKeyBoard extends StatefulWidget {
  final ValueChanged<String> onTap;
  VirtualKeyBoard({@required this.onTap});
  @override
  _VirtualKeyBoardState createState() => _VirtualKeyBoardState();
}

class _VirtualKeyBoardState extends State<VirtualKeyBoard> {
  List<bool> stateofKey;
  @override
  void initState() {
    super.initState();
    stateofKey = List<bool>.generate(26, (i) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      alignment: WrapAlignment.center,
      spacing: 8,
      children: keyBoardBuilder(),
    );
  }

  List<Widget> keyBoardBuilder() {
    var resultList = <Widget>[];

    for (int i = 0; i < alphabets.length; i++) {
      resultList.add(GestureDetector(
        onTap: stateofKey[i]
            ? null
            : () {
                widget.onTap(alphabets[i]);
                setState(() {
                  stateofKey[i] = true;
                });
              },
        child: AnimatedContainer(
          height: ScreenUtil.getInstance().setHeight(40),
          width: ScreenUtil.getInstance().setWidth(40),
          decoration:
              BoxDecoration(color: !stateofKey[i] ? Colors.green : Colors.grey),
          duration: Duration(milliseconds: 300),
          child: Center(
              child: Text(
            alphabets[i],
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          )),
        ),
      ));
    }

    return resultList;
  }

  var alphabets = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
  ];
}
