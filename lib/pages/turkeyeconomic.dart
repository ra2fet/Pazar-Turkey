import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as f;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/article_model.dart';
import 'package:pazar_app/models/services_model.dart';
import 'package:pazar_app/pages/details/turkeyeconomicdetail.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/home_popup_menu.dart';
import 'package:pazar_app/widgets/imagenetwork.dart';
import 'package:pazar_app/widgets/itemhome1.dart';
import 'package:pazar_app/widgets/itemhome2.dart';
import 'package:pazar_app/widgets/itemhome3.dart';
import 'package:pazar_app/widgets/itemhome4.dart';
import 'package:pazar_app/widgets/rbutton.dart';
import 'package:pazar_app/widgets/rchip.dart';
import 'package:pazar_app/widgets/realestate_popup_menu.dart';
import 'package:pazar_app/widgets/searchbox.dart';
import 'package:http/http.dart' as http;

class TurkeyEconomic extends StatefulWidget {
  @override
  _TurkeyEconomicState createState() => _TurkeyEconomicState();
}

class _TurkeyEconomicState extends State<TurkeyEconomic> {
  List<ArticleModel> articleList = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  bool loading = true;

  Future<List<ArticleModel>> getArticles() async {
    var response = await Constants.getUrl("api/turkey_economic/get_all");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      for (var item in body["data"]) {
        articleList.add(ArticleModel.fromJson(item));
      }
      return articleList;
    }
    return null;
  }

  @override
  void initState() {
    getArticles().then((value) {
      setState(() {
        articleList = value;
        loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("أخبار سراي بوست"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                    itemCount: articleList.length,
                    itemBuilder: (context, i) {
                      return ArticleItem(
                        img: articleList[i].image,
                        title: articleList[i].title,
                        desc: articleList[i].desc,
                        press: () => btnSelect(articleList[i]),
                      );
                    }),
              ));
  }

  void btnSelect(list) {
    Get.to(TurkeyEconomicDetail(postList: list));
  }

  filterBtn(int filterselected) {
    if (filterselected == 1) {
      print("filterselected 1");
    } else if (filterselected == 2) {
      print("filterselected 2");
    } else if (filterselected == 3) {
      print("filterselected 3");
    } else if (filterselected == 4) {
      print("filterselected 4");
    } else if (filterselected == 5) {
      print("filterselected 5");
    } else if (filterselected == 6) {
      print("filterselected 6");
    } else if (filterselected == 7) {
      print("filterselected 7");
    }
  }

  addArticle() {
    Get.defaultDialog(
        title: "إضافة مقالة",
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: RTextBox(
                    controller: titleController,
                    ispass: false,
                    hinttxt: 'أدخل عنوان المقالة'),
              ),
              SizedBox(
                height: 10.0,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: RTextBox(
                      controller: descController,
                      ispass: false,
                      hinttxt: 'أدخل نص المقالة'),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Flexible(
                child: Container(
                  child: RButton(
                      txt: "نشر المقالة",
                      width: 0.5,
                      press: () {
                        publishArticle();
                      }),
                ),
              ),
            ],
          ),
        ),
        radius: 10.0);
  }

  void publishArticle() {
    if (titleController.text.isEmpty || descController.text.isEmpty) {
      Constants.rSnackbarError(
          "رسالة خطأ", "لا يمكنك نشر المقالة بدون كتابة عنوان و محتوى المقالة");
    } else {
      Get.back();

      Constants.rSnackbarError("رسالة",
          "تم إرسال المقالة بنجاح, سيتم مراجعة مقالتك من قبل الإدارة قبل عرضها هنا");
    }
  }
}

class ArticleItem extends StatelessWidget {
  const ArticleItem(
      {Key key,
      @required this.press,
      @required this.title,
      @required this.desc,
      this.img})
      : super(key: key);

  final String title, desc, img;
  final Function press;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: press,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                title ?? "",
                                textAlign: TextAlign.end,
                                style: TextStyle(color: btnBlue, fontSize: 17),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            /* Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Directionality(
                                      textDirection: f.TextDirection.rtl,
                                      child: Html(showImages: false,
                                        data: desc.substring(0, 60) + '..',useRichText: false,
                                        customTextAlign: (_) => TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ), */
                            SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: TextButton(
                                  onPressed: press,
                                  child: Text(
                                    "قراءة المزيد",
                                    style: TextStyle(color: btnYellow),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: ImageNetwork(
                              url: "${Constants.resUrl}$img", height: 140),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
      ),
    );
  }
}
