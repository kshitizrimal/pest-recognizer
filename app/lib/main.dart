import 'package:flutter/material.dart';
import 'package:pestrecog/pages/past_record.dart';
import 'package:pestrecog/pages/home.dart';
import 'package:pestrecog/pages/detect.dart';
import 'package:pestrecog/pages/classes.dart';
import 'package:pestrecog/pages/language.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/services.dart';

void main(){
  runApp(HomeLoad());
}

class HomeLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PestLanding(),
    );
  }
}


class PestLanding extends StatefulWidget {
  @override
  _PestLandingState createState() => _PestLandingState();
}

class _PestLandingState extends State<PestLanding> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/detect': (context) => Detect(),
        '/classes': (context) => Classes(),
        '/language': (context) => Language(),
        '/past': (context) => PastRecord(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


