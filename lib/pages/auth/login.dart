import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pazar_app/pages/forget_password.dart';
import 'package:pazar_app/pages/home.dart';
import 'package:pazar_app/pages/auth/signup.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/rbutton.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailnumController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController validateCodeController = TextEditingController();



   login() async {

    var response = await Constants.postUrlWithPara("api/users/get_user",{"username": emailnumController.text ,"password":passwordController.text});

       var body = jsonDecode(response.body);

    if (body['status'] == 200) {

       var body = jsonDecode(response.body);

        print("${body['data'][0]['user_id']}");
        print("${body['data'][0]['fullname']}");
        print("${body['data'][0]['mobile']}");
        print("${body['data'][0]['email']}");
     //   print("${body['data'][0]['password']}");

       print("success");


saveLogin(int.parse(body['data'][0]['user_id']),body['data'][0]['fullname'],body['data'][0]['mobile'], body['data'][0]['email'], body['data'][0]['password']);

            Get.off(()=> Home());

          return "success";
    }else{
      print("error in login");

     Constants.rSnackbarError("رسالة خطأ","يرجى التحقق من حسابك");

    }

    return null;

  }

   saveLogin(int userid,String fullname, String password,String email , String mobile) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();

        myPrefs.setInt("user_id", userid );
        myPrefs.setString("fullname",fullname );
        myPrefs.setString("mobile", mobile);
        myPrefs.setString("email",email);
        myPrefs.setString("password",password);
  }


@override
void initState() { 
  super.initState();
  
      var one = Get.arguments;
      if(one !=null){
            emailnumController.text = one[0];
      }
}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: GestureDetector(
          child: Text(
            "ليس لديك حساب ؟ فتح حساب جديد",
            textAlign: TextAlign.center,
          ),
          onTap: () {
            Get.to(SignUp());
          },
        ),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              Hero(
                tag:"logo" ,
                child: Container(
                  height: size.height * 0.25,
                  child: SvgPicture.asset(
                    "assets/images/logo.svg",
                    semanticsLabel: "logo",
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              RTextBox(
                  controller: emailnumController,
                  ispass: false,
                  hinttxt: 'البريد الالكتروني أو رقم الجوال'),
              SizedBox(
                height: size.height * 0.03,
              ),
              RTextBox(
                  controller: passwordController,
                  ispass: true,
                  hinttxt: 'كلمة السر'),
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    child: Text(
                      "نسيت كلمة المرور؟",
                      textAlign: TextAlign.start,
                    ),
                    onPressed: () {
                      forgetPass();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.035,
              ),
              RButton(
                  txt: "تسجيل الدخول",
                  width: 0.5,
                  press: () {


                 login();   
                    //validateCode();
                    //Get.off(Home());
  

                  }),

       Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    child: Text(
                      " الدخول للتطبيق بدون تسجيل",
                      textAlign: TextAlign.start,
                    ),
                    onPressed: () {
                       Get.to(Home());
                    },
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void validateCode() {
    Get.defaultDialog(
        title: null,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Text('الكود التفعيلي'),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: RTextBox(
                  controller: validateCodeController,
                  ispass: true,
                  hinttxt: 'أدخل الكود'),
            ),
            SizedBox(
              height: 30.0,
            ),
            RButton(
                txt: "تفعيل",
                width: 0.5,
                press: () {
                  activeCode();
                }),
            SizedBox(
              height: 10.0,
            ),
            TextButton(
              child: Text(
                "إعادة إرسال الكود",
                textAlign: TextAlign.center,
                style: TextStyle(color: btnYellow),
              ),
              onPressed: () => sendActiveCodeAgain(),
            ),
          ],
        ),
        radius: 10.0);
  }

  void activeCode() {
    print("activited");
  }

  void sendActiveCodeAgain() {
    print("send code again");
  }

  void forgetPass() {
    Get.to(ForgetPassword());
  }
}
