import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/notification_model.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<NotificationModel> noti = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    Requests.getNotification().then((value) {
      setState(() {
        noti = value;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text("الإشعارات"),
      ),
      body: loading?Center(child: CircularProgressIndicator(),) :Container(
        height: size.height,
        width: double.infinity,
        child: 
          noti.length==0? Center(child: Text("لا توجد إشعارات جديدة"),): ListView.builder(
            itemCount: noti.length,
            itemBuilder: (context,index){
          
          return notifications("${noti[index].title} ${noti[index].body}");

            }),
      
        
        
      ),
    );
  }
}

Widget notifications(message) {
  return Column(mainAxisSize: MainAxisSize.min, children: [

    SizedBox(height: 25,),
    Container(
      child: Text(message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
    ),
     Container(
        height: 8,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 40.0, right: 40.0),
        child: Divider(
          color: btnBlue,
          thickness: 1.5,
        )),
    SizedBox(
      height: 35,
    ),
  ]);
}

filterBtn(int selected) {
  if (selected == 1) {
    print("filterselected 1");
  } else if (selected == 2) {
    print("filterselected 2");
  }
}
