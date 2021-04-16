import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/realstate_model.dart';
import 'package:pazar_app/models/social_model.dart';
import 'package:pazar_app/pages/comments/realstate_comments.dart';
import 'package:pazar_app/pages/reserve_realstate.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/widgets/rbutton.dart';
import 'package:pazar_app/widgets/rchip.dart';

import 'package:pazar_app/widgets/rcarousel_slider.dart';
import 'package:pazar_app/widgets/social_item.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class RealEstateDetails extends StatefulWidget {
  final RealStateModel realstateList;
  final id;
  const RealEstateDetails({Key key, this.realstateList, this.id = 0})
      : super(key: key);

  @override
  _RealEstateDetailsState createState() => _RealEstateDetailsState();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

class _RealEstateDetailsState extends State<RealEstateDetails> {
  List<SocialModel> socialList = [];

  List<RealStateModel> mylist = [];

  List<String> imgList;
  bool loading = true;
  bool loadingFeatures = true;
  bool loadingSocial = true;
  var _id, _type;
  String fage,
      frooms,
      fwcs,
      farea,
      fdailyprice,
      fmonthlyprice,
      fnumstairs,
      fprice,
      flandtype,
      flandbuilding,
      flandarea,
      fbook,
      fcode,
      fcity,
      fregion;

  Future<List<RealStateModel>> getRealState(id) async {
    var response = await Constants.getUrl("api/realstate/getrealstate/$id/");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body["data"]);

