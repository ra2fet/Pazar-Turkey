import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:multi_sort/multi_sort.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pazar_app/logic/realstate_controller.dart';
import 'package:pazar_app/models/realstate_model.dart';
import 'package:pazar_app/pages/details/realestate_details.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
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

class RealEstate extends StatefulWidget {
  @override
  _RealEstateState createState() => _RealEstateState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _RealEstateState extends State<RealEstate> {
  final _debouncer = Debouncer(milliseconds: 600);
  List<RealStateModel> realstateList = [];
    List<RealStateCatModel> realcatstateList = [];

  List<RealStateModel> filteredRealstateList = [];
  final controller = Get.put(RealStateController());

  bool loading =true;
  Future<List<RealStateModel>> getRealStates(type) async {



        var response = await Constants.getUrl("api/realstate/get_all");
    
     if (response.statusCode == 200) {

       var body = jsonDecode(response.body);


    for (var item in body["data"]) {
      realstateList.add(RealStateModel.fromJson(item));
    }

     type!=0? realstateList.retainWhere((s) => s.type == type):Container();


    return realstateList;
  }
  return null;
  }
  Future<List<RealStateCatModel>> getCat() async {


        var response = await Constants.getUrl("api/realstate_cat/get_all");
    
     if (response.statusCode == 200) {

       var body = jsonDecode(response.body);

    for (var item in body["data"]) {
      realcatstateList.add(RealStateCatModel.fromJson(item));
    }
    return realcatstateList;
  }
return null;
  }

  @override
  void initState() {
    super.initState();

   

    getCat().then((value) {
      setState(() {
        realcatstateList = value;

         });
        });


       getRealStates(0).then((value) {
      setState(() {
        realstateList = value;

        filteredRealstateList = realstateList;
                loading = false;

      });

       
    });  
  }

  @override
  Widget build(BuildContext context) {
    bool _on = false;

    var size = MediaQuery.of(context).size;
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("العقارات"),
        actions: [
          RealEstatePopupMenu(
              list: filteredRealstateList, controller: controller),
        ],
      ),
      body:    loading? Center(child: CircularProgressIndicator(),):
         Container(
          width: double.infinity,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                width: size.width * 0.9,
                child: SearchBox(
                  changed: (string) {
                    string = string.toLowerCase();
                    _debouncer.run(() {
                      setState(() {
                        filteredRealstateList = realstateList
                            .where((u) => (u.title
                                    .toLowerCase()
                                    .contains(string) ||
                                (u.subtitle.toLowerCase().contains(string))))
                            .toList();
                      });
                    });
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(height: 50, child: chips()),
              SizedBox(
                height: size.height * 0.03,
              ),
              Expanded(
                child: loading?Center(child: CircularProgressIndicator(),): filteredRealstateList.length == 0
                    ? Center(
                        child: Text("لا توجد بيانات"),
                      )
                    : ListView.builder(
                        itemCount: filteredRealstateList.length,
                        itemBuilder: (context, i) {
                          return RealEstateItem(
                            size: size,
                            title: filteredRealstateList[i].title,
                            subtitle: filteredRealstateList[i].subtitle,
                            press: () => Get.to(() => RealEstateDetails(
                              realstateList: filteredRealstateList[i],
                            )),
                            desc: filteredRealstateList[i].desc,
                            img: filteredRealstateList[i].img,
                            isOccupy: filteredRealstateList[i].isOccupy,
                            type:filteredRealstateList[i].type
                          );
                        }),
              ),
            ],
          ),
        ),
   
    );
  }

updateList(type){

        realstateList.clear();
        filteredRealstateList.clear();

        getRealStates(type).then((value) {
          setState(() {
            realstateList = value;

            filteredRealstateList = realstateList;
          });
        });
}

  Widget chips() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: realcatstateList.length,
          itemBuilder: (context, i) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child:  RChip(
              txt: realcatstateList[i].cat_name,
              press: () => updateList(realcatstateList[i].cat_id),
              width: 0.25,
              btnColor: realcatstateList[i].getmyColor,
            ),
            );
          }),
    );
  }

}
class RealEstateItem extends StatelessWidget {
  const RealEstateItem(
      {Key key,
      @required this.size,
      @required this.press,
      this.isOccupy = 0,
      @required this.title,
      @required this.subtitle,
      @required this.desc,
  
      @required this.img,
          @required this.type,
      })
      : super(key: key);

  final Size size;
  final isOccupy;
  final Function press;

  final String title;
  final String subtitle;
  final String desc;
  final String img;
  final int type;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.03,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(title,textAlign: TextAlign.end,),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              subtitle,textAlign: TextAlign.end,
                              style: TextStyle(color: btnBlue, fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              desc,maxLines: 3,overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                             SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Stack(
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:  ImageNetwork(url:"${Constants.resUrl}${img}",height: 140),

                            
                            ),
                          ),
                          isOccupy == 0
                              ? Container()
                              : Positioned(
                                  right: 0,
                                  top: 0,

                                  child:  Container(
                                    child: Image.asset(type == 2 || type==4 ?"assets/images/rented.png" : "assets/images/sold.png",width: 150,height:140),
                                  )),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
              ],
            )),
      ),
    );
  }
}
