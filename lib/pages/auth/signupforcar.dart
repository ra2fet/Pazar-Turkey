import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as f;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pazar_app/models/car_model.dart';
import 'package:pazar_app/pages/home.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/rbutton.dart';


class SignUpCar extends StatefulWidget {

    final CarModel carModel;
  final totalPrice, cdays,carname;
  final String pickupdate,dropoffdate,locationfrom , locationto;

  const SignUpCar({Key key, this.carModel, this.totalPrice, this.cdays, this.carname, this.pickupdate, this.dropoffdate, this.locationfrom, this.locationto}) : super(key: key);


  @override
  _SignUpCarState createState() => _SignUpCarState();
}

class _SignUpCarState extends State<SignUpCar> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passportNumberController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController _nationalityController = TextEditingController();

  TextEditingController _birthdayDateController = TextEditingController();

  String mynationalityselection;
  @override
  Widget build(BuildContext context) {

    print(" ${widget.cdays}  ${widget.totalPrice}   ${widget.carname}");
    var size = MediaQuery.of(context).size;
    PhoneNumber number = PhoneNumber(isoCode: 'TR');

    return Scaffold(
      /*    bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: GestureDetector(
          child: Text(
            "???????? ?????????? ?????????? ????????????",
            textAlign: TextAlign.center,
          ),
          onTap: () {
            Get.back();
          },
        ),
      ), */
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
                ),
              ),
              Text(
                "?????????????? ??????????",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              RTextBox(
                  controller: fullNameController,
                  ispass: false,
                  hinttxt: '?????????? ????????????'),
              SizedBox(
                height: size.height * 0.03,
              ),
              RTextBox(
                  controller: emailController,
                  ispass: false,
                  hinttxt: '???????????? ????????????????????'),
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
                        hintText: "???????? ???? ????????????",hintTextDirection: f.TextDirection.rtl,
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
                      hintText: "???????? ?????? ??????????",
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

              /*    RTextBox(
                  controller: phoneNumberController,
                  ispass: false,
                  hinttxt: '?????? ????????????'), */
              SizedBox(
                height: size.height * 0.03,
              ),
              RTextBox(
                  controller: passportNumberController,
                  ispass: false,
                  hinttxt: '?????? ????????????'),
              SizedBox(
                height: size.height * 0.03,
              ),
              Directionality(
                textDirection: f.TextDirection.rtl,
                child: Material(
                  shadowColor: Colors.grey,
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  elevation: 3,
                  child: Container(
                    width: size.width * 0.8,
                    child: DropdownSearch<String>(
                      popupItemBuilder: _customPopupItemBuilder,
                      searchBoxController: _nationalityController,
                      searchBoxDecoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          hintText: "???????? ???? ????????????",
                          hintTextDirection: f.TextDirection.rtl,
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(0.5)),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 10)),
                      popupTitle: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "???????? ??????????????",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      showSearchBox: true,
                      hint: "??????????????",
                      items: Requests.natList,

                      dropdownSearchDecoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.only(right: 10),
                      ),
                      onChanged: (String v) {
                        mynationalityselection = v;
                        print(mynationalityselection);
                      },
                    ),
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
                    controller: _birthdayDateController,
                    timeHintText: "Pick up Time",
                    dateHintText: "???????? ?????????? ?????????????? ",
                    fieldHintText: "???????? ?????????? ??????????????",
                    type: DateTimePickerType.date,
                    calendarTitle: "?????????? ??????????????",
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      hintText: "?????????? ??????????????",
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(right: 15),
                    ),
                    dateMask: 'd MMM, yyyy',
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
                height: size.height * 0.03,
              ),
              RButton(
                  txt: "???????? ????????",
                  width: 0.5,
                  press: () {
                    registerAccount();
                  }),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerAccount() {
    Pattern pattern = r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)";
    RegExp reExp= new RegExp(pattern);



if(fullNameController.text.isNotEmpty && emailController.text.isNotEmpty && phoneNumberController.text.isNotEmpty || passportNumberController.text.isNotEmpty  ||

 _nationalityController.text.isNotEmpty || _birthdayDateController.text.isNotEmpty){


       if(!reExp.hasMatch(emailController.text)){
         print("email error");

          Constants.rSnackbarError("?????????? ??????","?????????????? ???????????? ?????? ???????? , ???????? ?????????? ?????????????? ????????");

            return;
        }

    Requests.reserveCar(fullNameController.text, emailController.text, phoneNumberController.text, passportNumberController.text
    , mynationalityselection, _birthdayDateController.text, widget.cdays, widget.totalPrice
    ,widget.carname,widget.pickupdate,widget.dropoffdate,widget.locationfrom , widget.locationto);

    print("register account");
   // Get.back();
    Get.offAll(Home());

         Constants.rSnackbarSuccess("?????????? ","???????????? ?????? ?????????? ?????????? ??????????  ?????????? ?????????????? ???????? ???? ???????? ???????? ???????? ?????????? ??????????");

  }else{
             Constants.rSnackbarError("?????????? ??????","???? ???????? ?????????? ?????????????? ???????? ?????????? ???????? ????????????");

  }

 }

}
  Widget _customPopupItemBuilder(
      BuildContext context, list, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(list,textAlign: TextAlign.right,),
      
      ),
    );
  }
