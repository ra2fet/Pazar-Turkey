import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as f;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/homesearch_model.dart';
import 'package:pazar_app/pages/articles.dart';
import 'package:pazar_app/pages/car.dart';
import 'package:pazar_app/pages/currency.dart';
import 'package:pazar_app/pages/currency2.dart';
import 'package:pazar_app/pages/details/articlesdetail.dart';
import 'package:pazar_app/pages/details/servicedetail.dart';
import 'package:pazar_app/pages/details/tourism_places_details.dart';
import 'package:pazar_app/pages/details/turkeyeconomicdetail.dart';
import 'package:pazar_app/pages/prayertimes.dart';
import 'package:pazar_app/pages/realestate.dart';
import 'package:pazar_app/pages/details/realestate_details.dart';
import 'package:pazar_app/pages/reminder.dart';
import 'package:pazar_app/pages/search_homepage.dart';
import 'package:pazar_app/pages/services.dart';
import 'package:pazar_app/pages/tourism_places.dart';
import 'package:pazar_app/pages/turkeyeconomic.dart';
import 'package:pazar_app/pages/weather.dart';
import 'package:pazar_app/providers/push_notifications_provider.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/widgets/home_popup_menu.dart';
import 'package:pazar_app/widgets/itemhome1.dart';
import 'package:pazar_app/widgets/itemhome2.dart';
import 'package:pazar_app/widgets/itemhome3.dart';
import 'package:pazar_app/widgets/itemhome4.dart';
import 'package:pazar_app/widgets/searchbox.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController scrollViewColtroller = ScrollController();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin fltNotification;

  @override
  void initState() {
    scrollViewColtroller = ScrollController();
    scrollViewColtroller.addListener(_scrollListener);

    PushNotificationsProvider push = PushNotificationsProvider();
    push.notitficationPermission(messaging);
    initMessaging(fltNotification);

    //PushNotificationsProvider.initNotification();
    super.initState();
  }

  void getToken() async {
    print(await messaging.getToken());
  }

  String message = '';
  bool _direction = false;

  @override
  void dispose() {
    super.dispose();
    scrollViewColtroller.dispose();
  }

  _moveUp() {
    scrollViewColtroller.animateTo(scrollViewColtroller.offset - 200,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  _moveDown() {
    scrollViewColtroller.animateTo(scrollViewColtroller.offset + 200,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  _scrollListener() {
    if (scrollViewColtroller.offset >=
            scrollViewColtroller.position.maxScrollExtent &&
        !scrollViewColtroller.position.outOfRange) {
      setState(() {
        message = "reach the bottom";
        _direction = true;
      });
    }
    if (scrollViewColtroller.offset <=
            scrollViewColtroller.position.minScrollExtent &&
        !scrollViewColtroller.position.outOfRange) {
      setState(() {
        message = "reach the top";
        _direction = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    TextEditingController searchController = TextEditingController();
//FocusScope.of(context).requestFocus(FocusNode());
    getToken();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("بازار تركيا"),
        actions: [
          HomePopupMenu(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Visibility(
            visible: _direction,
            maintainSize: false,
            child: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                _moveUp();
              },
              child:
                  RotatedBox(quarterTurns: 1, child: Icon(Icons.chevron_left)),
            ),
          ),
          Visibility(
            maintainSize: false,
            visible: !_direction,
            child: FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                _moveDown();
              },
              child:
                  RotatedBox(quarterTurns: 3, child: Icon(Icons.chevron_left)),
            ),
          )
        ],
      ),
      body: NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollViewColtroller.position.userScrollDirection ==
              ScrollDirection.reverse) {
            print('User is going down');
            setState(() {
              message = 'going down';
              _direction = true;
            });
          } else {
            if (scrollViewColtroller.position.userScrollDirection ==
                ScrollDirection.forward) {
              print('User is going up');
              setState(() {
                message = 'going up';
                _direction = false;
              });
            }
          }
          return true;
        },
        child: Container(
          width: double.infinity,
          height: size.height,
          child: SingleChildScrollView(
            controller: scrollViewColtroller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: false,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "بحث",
                      contentPadding: EdgeInsets.zero,
                      suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.5, color: Colors.grey[300])),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.grey[300])),
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return Requests.getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return Directionality(
                      textDirection: f.TextDirection.rtl,
                      child: ListTile(
                        leading: Icon(Icons.search),
                        title: Text(suggestion.name),
                        subtitle: Text(checkType(suggestion.type)),
                      ),
                    );
                  },
                  noItemsFoundBuilder: (context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 15, top: 10, bottom: 10),
                          child: Text(
                            "لا توجد نتائج للبحث",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[900].withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    if (suggestion.type == "realstate") {
                      print("go to realstate ${suggestion.id}");

                      Get.to(() => RealEstateDetails(
                            id: suggestion.id,
                          ));
                    } else if (suggestion.type == "service") {
                      print("go to service");

                      Get.to(() => ServiceDetail(
                            id: suggestion.id,
                          ));
                    } else if (suggestion.type == "servicetype") {
                      print("go to servicetype");

                      Get.to(() => ServiceDetail(
                            id: suggestion.id,
                            ismenu: true,
                          ));
                    } else if (suggestion.type == "article") {
                      print("go to article");

                      Get.to(() => ArticlesDetail(
                            id: suggestion.id,
                          ));
                    } else if (suggestion.type == "toursim") {
                      print("go to toursim");

                      Get.to(() => TourismPlacesDetails(
                            id: suggestion.id,
                          ));
                    } else if (suggestion.type == "turkeyeconomic") {
                      print("go to turkeyeconomic");

                      Get.to(() => TurkeyEconomicDetail(
                            id: suggestion.id,
                          ));
                    }
                    // Get.to( SearchHomePage(type:suggestion.type));
                  },
                ),

                Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: ElevatedButton.icon(
                      onPressed: () => openUrl("https://saraypost.com/sarayfm/"),
                      icon: Icon(Icons.radio),style: ElevatedButton.styleFrom(primary: primaryColor),
                      label: Text(
                        "اذاعة سراي بوست",
                        textAlign: TextAlign.center,
                      ),
                    )),
                //    SearchBox(controller: searchController,changed: (string)=> Get.to(SearchHomePage()),),

                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  children: [
                    ItemHome1(
                      title: "العقارات",
                      width: 0.5,
                      height: 160,
                      img: 'realstate',
                      press: () => Get.to(() => RealEstate()),
                    ),
                    ItemHome1(
                      title: "الخدمات",
                      width: 0.5,
                      height: 160,
                      img: '5dmat',
                      press: () => Get.to(() => Services()),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ItemHome3(
                      title: "مواقيت الصلاة",
                      width: 0.5,
                      height: 240,
                      img: 'mosque',
                      press: () => Get.to(() => PrayerTimes()),
                    ),
                    Wrap(
                      direction: Axis.vertical,
                      children: [
                        ItemHome2(
                          title: "ذكرني",
                          width: 0.5,
                          height: 120,
                          img: 'alarm',
                          press: () => Get.to(() => Reminder()),
                        ),
                        ItemHome2(
                          title: "حالة\nالطقس",
                          width: 0.5,
                          height: 120,
                          img: 'weather',
                          press: () => Get.to(() => Weather()),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    ItemHome4(
                      title: "المقالات",
                      width: 0.5,
                      height: 120,
                      img: 'blog',
                      press: () => Get.to(() => Articles()),
                    ),
                    ItemHome2(
                      title: "حجز السيارات",
                      width: 0.5,
                      height: 120,
                      img: 'car',
                      press: () => Get.to(() => Car()),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ItemHome1(
                      title: "تحويل العملات",
                      width: 0.5,
                      height: 160,
                      img: 't7wel_3omlat',
                      press: () => Get.to(() => Currency2()),
                    ),
                    ItemHome1(
                      title: "الأماكن السياحية",
                      width: 0.5,
                      height: 160,
                      img: 'bramg_sya7ya',
                      press: () => Get.to(() => TourismPlaces()),
                    ),
                  ],
                ),

                Row(
                  children: [
                    ItemHome4(
                      title: "أخبار سراي بوست",
                      width: 1,
                      height: 120,
                      img: 'economic',
                      press: () => Get.to(() => TurkeyEconomic()),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

checkType(status) {
  var type;
  if (status == "realstate") {
    type = "قسم العقارات";
  } else if (status == "service") {
    type = "قسم الخدمات";
  } else if (status == "servicetype") {
    type = "قسم الخدمات";
  } else if (status == "article") {
    type = "قسم المقالات";
  } else if (status == "toursim") {
    type = "قسم الأماكن السياحية";
  } else if (status == "turkeyeconomic") {
    type = "قسم أخبار سراي بوست";
  }

  return type;
}

void openUrl(url) async {
  print("pressed " + url);

  var myurl = url;

  if (await canLaunch(myurl))
    await launch(myurl);
  else
    // can't launch url, there is some error
    throw "Could not launch $myurl";
}
