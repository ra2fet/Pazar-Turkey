import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pazar_app/pages/auth/login.dart';
import 'package:pazar_app/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}


class _SplashPageState extends State<SplashPage> {

    bool loggedIn = false;

 Future<String> getUserName() async { 
  
           final SharedPreferences prefs = await SharedPreferences.getInstance();
            if(prefs.containsKey('fullname')){

              setState((){
                loggedIn = true;

              });
            }
}



@override
void initState() { 
getUserName();
 Timer(
     loggedIn?Duration(seconds: 0) :Duration(seconds: 4),
      () => Get.off(()=>
       loggedIn==true?Home():Login(), duration: Duration(seconds: 2)),);


super.initState();

}
  @override
  Widget build(BuildContext context) {




    return Scaffold(
      body: Center(
        child: Hero(
          tag: "logo",
          child: Container(
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              semanticsLabel: "logo",
            ),
          ),
        ),
      ),
    );
  }
}
