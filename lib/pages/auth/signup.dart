import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pazar_app/pages/auth/login.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/rbutton.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
    TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();


   signup() async {

    var response = await Constants.postUrlWithPara("api/users/addnew",{
      "fullname": fullNameController.text ,
      "email": emailController.text ,
      "mobile": phoneNumberController.text ,
      "password":passwordController.text
      });

       var body = jsonDecode(response.body);

    if (body['status'] == 200) {

       var body = jsonDecode(response.body);

        print("${body['data'][0]['user_id']}");
        print("${body['data'][0]['fullname']}");
        print("${body['data'][0]['mobile']}");
        print("${body['data'][0]['email']}");
        print("${body['data'][0]['password']}");

       print("success");

          return "success";
    }else{
      print("error in login");

     Constants.rSnackbarError("رسالة خطأ","يرجى التحقق من حسابك");

    }

    return null;

  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    PhoneNumber number = PhoneNumber(isoCode: 'TR');

   return Scaffold(
        bottomNavigationBar: Padding(
        padding:  EdgeInsets.symmetric(vertical:8),
        child: GestureDetector(child: Text("لديك حساب؟ تسجيل الدخول",textAlign: TextAlign.center,),onTap: (){ Get.back();},),
      ),
      body: Container(
        height: size.height,
        width:double.infinity,
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
                ),
              ),
              Text(
                "إنشاء حساب",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RTextBox(
                controller: fullNameController,
                ispass: false,
                hinttxt: 'الاسم الكامل'),
            SizedBox(
              height: size.height * 0.03,
            ),
                 RTextBox(
                controller: emailController,
                ispass: false,
                hinttxt: 'البريد الالكتروني'),
            SizedBox(
              height: size.height * 0.03,
            ),

              Material(
                color:  Colors.white,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(25),
                elevation: 3,
                child: Container(
                  width: size.width * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: InternationalPhoneNumberInput(locale: "ar",searchBoxDecoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.withOpacity(0.5),

                        ),
                       
                        hintText: "اختر الدولة",
                        hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.5)),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(left: 10)),
                    textAlign: TextAlign.end,
                    onInputChanged: (PhoneNumber number) {
                      print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      print(value);
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
                    ),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    inputDecoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      
                      hintText: "ادخل رقم جوالك",
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    selectorTextStyle: TextStyle(color: Colors.black),
                    textFieldController: phoneNumberController,
                    formatInput: false,
                    keyboardType: TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                ),
              ),


            SizedBox(
              height: size.height * 0.03,
            ),

            RTextBox(
                controller: passwordController, ispass: true, hinttxt: 'كلمة السر'),
            SizedBox(
              height: size.height * 0.03,
            ),

                        RTextBox(
                controller: confirmpasswordController, ispass: true, hinttxt: 'تأكيد كلمة السر'),
            SizedBox(
              height: size.height * 0.06,
            ),

            Text("بالضغط على فتح حساب فإنك توافق على"),
            Text("الشروط و الأحكام وسياسة الخصوصية"),
   
            SizedBox(
              height: size.height * 0.035,
            ),
            RButton(
                txt: "فتح حساب",
                width: 0.5,
                press: () {
                  registerAccount();
                }),




         
          ],
    ),
        ),
      ),);
  }


  void registerAccount() {
        Pattern pattern = r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)";
    RegExp reExp= new RegExp(pattern);



if(fullNameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty && phoneNumberController.text.isNotEmpty ){

       if(!reExp.hasMatch(emailController.text)){
         print("email error");

     Constants.rSnackbarError("رسالة خطأ","الايميل المدخل غير صالح , يرجى إدخال الايميل صحيح");


            return;
        }else if (passwordController.text != confirmpasswordController.text){

               Constants.rSnackbarError("رسالة خطأ","كلمة السر غير متطابقة مع حقل تأكيد كلمة السر");
            return;
        }

      signup();
    //print("register account");
   // Get.back();
               Constants.rSnackbarSuccess("رسالة ","تم إنشاء حساب بنجاح");


    Get.off(Login(),arguments: [emailController.text]);  

  }else{


                   Constants.rSnackbarError("رسالة خطأ","لا يمكن اتمام العملية بدون تعبئة جميع الحقول");

  }

  }

}
