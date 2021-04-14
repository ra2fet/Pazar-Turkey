import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'auth/login.dart';


class ChangeLang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              semanticsLabel: "logo",
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
               ElevatedButton(style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(30.0),
    ),padding: EdgeInsets.symmetric(horizontal:40,vertical: 20) ,   primary: btnBlue,) ,onPressed: () {
      Get.to(Login());
    }, child: Text("العربية")),

                ElevatedButton(style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(30.0),
    ),padding: EdgeInsets.symmetric(horizontal:40,vertical: 20),   primary: btnBlue,) ,onPressed: () {
      Get.to(Login());
    }, child: Text("English")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
