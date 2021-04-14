import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/images_model.dart';
import 'package:pazar_app/models/social_model.dart';
import 'package:pazar_app/models/toursim_model.dart';
import 'package:pazar_app/pages/comments/tourismplaces_comments.dart';
import 'package:pazar_app/pages/reserve_tourismprogram.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/widgets/rbutton.dart';
import 'package:pazar_app/widgets/rcarousel_slider.dart';
import 'package:pazar_app/widgets/social_item.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class TourismPlacesDetails extends StatefulWidget {
  final id;

  final TourismModel list;

  TourismPlacesDetails({Key key, this.list, this.id = 0}) : super(key: key);

  @override
  _TourismPlacesDetailsState createState() => _TourismPlacesDetailsState();
}

class _TourismPlacesDetailsState extends State<TourismPlacesDetails> {

List<String> imgList;
bool loading = true;
var _id ;

  
  List<TourismModel> mylist = [];

  Future<List<TourismModel>> getItem(id) async {
    var response = await Constants.getUrl("api/tourism_places/get/$id/");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      for (var item in body["data"]) {
        mylist.add(TourismModel.fromJson(item));
      }
      return mylist;
    }
    return null;
  }
  



 getImages(id) async {
List<String> images=[] ;

    var response = await Constants.getUrl("api/tourism_places_images/get/$id/");

    if (response.statusCode == 200) {
try {
   var body = jsonDecode(response.body);
 

    var data = body["data"][0];

  data["Image1"].isNotEmpty?images.add(data["Image1"]):Container();
  data["Image2"].isNotEmpty?images.add(data["Image2"]):Container();
  data["Image3"].isNotEmpty?images.add(data["Image3"]):Container();
  data["Image4"].isNotEmpty?images.add(data["Image4"]):Container();
  data["Image5"].isNotEmpty?images.add(data["Image5"]):Container();
  data["Image6"].isNotEmpty?images.add(data["Image6"]):Container();


    return images;

} catch (e) {

    setState(() {
          
          loading = false;
        });
      return images;

}


       }
 }

  @override
  void initState() {
    super.initState();

    if (widget.id != 0) {
      getItem(widget.id).then((value) {
        setState(() {
          mylist = value;
        });
      });
    }


          widget.id !=0 ? _id = widget.id : _id = widget.list.id;
 
      getImages(_id).then((value) {
        setState(() {
          imgList = value;
          loading =false;
        });
      });
    

 
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(widget.id != 0
              ? mylist?.length > 0
                  ? mylist[0].name
                  : ''
              : widget.list.name),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          )),
      body:  loading? Center(child: CircularProgressIndicator()): Container(
        height: size.height,
      child:  widget.id != 0
            ? mylist?.length > 0
                ? Body(imgList, mylist[0])
                : Center(child: CircularProgressIndicator())
            : Body(imgList, widget.list),
      ),
    );
  }
}

Body(imgList, list) {
  return ListView(
    children: [
      SizedBox(
        height: 20,
      ),
      /*   Align(
                alignment: Alignment.center,
                child: Text(
                  "استينا بارك مول",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                )), */
      SizedBox(
        height: 10,
      ),
     RCarouselSlider(imgList: imgList,list:list,type:"toursim"),
      SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            list.rating.toString(),
            style: TextStyle(color: Colors.grey[700], fontSize: 20),
          ),
          SizedBox(
            width: 5,
          ),
          RatingBar.builder(
            initialRating: list.rating,
            minRating: 1,
            itemSize: 30,
            ignoreGestures: true,
            direction: Axis.horizontal,
            allowHalfRating: true,
            updateOnDrag: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "(${list.num_comments})",
            style: TextStyle(color: Colors.grey[700], fontSize: 20),
          ),
        ],
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          elevation: 2,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                tourismItem(
                  txt: list.desc,
                ),
                if (list.end.toString().isNotEmpty &&
                    !list.end.toString().startsWith("00"))
                  Text(
                    "${list.end} ينتهي بتاريخ",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
           /*      tourismItem(
                  txt: "ساعات العمل يوميا: 10.00 ص - 10.00 م",
                ),
                tourismItem(
                  txt: "العنوان: اسطنبول ساحة ",
                ), */
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextButton(
                    onPressed: () => openUrl(list.url),
                    child: Text(
                      "... اضغط هنا للمزيد",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.blue),
                    ),
                  ),
                ),
                list.cat == 12
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 25),
                          child: RButton(
                              txt: "احجز الآن",
                              btnColor: btnBlue,
                              press: () => Get.to(
                                  ReserveTourismProgram(programstate: list)),
                              width: 0.6),
                        ),
                      )
                    : Container(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: 30),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          elevation: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialItem(
                      img: "share",
                      press: () => Share.share(
                          "${list.name} \n ${list.url} \n  تم المشاركة بواسطة تطبيق بازار تركيا"),
                    ),
                    SocialItem(
                      img: "message",
                      press: () =>
                          Get.to(TourismPlacesComments(postid: list.id)),
                    ),

                      SocialItem(
                    img: "location",
                    press: ()=> {

               openMap(list.distance),
                    //         !Get.isSnackbarOpen? Get.snackbar("Alert", "Coming soon...",snackPosition: SnackPosition.BOTTOM,borderColor:Colors.red,borderWidth: 1,borderRadius: 12,backgroundColor: Colors.white,margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10)):Container(),

                    },
                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );
}

class tourismItem extends StatelessWidget {
  final txt;
  const tourismItem({
    Key key,
    @required this.txt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        txt,
        textAlign: TextAlign.end,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

    Future<void> openMap(url) async {
    String googleUrl = url;
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

void openUrl(url) async {
  print("pressed " + url);

  var myurl = url;

  if (myurl.isNotEmpty) {
    if (await canLaunch(myurl))
      await launch(myurl);
    else
      // can't launch url, there is some error
      throw "Could not launch $myurl";
  } else {
            Constants.rSnackbarError("رسالة ", "لم يتم إضافة رابط");

  }
}
