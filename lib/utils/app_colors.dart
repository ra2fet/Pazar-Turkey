import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
// our colors
const btnYellow = Color(0xFFFAC70C);
const btnBlue = Color(0xFF82A2F6);
const primaryColor = Color(0xFF11357c);
const  txtColor = Color(0xFF152939);




 Color randomColor() {
    return Color(Random().nextInt(0xff00ffff));
  }

   Color randomOpaqueColor() {
  return Color(Random().nextInt(0xffffffff)).withAlpha(0xff);
}



/* const List<Color> colorsList = [
  Colors.cyan,Colors.teal[800],Colors.blue,Colors.yellow[800],Colors.red, Colors.green,Colors.grey,Colors.pink[800],Colors.brown[800]
] */


 List<Color> hexColor = [ Colors.cyan,Colors.teal[800],Colors.blue,Colors.yellow[800],Colors.red, Colors.green,Colors.grey,Colors.pink[800],Colors.brown[800]];



   final _random = Random();

  Color rcolorRandom() {
    
    return hexColor[_random.nextInt(hexColor.length)];
  }