import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hangman/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: MyRoute().getRoute,
      builder: (context, child) {
        ScreenUtil.instance = ScreenUtil(width: 441, height: 683)
          ..init(context);
        return child;
      },
      theme: ThemeData(
          fontFamily: "McLaren",
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.green.shade100),
    );
  }
}
