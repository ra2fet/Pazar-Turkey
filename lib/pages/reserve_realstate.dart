import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as f;

import 'package:get/get.dart';
import 'package:pazar_app/models/location_model.dart';
import 'package:pazar_app/models/realstate_model.dart';
import 'package:pazar_app/pages/realestate.dart';
import 'package:pazar_app/pages/auth/signupforrealstate.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/rbutton.dart';

class ReserveRealState extends StatefulWidget {
  final RealStateModel realestate;

  const ReserveRealState({Key key, this.realestate}) : super(key: key);
  @override
  _ReserveRealStateState createState() => _ReserveRealStateState();
}

class _ReserveRealStateState extends State<ReserveRealState> {
  bool isAvailable = false;
  var difference;
  var totalPrice;
  double discount = 1;
  double discountValue;

  TextEditingController couponController = TextEditingController();

  TextEditingController pickupDate =
      TextEditingController(text: DateTime.now().toString());

  TextEditingController dropoutDate = TextEditingController(
      text: DateTime.now().add(Duration(days: 3)).toString());
  bool couponUsed = false;
  String couponCode, couponDiscount, endDate;

  Future<String> getRealstateCoupon() async {
    var response = await Constants.getUrl("api/coupon/get/realstate");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print(body["data"]);
      couponCode = body["data"][0]["coupon_code"];
      couponDiscount = body["data"][0]["coupon_discount"];
      endDate = body["data"][0]["end_date"];

      setState(() {});
      return "Success";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    getRealstateCoupon();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: widget.realestate.type == 4
            ? Text("فلل للايجار")
            : Text("شقق للايجار"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        height: size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.03,
              ),

              /*     LocationBtn(
                label: "Pick up point",
              ), */
              Text(" يجب الحجز قبل يومين على الأقل من تاريخ الاستلام",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
              SizedBox(
                height: size.height * 0.02,
              ),
              Text("تاريخ ووقت الاستلام",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              dateField(
                pickupDate,
                size,
                "تاريخ الاستلام",
                "وقت الاستلام",
              ),
              SizedBox(height: size.height * 0.02),
              Text("تاريخ ووقت التسليم",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              dateField(
                dropoutDate,
                size,
                "تاريخ التسليم",
                "وقت التسليم",
              ),
              isAvailable
                  ? Column(
                      children: [
                        SizedBox(height: size.height * 0.03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "يمكنك الحصول على الخصم على السعر في حال كان لديك كود الخصم",
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RTextBox(
                              controller: couponController,
                              ispass: false,
                              hinttxt: "كود الخصم",
                              width: 0.35,
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: btnBlue,
                                shape: StadiumBorder(),
                              ),
                              child: Text('التحقق من الكود'),
                              onPressed: () {
                                var now = DateTime.now();
                                var cdate = DateTime.parse(endDate);
                                print("date is $now");
                                print("cdate is ${cdate}");

                                final differenceWithToday =
                                    cdate.difference(now).inDays;

                                print("difference is $differenceWithToday");
                                print("coupon is $couponCode");

                                if (couponController.text == couponCode &&
                                    differenceWithToday >= 0 &&
                                    !couponUsed) {
                                  print("working");
                                  setState(() {
                                    // discount = 0.25;
                                    couponUsed = true;
                                    var discountv =
                                        double.parse(couponDiscount) / 100;
                                    discount = discountv;
                                    discountValue = totalPrice * discount;
                                    totalPrice = totalPrice - discountValue;
                                  });
                                } else if (couponUsed) {
                                  Constants.rSnackbarError("رسالة خطأ",
                                      "لا يمكن استخدام كوبون أكثر من مرة");
                                } else {
                                  Constants.rSnackbarError(
                                      "رسالة خطأ", "عذراً هذا الكود لا يعمل");
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: size.height * 0.04,
              ),
              !isAvailable
                  ? RButton(
                      txt: "البحث",
                      press: () => search(),
                      width: 0.8,
                      btnColor: btnBlue,
                    )
                  : Container(),
              SizedBox(
                height: size.height * 0.03,
              ),
              isAvailable
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: size.width,
                      child: Card(
                          elevation: 4,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Text(
                                  " سيتم الحجز  بسعر ($totalPrice\$)  لمدة ($difference) أيام  ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 10),
                                RButton(
                                    txt: "اتمام عملية الحجز",
                                    btnColor: btnBlue,
                                    press: () => continueReseve(),
                                    width: size.width * 0.5),
                                SizedBox(
                                  height: 8,
                                ),
                                RButton(
                                    btnColor: btnBlue,
                                    txt: "إلغاء الأمر",
                                    press: () => cancelReseve(),
                                    width: size.width * 0.5),
                              ],
                            ),
                          )))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void search() {
    var now = DateTime.now();

    var date1 = DateTime.parse(pickupDate.text);
    var date2 = DateTime.parse(dropoutDate.text);

    difference = date2.difference(date1).inDays;

    totalPrice = difference * double.parse(widget.realestate.dailyprice);
    final differenceWithToday = date1.difference(now).inDays + 1;
    print(difference);
    print("With Today $differenceWithToday");

    if (pickupDate.text.isEmpty || dropoutDate.text.isEmpty) {

          Constants.rSnackbarError("رسالة خطأ", "يجب تحديد تاريخ الاستلام والتسليم");

      
    } else if (differenceWithToday < 0) {
      
      
                Constants.rSnackbarError("رسالة خطأ", "لا يمكن أن يكون تاريخ الاستلام أصغر من تاريخ اليوم");

      
    } else if (date1.compareTo(date2) > 0) {


          Constants.rSnackbarError("رسالة خطأ", "لا يمكن أن يكون تاريخ الاستلام أكبر من تاريخ التسليم");

     
      print("error bigger than date2");
    } else if (differenceWithToday < 2) {

          Constants.rSnackbarError("رسالة ", "لا يوجد شقق حاليا متاحة للحجز في تاريخ الاستلام المحدد");

      print("error less than 3");
    } else if (difference == 0) {


                Constants.rSnackbarError("رسالة ", "لا يمكن أن يكون تاريخ الاستلام و التسليم نفسه");

    } else {
      setState(() {
        isAvailable = true;
      });
    }
  }

  void continueReseve() {
    var date1 = DateTime.parse(pickupDate.text);
    var date2 = DateTime.parse(dropoutDate.text);

    var inputDate1 = DateFormat('dd/MM/yyyy - HH:mm').format(date1);
    var inputDate2 = DateFormat('dd/MM/yyyy - HH:mm').format(date2);

    Get.to(SignUpRealState(
        realStateItem: widget.realestate,
        rdays: difference,
        pickupdate: inputDate1,
        dropoffdate: inputDate2,
        totalPrice: totalPrice));
  }

  void cancelReseve() {
    setState(() {
      isAvailable = false;
    });
  }

  Widget dateField(_pickupDate, size, hintDate, hintTime) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                border:
                    Border.all(color: Colors.grey.withOpacity(0.5), width: 1)),
            child: Icon(Icons.event),
          ),
          Expanded(
            child: Container(
              height: 50,
              child: DateTimePicker(
                textAlign: TextAlign.center,
                controller: _pickupDate, timeHintText: "Pick up Time",
                dateHintText: hintDate,
                type: DateTimePickerType.dateTimeSeparate,
                calendarTitle: hintDate,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(),
                ),
                dateMask: 'dd/MM/yyyy',
                timeFieldWidth: size.width / 2 - 50,
                //  initialValue: DateTime.now().toString(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                //     dateLabelText: 'Pick up Date',
                //    timeLabelText: "Pick up Time",
                /* selectableDayPredicate: (date) {
    // Disable weekend days to select from the calendar
    if (date.weekday == 6 || date.weekday == 7) {
      return false;
    }

    return true;
  },*/
                onChanged: (val) {
                  setState(() {
                    isAvailable = false;
                  });
                },
                validator: (val) {
                  print(val);

                  return null;
                },
                onSaved: (val) => print(val),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
