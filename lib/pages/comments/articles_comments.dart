import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/servicecomments_model.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/rbutton.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticlesComments extends StatefulWidget {
  final int postid;

  const ArticlesComments({Key key, @required this.postid}) : super(key: key);

  @override
  _ArticlesCommentsState createState() => _ArticlesCommentsState();
}

class _ArticlesCommentsState extends State<ArticlesComments> {

TextEditingController commentController = TextEditingController();
  List<ServicesCommentsModel> comList;
 bool loading = true;
  @override
  void initState() { 
    super.initState();

print(widget.postid);
    Requests.getArticlesComments(widget.postid).then((value) {


      setState(() {
        comList = value;
        loading= false;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {



    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Stack(
            children: [
              loading  ?Center(child:CircularProgressIndicator()):comList.length > 0?
              ListView.builder(itemCount: comList.length,  itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(radius: 25,backgroundColor: Colors.grey.withOpacity(0.3), child: Icon(Icons.person)),
                  title: Text(comList[index].name),
                  subtitle: Text(comList[index].comment),
                  trailing: RatingBar.builder(
                    initialRating: comList[index].rating,
                    minRating: 1,itemSize: 20,ignoreGestures: true,
                    direction: Axis.horizontal,
                    allowHalfRating: true,updateOnDrag: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                );
              }):Center(child: Text("???? ???????? ??????????????")),

              Positioned(bottom:5,right: 5,left: 5,child: RButton(txt: "?????????? ??????????", press: () async {

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.containsKey('fullname')?addComment()
                                    :        Constants.rSnackbarError("?????????? ", "???? ???????? ?????????? ??????????  ???????? ?????????? ???????????? ????????????????");


                 
              }, width: 0.8)),
            ],
          ),
        ),
      ),
    );
  }

  addComment() async {

 

   double userRating = 5 ;

    Get.defaultDialog(
    title: "?????????? ??????????",
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              SizedBox(
              height: 10.0,
            ),

               RatingBar.builder(
                    initialRating: 5,
                    minRating: 1,itemSize: 20,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      userRating = rating;
                    },
                  ),

         
                          SizedBox(
              height: 10.0,
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal : 20.0),
              child: RTextBox(
                  controller: commentController, ispass: false, hinttxt: '???????? ????????????'),
            ),
           
            SizedBox(
              height: 30.0,
            ),

         

            RButton(
                txt: "?????????? ??????????????",
              width: 0.5,

                press: () {
                  sendComment(userRating);
                }),

                SizedBox(
              height: 10.0,
            ),

           
          ],
        ),
        radius: 10.0);
  
  }
    void sendComment(rating) {
    if(commentController.text.isEmpty){
              Constants.rSnackbarError("?????????? ??????", "???? ?????????? ?????????? ?????????????? ???????? ?????????? ??????????");

    }else{

     Requests.addComments("api/articles_comments/addnew", rating, commentController.text, widget.postid);

    Get.back();

              Constants.rSnackbarSuccess("?????????? ", "???? ?????????? ?????????????? ??????????, ???????? ???????????? ???????????? ???? ?????? ?????????????? ?????? ?????????? ??????");

    }

  }

}
