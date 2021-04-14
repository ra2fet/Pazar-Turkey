import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/pray_model.dart';
import 'package:pazar_app/pages/auth/signupforcar.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/rbutton.dart';

class CarConfirm extends StatefulWidget {
  CarConfirm({Key key, this.totalprice, this.days, this.name, this.pickupdate, this.dropoffdate, this.locationfrom, this.locationto}) : super(key: key);
      final totalprice,days,name;
      
        final String pickupdate,dropoffdate,locationfrom , locationto;

  @override
  _CarConfirmState createState() => _CarConfirmState();
}

class _CarConfirmState extends State<CarConfirm> {
    double discount = 1;
  double discountValue;
  TextEditingController couponController = TextEditingController();
  var totalPrice;
  bool couponUsed =false;
    String  couponCode ,couponDiscount,endDate ;

 Future<String> getCarCoupon() async {

   var response = await Constants.getUrl("api/coupon/get/car");

       if (response.statusCode == 200) {

    var body = json.decode(response.body);
     print(body["data"]);
      couponCode = body["data"][0]["coupon_code"];
      couponDiscount = body["data"][0]["coupon_discount"];
      endDate = body["data"][0]["end_date"];


setState(() {
  
});
    return "Success";

       }
       return null;

  }



@override
void initState() { 
  super.initState();

  getCarCoupon();

  totalPrice = double.parse(widget.totalprice) * discount ;
}
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text("تأكيد الحجز"),),
      body: Container(
         child: SingleChildScrollView(
           child: Column(
             children: [
               SizedBox(height: 40,),
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

        final differenceWithToday = cdate.difference(now).inDays;

        print("difference is $differenceWithToday");
        print("coupon is $couponCode");

                                  if (couponController.text == couponCode && differenceWithToday >= 0 && !couponUsed) {
                                       print("working");
                                       setState(() {
                                        // discount = 0.25;
                                        couponUsed = true;
                                    var discountv =  double.parse(couponDiscount)  / 100;
                                         discount = discountv;
                                        discountValue =totalPrice  * discount;
                                         totalPrice = totalPrice - discountValue;
                                       });
                                     }else if(couponUsed){

                                        Constants.rSnackbarError("رسالة خطأ", "لا يمكن استخدام كوبون أكثر من مرة");

                                    
                                     }else {

                                        Constants.rSnackbarError("رسالة خطأ", "عذراً هذا الكود لا يعمل");

                                      
                                     }
                                   },
                                 ),
                               ],
                             ),
SizedBox(height: 20,),
Divider(),
SizedBox(height: 20,),

                               Container(width: size.width,padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(" سيتم حجز (${widget.name}) بسعر (${totalPrice}\$)  لمدة (${widget.days}) أيام من (${widget.locationfrom}) إلى (${widget.locationto})\n\n  بتاريخ الاستلام (${widget.pickupdate}) و تاريخ التسليم (${widget.dropoffdate}) ",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17),)),
                                        SizedBox(height: 15,),

                            RButton(
                                        txt: "اتمام عملية الحجز",btnColor: btnBlue,
                                        press: () => Get.to(SignUpCar(cdays: widget.days,totalPrice:widget.totalprice ,carname:widget.name ,pickupdate:widget.pickupdate,dropoffdate:widget.dropoffdate,locationfrom:widget.locationfrom , locationto:widget.locationto)),
                                        width:  0.5),
                                        SizedBox(height: 15,),

                                                  RButton(btnColor: btnBlue,
                                        txt: "إلغاء الأمر",
                                        press: () => Get.back(),
                                        width:  0.5),

             ],
           ),
         ),
      ),
    );
  }
}