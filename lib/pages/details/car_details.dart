import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/car_model.dart';
import 'package:pazar_app/models/social_model.dart';
import 'package:pazar_app/pages/car.dart';
import 'package:pazar_app/pages/auth/signupforcar.dart';
import 'package:pazar_app/pages/carconfirm.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/imagenetwork.dart';
import 'package:pazar_app/widgets/rbutton.dart';
import 'package:pazar_app/widgets/social_item.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetails extends StatefulWidget {

 // final String name , type , engine ;
  final int days;
  final String pickupdate,dropoffdate,locationfrom , locationto;
  const CarDetails({Key key,  @required this.days, this.pickupdate, this.dropoffdate, this.locationfrom, this.locationto}) : super(key: key);
//@required this.name, @required this.type, @required this.engine,
  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  List<CarModel> carList = [];
      List<SocialModel> socialList = [];

var totalPrice;
  @override
  void initState() {
    super.initState();

//print("${widget.name}  ${widget.type}  ${widget.engine}"); widget.name,widget.type,widget.engine
    Requests.getCars(context,).then((value) {
      setState(() {
        carList = value;
      });
    });

   Requests.getSocialItems().then((value) {
      setState(() {
            socialList = value;
      });


    });
    
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("اختر السيارة"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        
      ),
      body: Container(
        height: size.height,
        child: carList.length>0 ? ListView.builder(
            itemCount: carList.length,
            itemBuilder: (context, index) {
              totalPrice = widget.days* carList[index].dailyprice  ;
              

              return CarItem(
                carname: carList[index].carname,
                cartype: carList[index].cartype,
                enginetype: carList[index].enginetype,
                imageurl: carList[index].imageUrl,
                driverage: 'عمر السائق: ${carList[index].driverage}',
                licenseage: 'عمر الرخصة: ${carList[index].licenseage}',
                luggagenum: 'حقائب ${carList[index].luggagenum}',
                persons: 'أشخاص ${carList[index].persons}',
                dailyprice: 'السعر اليومي ${carList[index].dailyprice}\$ /  ${widget.days} يوم',
                totalprice: "$totalPrice",
                carModel:carList[index] ,
                days:widget.days ,socialList: socialList,
                pickupdate:widget.pickupdate,dropoffdate:widget.dropoffdate,locationfrom:widget.locationfrom 
                , locationto:widget.locationto

              );
            }):Center(child: CircularProgressIndicator()
            //}):Center(child: Text("لا توجد سيارات حسب التفضيلات المختارة",style: TextStyle(fontSize: 18,),)
      ),),
    );
  }

 
}

class CarItem extends StatelessWidget {
  const CarItem({
    Key key,
    @required this.imageurl,
    @required this.carname,
    @required this.cartype,
    @required this.enginetype,
    @required this.dailyprice,
    @required this.licenseage,
    @required this.driverage,
    @required this.persons,
    @required this.luggagenum,
    @required this.totalprice,
    this.socialList,

    

 this.days,
this.carModel, this.pickupdate, this.dropoffdate, this.locationfrom, this.locationto

  }) : super(key: key);
final String pickupdate,dropoffdate,locationfrom , locationto;
  final String imageurl;
  final String carname;
  final String cartype;
  final String enginetype;
  final String licenseage;
  final String driverage;
  final String persons;
  final String luggagenum;

  final String dailyprice;
  final String totalprice;
  final int days;
  final CarModel carModel;
  final socialList;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.orange, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  carname,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                                      height: 70,

                  child:  ImageNetwork(url:imageurl,height:70,width:100),

                ),
              ),
            ],
          ),
                    Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [

                              SocialItem(
                    img: "phone",
                  press: () async => await launch("tel:${socialList[0].phone}"),
                  ),
                  SocialItem(
                    img: "message",
                    press: ()=>  _sendMail()  ,

                  ),

                  SocialItem(
                    img: "whatsapp",
                  press: () async => {
                    await launch("https://wa.me/${socialList[0].whatsapp}?text=Hello"),
                  }),

          ],),
SizedBox(height: 5,),
          Divider(),
          
          Row(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    cartype,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Image.asset(
                    "assets/car_icons/gas.png",
                    width: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      enginetype,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      "assets/car_icons/gearbox.png",
                      width: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          
          Row(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    licenseage,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Image.asset(
                    "assets/car_icons/drive-licence.png",
                    width: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      driverage,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      "assets/car_icons/birtday.png",
                      width: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    persons,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Image.asset(
                    "assets/car_icons/users-count.png",
                    width: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      luggagenum,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Image.asset(
                      "assets/car_icons/luggage.png",
                      width: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),

          Divider(),
          Text('$dailyprice', style: TextStyle(fontWeight: FontWeight.w400)),
          SizedBox(
            height: 5,
          ),
          Text(' (\$$totalprice) السعر الكلي'
           ,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          SizedBox(
            height: 5,
          ),
          RButton(
            txt: "احجز الآن",
            press: () => Get.to(CarConfirm(days: days,name: carname,totalprice: totalprice,pickupdate:pickupdate,dropoffdate:dropoffdate,locationfrom:locationfrom , locationto:locationto)),
            width: 0.8,
            btnColor: Colors.blue[900],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

 void _sendMail() async{

    final Uri params = Uri(
      scheme: 'mailto',
      path: 'INFO@PAZAR-TR.COM',
    );
    String  url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print( 'Could not launch $url');
    }



  }
}
