import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pazar_app/pages/home.dart';
import 'package:pazar_app/pages/auth/login.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/rbutton.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailnumController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController validateCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                 Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 25, left: 15),
                  child: IconButton(
                      color: btnYellow,
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Get.back()),
                ),),
              SizedBox(
                height: size.height * 0.1,
              ),
              Container(
                height: size.height * 0.25,
                child: SvgPicture.asset(
                  "assets/images/logo.svg",
                  semanticsLabel: "logo",
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              RTextBox(
                  controller: emailnumController,
                  ispass: false,
                  hinttxt: '???????? ???????????? ???????????????????? ???????????? ??????????'),
              SizedBox(
                height: size.height * 0.06,
              ),
           
              RButton(
                  txt: "?????????????? ???????? ????????????",
                  width: 0.5,
                  press: () => validateCode()),
            ],
          ),
        ),
      ),
    );
  }

  void validateCode() {
    Pattern pattern = r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)";
    RegExp reExp = new RegExp(pattern);

    if (emailnumController.text.isEmpty) {


      Constants.rSnackbarError("?????????? ??????", "???????? ?????????? ?????????????? ?????? ?????????? ?????? ???? ?????????????? ???????? ????????????");

      
    } else if (!reExp.hasMatch(emailnumController.text)) {



       Constants.rSnackbarError("?????????? ??????", "?????????????? ???????????? ?????? ???????? , ???????? ?????????? ?????????????? ????????");

     
      return;
    } else {
      Get.defaultDialog(
          title: "",
          content: Text(" ???? ?????????? ???????? ???????????? ?????? ?????????????? ?????????? "),
          actions: [
            TextButton(onPressed: () => Get.off(Login()), child: Text("??????????"))
          ]);
      return;
    }
  }

  void sendActiveCodeAgain() {
    print("send code again");
  }
}
