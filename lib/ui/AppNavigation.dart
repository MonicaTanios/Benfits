import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';
import 'Benefits.dart';
import 'EditProfile.dart';
import 'HomePage.dart';
import 'Messages.dart';
import 'More.dart';

class HomeNavigation extends StatelessWidget {
  final int current;

  HomeNavigation(this.current);

  @override
  Widget build(BuildContext context) {
    if (current == 0)
      return MaterialApp(
        title: 'Eva pharma',
        home: HomePage(),
      );
    else if (current == 1)
      return MaterialApp(
        title: 'Eva pharma',
        home: Benefits(),
      );
    else if (current == 2)
      return MaterialApp(
        title: 'Eva pharma',
        home: Messages(),
      );
    return MaterialApp(
      title: 'Eva pharma',
      home: More(),
    );
  }
}


