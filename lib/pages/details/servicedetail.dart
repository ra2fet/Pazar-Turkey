import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/services_model.dart';
import 'package:pazar_app/models/social_model.dart';
import 'package:pazar_app/pages/comments/service_comments.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/widgets/imagenetwork.dart';
import 'package:pazar_app/widgets/rchip.dart';

import 'package:pazar_app/widgets/rcarousel_slider.dart';
import 'package:pazar_app/widgets/social_item.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceDetail extends StatefulWidget {
  final id;
  final list;
  final ismenu;

  const ServiceDetail({Key key, this.id = 0, this.list, this.ismenu = false})
      : super(key: key);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  List<SocialModel> socialList = [];

  var mylist = [];

  Future<List<ServicesDetailsModel>> getSerT(id) async {
    var response =
        await Constants.getUrl("api/service_types/getservicetype/$id/");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      for (var item in body["data"]) {
        mylist.add(ServicesDetailsModel.fromJson(item));
      }
      return mylist;
    }
    return null;
  }

  Future<List<ServicesModel>> getSer(id) async {
    var response = await Constants.getUrl("api/service/get/$id/");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      for (var item in body["data"]) {
        mylist.add(ServicesModel.fromJson(item));
      }
      return mylist;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.id != 0) {
      widget.ismenu
          ? getSerT(widget.id).then((value) => setState(() => mylist = value))
          : getSer(widget.id).then((value) => setState(() => mylist = value));
    }

    Requests.getSocialItems().then((value) {
      setState(() {
        socialList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

/*     final List<String> imgList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    ]; */

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.id != 0
            ? mylist?.length > 0
                ? mylist[0].title
                : ''
            : widget.list.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: widget.id != 0
          ? mylist?.length > 0
              ? Body(
                  list: mylist[0],
                  socialList: socialList,
                  ismenu: widget.ismenu,
                )
              : Center(child: CircularProgressIndicator())
          : Body(
              list: widget.list,
              socialList: socialList,
              ismenu: widget.ismenu,
            ),
    );
  }
}

class Body extends StatelessWidget {
  final socialList;
  final list;
  final ismenu;
  const Body({Key key, this.list, this.socialList, this.ismenu})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool _pressed = false;

    return Container(
      width: double.infinity,
      height: size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            Stack(
              children: [
                Container(
                    height: 250,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child:  ImageNetwork(url:"${Constants.resUrl}${list.image}",),),

                AddToFavorite(list: list, ismenu: ismenu),
              ],
            ),
            SizedBox(
              height: size.height * 0.03,
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
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                list.desc,
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
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //phone
                SocialItem(
                  img: "phone",
                  press: () async => await launch("tel:${socialList[0].phone}"),
                ),

                SocialItem(
                  img: "message",
                  press: () => Get.to(ServicesComments(
                    postid: list.id,
                    ismenu: ismenu,
                  )),
                ),

                SocialItem(
                  img: "whatsapp",
                  press: () async => {
                    await launch(
                        "https://wa.me/${socialList[0].whatsapp}?text=Hello"),
                  },
                ),

                SocialItem(
                  img: "share",
                  press: () => Share.share(
                      "${list.title} \n ${list.url} \n  تم المشاركة بواسطة تطبيق بازار تركيا"),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
          ],
        ),
      ),
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
            textAlign: TextAlign.end,
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

class AddToFavorite extends StatefulWidget {
  final bool pressed;
  final list;
  final ismenu;

  const AddToFavorite({Key key, this.pressed = false, this.list, this.ismenu})
      : super(key: key);

  @override
  _AddToFavoriteState createState() => _AddToFavoriteState();
}

class _AddToFavoriteState extends State<AddToFavorite> {
  bool _pressed = false;

  Future<String> checkFav(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt("user_id");
    print("connect 1");

    var response;
    if (widget.ismenu)
      response = await Constants.getUrl(
          "api/users_favorite/get/$id/servicetype/$user/");
    else
      response =
          await Constants.getUrl("api/users_favorite/get/$id/service/$user/");

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print(body["data"]);
      _pressed = body["data"][0]["exist"];

      setState(() {});
      return "Success";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    checkFav(widget.list.id);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Positioned(
      top: 13,
      right: size.width * 0.03,
      child: RawMaterialButton(
        onPressed: () {
          setState(() => _pressed = !_pressed);
          if (_pressed == true) if (widget.ismenu)
            Requests.addToFavorite(widget.list.id, widget.list.title,
                widget.list.desc, "servicetype");
          else
            Requests.addToFavorite(
                widget.list.id, widget.list.title, widget.list.desc, "service");
          else if (widget.ismenu)
            Requests.removeFromFavorite(widget.list.id, "servicetype");
          else
            Requests.removeFromFavorite(widget.list.id, "service");
        },
        elevation: 2.0,
        fillColor: Colors.white,
        child: _pressed
            ? Icon(
                Icons.star,
                size: 23.0,
                color: btnYellow,
              )
            : Icon(
                Icons.star,
                size: 23.0,
                color: Colors.grey,
              ),
        padding: EdgeInsets.all(5.0),
        shape: CircleBorder(),
      ),
    );
  }
}
