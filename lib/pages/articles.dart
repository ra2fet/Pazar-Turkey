import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/article_model.dart';
import 'package:pazar_app/pages/details/articlesdetail.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/imagenetwork.dart';
import 'package:pazar_app/widgets/rbutton.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Articles extends StatefulWidget {
  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  List<ArticleModel> articleList = [];
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    TextEditingController urlController = TextEditingController();

    bool loading = false;



  Future<List<ArticleModel>> getArticles() async {


    var response = await Constants.getUrl("api/articles/get_all");
    
     if (response.statusCode == 200) {

       var body = jsonDecode(response.body);
      // print(body["data"]);

  //  String data = await DefaultAssetBundle.of(context)
    //    .loadString("assets/json/articles.json");
  //final body = jsonDecode(data);


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
        loading = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("المقالات"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          loading ?Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
           child: ListView.builder(   
itemCount: articleList.length,itemBuilder: (context, i) {

                  return ArticleItem(
                    img: articleList[i].image,
                    title:  articleList[i].title,
                    desc:articleList[i].desc,
                    press: () => btnSelect(articleList[i]),
                  );
                }),
          ):Center(child: CircularProgressIndicator(),),

           // Positioned(bottom:5,right: 5,left: 5,child: RButton(txt: "إضافة مقالة", press: () async {
              
        //               final SharedPreferences prefs = await SharedPreferences.getInstance();

        // prefs.containsKey('fullname')?addArticle():Constants.rSnackbarError("رسالة خطأ", "لا يمكن إضافة مقالة  بدون تسجيل الدخول بالتطبيق");

        //     } , width: 0.8)),

        ],
      ),
    );
  }

  void btnSelect( postList) {
    Get.to(ArticlesDetail(
      postList: postList,

    ));
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
        content: SingleChildScrollView(          scrollDirection: Axis.vertical,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          

              Padding(
                padding:  EdgeInsets.symmetric(horizontal : 20.0),
                child: RTextBox(
                    controller: titleController, ispass: false, hinttxt: 'أدخل عنوان المقالة'),
              ),
             
              SizedBox(
                height: 10.0,
              ),

             Flexible(
               child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal : 20.0),
                  child: RTextBox(
                      controller: descController, ispass: false, hinttxt: 'أدخل نص المقالة'),
                ),
             ),
              SizedBox(
                height: 10.0,
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

          if(titleController.text.isEmpty || descController.text.isEmpty ){

            Constants.rSnackbarError("خطأ","لا يمكنك نشر المقالة بدون كتابة عنوان و محتوى المقالة");

    }else{
    Get.back();
addnewArticle();

            Constants.rSnackbarError("رسالة","تم إرسال المقالة بنجاح, سيتم مراجعة مقالتك من قبل الإدارة قبل عرضها هنا");


    }

  }
  addnewArticle() async {

    var response = await Constants.postUrlWithPara("api/articles/addnew",{
      "title": titleController.text ,
      "description": descController.text ,
      });

       var body = jsonDecode(response.body);

    if (body['status'] == 200) {

       var body = jsonDecode(response.body);


       print("success");

          return "success";
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
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:5.0),
                              child: Text(
                                title??"",textAlign: TextAlign.right,
                                style: TextStyle(color: btnBlue, fontSize: 17),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: Text(
                                      desc,
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style:
                                          TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
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

                              child:  ImageNetwork(url:"${Constants.resUrl}$img",height: 140),
                          
                          
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
