import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as f;

import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/rbutton.dart';

class Reminder extends StatelessWidget {
      TextEditingController fullNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController residenceEndDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("ذكرني"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          )),
      body: Container(
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "هي خدمة الكترونية لتذكيركم باقتراب تاريخ انتهاء اقامتكم بالوقت المحدد المطلوب , يرجي ادخال البيانات للاشتراك بالخدمة",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 16.5),
                ),
              ),
              SizedBox(
                height: 20,
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
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(25),
                elevation: 3,
                color: Colors.white,
                child: Container(
                  width: size.width * 0.8,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: InternationalPhoneNumberInput(
                    locale: "ar",
                    searchBoxDecoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        hintText: "ابحث عن الدولة",
                        hintTextDirection: f.TextDirection.rtl,
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
              Material(
                shadowColor: Colors.grey,
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                elevation: 3,
                child: Container(
                  width: size.width * 0.8,
                  height: 50,
                  child: DateTimePicker(
                    textAlign: TextAlign.right,
                    controller: residenceEndDateController,
                    dateHintText: "اختر تاريخ انتهاء الإقامة",
                    fieldHintText: "اختر تاريخ انتهاء الإقامة",
                    type: DateTimePickerType.date,
                    calendarTitle: "تاريخ انتهاء الإقامة",
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      hintText: "تاريخ انتهاء الإقامة",
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(right: 15),
                    ),
                    dateMask: 'dd/MM/yyyy',
                    //  initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),

                    onChanged: (val) => print(val),
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => print(val),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              RButton(txt: "حفظ البيانات", press: () => _saveData(), width: 0.4),
            ],
          ),
        ),
      ),
    );


    
  }

  void _saveData() {
        Pattern pattern = r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)";
    RegExp reExp= new RegExp(pattern);

    if(fullNameController.text.isEmpty){

                 Constants.rSnackbarError("رسالة خطأ", "يجب أن لا يكون الاسم الكامل فارغ");


    }
    else if(emailController.text.isEmpty){
             Constants.rSnackbarError("رسالة خطأ", "يجب أن لا يكون الايميل فارغ");

}
    else if(!reExp.hasMatch(emailController.text)){

       Constants.rSnackbarError("رسالة خطأ", "الايميل المدخل غير صالح , يرجى إدخال الايميل صحيح");

}
    else if(phoneNumberController.text.isEmpty){

         Constants.rSnackbarError("رسالة خطأ", "يجب أن لا يكون رقم الموبايل فارغ");

      
}
    else if(residenceEndDateController.text.isEmpty){


              Constants.rSnackbarError("رسالة خطأ", "يجب أن لا يكون تاريخ الإقامة فارغ");

   
    }
  else{

           Constants.rSnackbarSuccess("رسالة ", "تم إرسال الطلب بنجاح, شكراً لكم لاستخدام خدمتنا");

  }
   
  }

 
}
