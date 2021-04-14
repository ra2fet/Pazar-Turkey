import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/rbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {

String username,useremail,userpassword,usermobile,uid;

bool loading = true;

 Future<String> getUserInfo() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("user_id");

   var response = await Constants.getUrl("api/users/get/$userid");

       if (response.statusCode == 200) {

    var body = json.decode(response.body);
     print(body["data"]);
      uid = body["data"][0]["user_id"];
      username = body["data"][0]["fullname"];
      useremail = body["data"][0]["email"];
      usermobile = body["data"][0]["mobile"];
      userpassword = body["data"][0]["password"];


setState(() {
  
});
    return "Success";

       }
       return null;

  }
TextEditingController fullname = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController mobilenumber = TextEditingController();
    TextEditingController password = TextEditingController();


  @override
  void initState() { 
    super.initState();
    
    getUserInfo().then((value) {

 fullname.text = username;
email.text = useremail;
mobilenumber.text = usermobile;
password.text = userpassword;

loading = false;

    }
    

    );


  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
   
    

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text("تعديل الملف الشخصي"),
      ),
      body: loading?Center(child: CircularProgressIndicator(),) :Container(
        height: size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(
              height: 35,
            ),
            RTextBox(
              controller: fullname,
              ispass: false,
              hinttxt: "الاسم الكامل",
              width: 0.8,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RTextBox(
              controller: email,
              ispass: false,
              hinttxt: "البريد الالكتروني",
              width: 0.8,
              type: TextInputType.emailAddress,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RTextBox(
              controller: mobilenumber,
              ispass: false,
              hinttxt: "رقم الجوال",
              width: 0.8,
              type: TextInputType.number,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RTextBox(
              controller: password,
              ispass: true,
              hinttxt: "كلمة السر الجديدة",
              width: 0.8,
              type: TextInputType.number,
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            RButton(
                txt: "تعديل الملف", press: () => submitBtn(context,uid,fullname.text,email.text,mobilenumber.text,password.text), width: 0.4)
          ]),
        ),
      ),
    );
  }
}

submitBtn(context,userid, name, email, mobile, pass) {
  Timer _timer;
  showDialog(  barrierDismissible: false,

      context: context,
      builder: (BuildContext builderContext) {
        _timer = Timer(Duration(seconds: 2), () {
          Navigator.of(context).pop();
       //   Navigator.of(context).pop();

          Requests.editProfileInfo(userid, name, email, mobile, pass);

        });

        return AlertDialog(
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  '...يتم تعديل الملف الشخصي',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      }).then((val) {

    if (_timer.isActive) {
      _timer.cancel();
    }
  });

  print("editing now...");
}
