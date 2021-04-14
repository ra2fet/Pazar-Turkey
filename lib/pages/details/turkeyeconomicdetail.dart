import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:pazar_app/models/article_model.dart';
import 'package:pazar_app/models/social_model.dart';
import 'package:pazar_app/pages/comments/articles_comments.dart';
import 'package:pazar_app/pages/comments/service_comments.dart';
import 'package:pazar_app/pages/comments/turkeyeconomic_comments.dart';
import 'package:pazar_app/pages/turkeyeconomic.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/widgets/rchip.dart';

import 'package:pazar_app/widgets/rcarousel_slider.dart';
import 'package:pazar_app/widgets/social_item.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class TurkeyEconomicDetail extends StatefulWidget {
  final postList;

  final id;

  const TurkeyEconomicDetail({Key key, this.postList, this.id = 0})
      : super(key: key);

  @override
  _TurkeyEconomicDetailState createState() => _TurkeyEconomicDetailState();
}

class _TurkeyEconomicDetailState extends State<TurkeyEconomicDetail> {
  List<ArticleModel> mylist = [];

  List<SocialModel> socialList = [];

  Future<List<ArticleModel>> getTurkeyEco(id) async {
    var response = await Constants.getUrl("api/turkey_economic/get/$id/");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body["data"]);

      for (var item in body["data"]) {
        mylist.add(ArticleModel.fromJson(item));
      }
      return mylist;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.id != 0) {
      getTurkeyEco(widget.id).then((value) {
        setState(() {
          mylist = value;
        });
      });
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
        title: Marquee(textDirection: TextDirection.rtl,directionMarguee: DirectionMarguee.oneDirection,
          child: Text(widget.id != 0
              ? mylist?.length > 0
                  ? mylist[0].title
                  : ''
              : widget.postList.title),
        ),
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
                  postList: mylist[0],
                  socialList: socialList,
                )
              : Center(child: CircularProgressIndicator())
          : Body(
              postList: widget.postList,
              socialList: socialList,
            ),
    );
  }
}

class Body extends StatelessWidget {
  final socialList;
  final postList;

  const Body({Key key, this.postList, this.socialList}) : super(key: key);
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
                    child: Image.network(
                      "${Constants.resUrl}${postList.image}",
                      width: size.width * 0.4,
                      fit: BoxFit.fill,
                    )),
                AddToFavorite(list: postList),
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
                              padding: const EdgeInsets.all(25.0),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Html(
                                  customTextAlign: (_) => TextAlign.right,
                                  data: postList.desc,
                                ),
                              ),
                            ),
                            /*    Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Text(
                                postList.desc,
                                textAlign: TextAlign.end,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ), */

                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: TextButton(
                                onPressed: () => openUrl(postList.url),
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
                  press: () => Get.to(TurkeyEconomicComments(
                    postid: postList.id,
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
                      "${postList.title} \n ${postList.url} \n  تم المشاركة بواسطة تطبيق بازار تركيا"),
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

  const AddToFavorite({Key key, this.pressed = false, this.list})
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

    var response = await Constants.getUrl(
        "api/users_favorite/get/$id/turkeyeconomic/$user/");

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
          if (_pressed == true)
            Requests.addToFavorite(widget.list.id, widget.list.title,
                widget.list.desc, "turkeyeconomic");
          else
            Requests.removeFromFavorite(widget.list.id, "turkeyeconomic");
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
