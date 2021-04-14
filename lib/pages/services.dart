import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/services_model.dart';
import 'package:pazar_app/pages/details/service_select_list.dart';
import 'package:pazar_app/pages/details/servicedetail.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/widgets/rchip.dart';
import 'package:pazar_app/utils/constants.dart';

class Services extends StatefulWidget {
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List<ServicesModel> serviceList = [];

  Future<List<ServicesModel>> getAllServices() async {


    var response = await Constants.getUrl("api/service/get_all");
    
     if (response.statusCode == 200) {

       var body = jsonDecode(response.body);
    for (var item in body["data"]) {
      serviceList.add(ServicesModel.fromJson(item));
    }

    return serviceList;

     }return null;
  }

  @override
  void initState() {
    getAllServices().then((value) {
      setState(() {
        serviceList = value;
      });
    });

    super.initState();
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
        title: Text("الخدمات"),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(height: 50, child: chips()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                  itemCount: serviceList.length,
                  itemBuilder: (context, index) {
                    return ServiceItems(
                        color: serviceList[index].getmyColor,
                        title: serviceList[index].title,
                        subtitle: serviceList[index].subtitle,
                        press: () {
                          if (serviceList[index].isMenu == 1) {
                            btnSelectList(
                                serviceList[index].title,
                                serviceList[index].id,
                                serviceList[index].getmyColor);
                          } else {
                            btnSelect(
                                serviceList[index],
                               );
                          }
                        });
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget chips() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: serviceList.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: RChip(
                txt: serviceList[index].title,
                press: () {
                  if (serviceList[index].isMenu == 1) {
                    btnSelectList(serviceList[index].title,
                        serviceList[index].id, serviceList[index].getmyColor);
                  } else {
                    btnSelect(serviceList[index]);
                  }
                },
                width: 0.4,
                btnColor: serviceList[index].getmyColor,
              ),
            );
          }),
    );
  }
}

void btnSelect(list) {
  Get.to(ServiceDetail(
    list: list,ismenu: false,
  ));
}

void btnSelectList(String title, int sid, color) {
  Get.to(ServiceSelectList(
    title: title,
    sid: sid,
    color: color,
  ));
}

class ServiceItems extends StatelessWidget {
  final String title, subtitle;
  final color;
  final Function press;
  const ServiceItems({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.press,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 10),
      Flexible(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(25)),
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500)),
        ),
      ),
      Flexible(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 35, right: 35, top: 0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                          child: Text(
                        subtitle,
                        textAlign: TextAlign.end,
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
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
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
