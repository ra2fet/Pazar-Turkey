import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar_app/pages/auth/login.dart';
import 'package:pazar_app/pages/profile_edit.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
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
        title: Text("الملف الشخصي"),
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            SizedBox(
              height: 35,
            ),
            GestureDetector(
              onTap: () => filterBtn(1),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  child: Text("تعديل الملف الشخصي",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                ),
                new Container(
                    height: 8,
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                    child: Divider(
                      color: btnBlue,
                      thickness: 1.5,
                    )),
              ]),
            ),
            SizedBox(
              height: 35,
            ),
            GestureDetector(
              onTap: () => filterBtn(2),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  child: Text("تسجيل الخروج",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                ),
                new Container(
                    height: 8,
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 40.0, right: 40.0),
                    child: Divider(
                      color: btnBlue,
                      thickness: 1.5,
                    )),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

filterBtn(int selected) async {
  if (selected == 1) {
    Get.to(ProfileEdit());
    
  } else if (selected == 2) {

    SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
    Get.off(Login());
  }
}
