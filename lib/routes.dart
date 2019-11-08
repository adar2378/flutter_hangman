import 'package:flutter/material.dart';
import 'package:hangman/views/home_screen.dart';

class MyRoute {
  Route getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(settings, HomeScreen());
      default:
        return _buildRoute(settings, Container());
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    print(builder.runtimeType);
    return MaterialPageRoute(
      settings: settings,
      maintainState: true,
      builder: (BuildContext context) => builder,
    );
  }
}