      for (var item in body["data"]) {
        mylist.add(RealStateModel.fromJson(item));
      }
      return mylist;
    }
    return null;
  }

  Future<String> getFeatures(type) async {
    var response = await Constants.getUrl("api/realstate_features/get/$type");

    try {
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        //  print(body["data"]);

        fage = body["data"][0]["r_age"];
        frooms = body["data"][0]["r_rooms"];
        fwcs = body["data"][0]["r_num_of_wcs"];
        farea = body["data"][0]["r_area"];
        fdailyprice = body["data"][0]["daily_price"];
        fmonthlyprice = body["data"][0]["monthly_price"];
        fnumstairs = body["data"][0]["numstairs"];
        fprice = body["data"][0]["r_price"];
        flandtype = body["data"][0]["landtype"];
        flandbuilding = body["data"][0]["landbuilding"];
        flandarea = body["data"][0]["landarea"];
        fbook = body["data"][0]["book"];
        fcode = body["data"][0]["code"];
        fcity = body["data"][0]["city"];
        fregion = body["data"][0]["region"];

        setState(() {});
        return "Success";
      }
    } catch (e) {}

    return null;
  }

  getImages(id) async {
    List<String> images = [];

    var response = await Constants.getUrl("api/realstate_images/get/$id/");

    if (response.statusCode == 200) {
      try {
        var body = jsonDecode(response.body);

        var data = body["data"][0];

        data["Image1"].isNotEmpty ? images.add(data["Image1"]) : Container();
        data["Image2"].isNotEmpty ? images.add(data["Image2"]) : Container();
        data["Image3"].isNotEmpty ? images.add(data["Image3"]) : Container();
        data["Image4"].isNotEmpty ? images.add(data["Image4"]) : Container();
        data["Image5"].isNotEmpty ? images.add(data["Image5"]) : Container();
        data["Image6"].isNotEmpty ? images.add(data["Image6"]) : Container();

        return images;
      } catch (e) {
        setState(() {
          // loading = false;
        });
        return images;
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.id != 0) {
      getRealState(widget.id).then((value) {
        setState(() {
          mylist = value;
          //    loading = false;
          _type = mylist[0].type;
          getFeatures(_type)
              .then((value) => setState(() => loadingFeatures = false));
        });
      });
    }

    widget.id == 0
        ? getFeatures(widget.realstateList.type)
            .then((value) => setState(() => loadingFeatures = false))
        : Container();

    Requests.getSocialItems().then((value) {
      setState(() {
        socialList = value;
        loadingSocial = false;
      });
    });

    widget.id != 0 ? _id = widget.id : _id = widget.realstateList.id;
    getImages(_id).then((value) {
      setState(() {
        imgList = value;
        loading = false;
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
                ? mylist[0].subtitle
                : ''
            : widget.realstateList.subtitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: size.height,
              child: SingleChildScrollView(
                child: widget.id != 0
                    ? mylist?.length > 0
                        ? body(imgList, mylist[0], socialList[0])
                        : Center(child: CircularProgressIndicator())
                    : body(imgList, widget.realstateList, socialList[0]),
              ),
            ),
    );
  }

  body(imgList, list, sociallist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        RCarouselSlider(imgList: imgList, list: list, type: "realstate"),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Card(
                    elevation: 3,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              list.desc??"",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextButton(
                              onPressed: () => openUrl(list.url),
                              child: Text(
                                "... اضغط هنا للمزيد",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blue),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 40,
        ),
        loadingSocial
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //phone
                  SocialItem(
                    img: "phone",
                    press: () async => await launch("tel: ${sociallist.phone}"),
                  ),

                  SocialItem(
                    img: "message",
                    press: () => Get.to(RealStateComments(postid: list.id)),
                  ),

                  SocialItem(
                      img: "whatsapp",
                      press: () async => {
                            await launch(
                                "https://wa.me/${sociallist.whatsapp}?text=Hello"),
                          }),

                  SocialItem(
                    img: "share",
                    press: () => Share.share(
                        "${list.subtitle}\n كود العقار:  ${list.code} \n $list.url} \n تم المشاركة بواسطة تطبيق بازار تركيا"),
                  ),

                  SocialItem(
                    img: "location",
                    press: () => {
                      RealEstateDetails.openMap(
                          double.parse(sociallist.longitude),
                          double.parse(sociallist.latitude)),
                      //         !Get.isSnackbarOpen? Get.snackbar("Alert", "Coming soon...",snackPosition: SnackPosition.BOTTOM,borderColor:Colors.red,borderWidth: 1,borderRadius: 12,backgroundColor: Colors.white,margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10)):Container(),
                    },
                  ),
                ],
              ),
        SizedBox(
          height: 30,
        ),
        list.isOccupy == 1
            ? DetailsItem(title: 'الحالة', txt: list.type == 2 ||  list.type == 4?"تم التأجير": "تم البيع")
            : Container(),
        loadingFeatures == false
            ? int.parse(fprice) == 1
                ? DetailsItem(title: 'السعر يبدء من', txt: "\$${list.price}")
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(fdailyprice) == 1
                ? DetailsItem(
                    title: 'الايجار اليومي', txt: "\$${list.dailyprice}")
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(fmonthlyprice) == 1
                ? DetailsItem(
                    title: 'السعر شهرياً', txt: "\$${list.monthlyprice}")
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(fcode) == 1
                ? DetailsItem(title: 'كود المشروع', txt: list.code)
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(fnumstairs) == 1
                ? DetailsItem(title: 'عدد الطوابق', txt: list.numstairs)
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(flandtype) == 1
                ? DetailsItem(title: 'النوع', txt: list.landtype)
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(flandarea) == 1
                ? DetailsItem(title: 'مساحة الأرض', txt: "${list.landarea} m")
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(flandbuilding) == 1
                ? DetailsItem(
                    title: 'نسبة الأعمار المرخصة',
                    txt: "${list.landbuilding} m")
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(fage) == 1
                ? DetailsItem(title: 'عمر العقار', txt: list.age)
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(frooms) == 1
                ? DetailsItem(title: 'عدد الغرف', txt: list.rooms)
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(fwcs) == 1
                ? DetailsItem(title: 'عدد دورات المياه', txt: list.wcs)
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(farea) == 1
                ? DetailsItem(title: 'مساحة العقار', txt: "${list.area} m")
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(fcity) == 1
                ? DetailsItem(title: 'المدينة', txt: list.city)
                : Container()
            : Container(),
        loadingFeatures == false
            ? int.parse(fregion) == 1
                ? DetailsItem(title: 'الحي', txt: list.region)
                : Container()
            : Container(),
        SizedBox(
          height: 10,
        ),
        loadingFeatures == false
            ? fbook == "1" && list.isOccupy !=1
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: RButton(
                        txt: "احجز الآن",
                        btnColor: btnBlue,
                        press: () => Get.to(ReserveRealState(realestate: list)),
                        width: 0.6),
                  )
                : Container()
            : Container(),
      ],
    );
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
}

class DetailsItem extends StatelessWidget {
  final String title, txt;

  DetailsItem({
    Key key,
    @required this.title,
    @required this.txt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            txt,
            textAlign: TextAlign.start,
          ),
          Text(
            title,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}
