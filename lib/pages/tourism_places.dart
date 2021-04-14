import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:multi_sort/multi_sort.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pazar_app/logic/realstate_controller.dart';
import 'package:pazar_app/models/realstate_model.dart';
import 'package:pazar_app/models/toursim_model.dart';
import 'package:pazar_app/pages/details/tourism_places_details.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/widgets/imagenetwork.dart';
import 'package:pazar_app/widgets/searchbox.dart';
import 'package:pazar_app/widgets/tchip.dart';

class TourismPlaces extends StatefulWidget {
  @override
  _TourismPlacesState createState() => _TourismPlacesState();
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

class _TourismPlacesState extends State<TourismPlaces> {
  final _debouncer = Debouncer(milliseconds: 600);
  List<TourismModel> tourismList = [];
    List<TourismCatModel> tourismcatList = [];
      bool loading = true;
      bool loadingcatfilter = true;

  List<TourismModel> filteredTourismList = [];
  final controller = Get.put(RealStateController());
  Future<List<TourismModel>> getMethod(cat) async {

    //var response = await Constants.getUrl("api/tourism_places/get_all");
    var response = await Constants.getUrl("api/tourism_places/getcat/$cat");

     if (response.statusCode == 200) {

       var body = jsonDecode(response.body);

    for (var item in body["data"]) {
      tourismList.add(TourismModel.fromJson(item));
    }

     //   tourismList.retainWhere((s) => s.cat == cat);


    return tourismList;
  }
      return null;
  }

    Future<List<TourismCatModel>> getCat(cat) async {

var response = await Constants.getUrl("api/tourism_places_catogeries/get_all");
    
     if (response.statusCode == 200) {

       var body = jsonDecode(response.body);

    for (var item in body["data"]) {
      tourismcatList.add(TourismCatModel.fromJson(item));
    }
    return tourismcatList;
  }
return null;
    }

  @override
  void initState() {
    super.initState();
       getMethod(1).then((value) {


      setState(() {
        tourismList = value;

        filteredTourismList = tourismList;
loadingcatfilter=false;

      });

        
    }); 

 getCat(1).then((value) {


      setState(() {
        tourismcatList = value;
                loading = false;

      ///  filteredTourismList = tourismList;

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
        title: Text("الأماكن السياحية"),
        actions: [
          //    RealEstatePopupMenu(list:filteredTourismList,controller :  controller),
        ],
      ),
      body:loading? Center(child:CircularProgressIndicator()): Container(
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
                        filteredTourismList = tourismList
                            .where((u) => (u.title
                                    .toLowerCase()
                                    .contains(string) ||
                                (u.name.toLowerCase().contains(string))))
                            .toList();
                      });
                    });
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
          Container(height: 80, child: chips()),
              SizedBox(
                height: size.height * 0.03,
              ),
     
                  Expanded(
                child: loadingcatfilter?Center(child:CircularProgressIndicator()):filteredTourismList.length==0?Center(child: Text("لا توجد بيانات"),):ListView.builder(
                    itemCount: filteredTourismList.length,
                    itemBuilder: (context, i) {


                      return TourismItem(
                        size: size,
                        list:filteredTourismList[i],
                        press: ()=> Get.to(TourismPlacesDetails(list:filteredTourismList[i] ,)),
                      );
                    }),
              ),
            ],
          ),
        ),
     
    );
  }
  Widget chips() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tourismcatList.length,
          itemBuilder: (context, i) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TChip(
              txt: tourismcatList[i].cat_name,
              press: () => filterBtn(tourismcatList[i].cat_id),
              width: 0.33,
              btnColor:tourismcatList[i].getmyColor,
              icon: tourismcatList[i].icon
            ),
            );
          }),
    );
  }
    filterBtn(cat) {
            loadingcatfilter=true;

        tourismList.clear();
        filteredTourismList.clear();

        getMethod(cat).then((value) {
          setState(() {
            tourismList = value;

            filteredTourismList = tourismList;
            loadingcatfilter=false;

          });
        
      });
  }
}




class TourismItem extends StatelessWidget {
  const TourismItem(
      {Key key,
      @required this.size,
      @required this.press,
      this.list 
     })
      : super(key: key);

  final Size size;
final list;
  final Function press;
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
                  height: size.height * 0.01,
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
                            Text(list.title,style: TextStyle(fontSize: 16, color: Colors.grey[500]),textAlign: TextAlign.end,maxLines: 1,),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                         Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.star,size: 20,
                                      color: Colors.grey[500],
                                    ),
                                    SizedBox(width: 5,),
                                    Text(
                                      list.rating.toString(),textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.grey[500], fontSize: 17),
                                    ),
                                  ],
                                ),
                                Text(
                                  list.name,
                                  style:
                                      TextStyle(color: btnBlue, fontSize: 17),
                                ),
                       
                              ],
                            ),
                            
                            if(list.end.toString().isNotEmpty && !list.end.toString().startsWith("00"))
                                  Text(
                             "${list.end} ينتهي بتاريخ" ,
                              textAlign: TextAlign.end,style: TextStyle( color: Colors.grey[500]),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                           


                            
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ImageNetwork(url:"${Constants.resUrl}${list.img}"),
                          
                       
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
              ],
            )),
      ),
    );
  }
}
