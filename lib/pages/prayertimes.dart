import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/pray_model.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/widgets/custom_listtile.dart';
import 'package:pazar_app/widgets/rchip.dart';

class PrayerTimes extends StatefulWidget {
  @override
  _PrayerTimesState createState() => _PrayerTimesState();
}

class _PrayerTimesState extends State<PrayerTimes> {
  String _city = "Antalya";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    List<String> prayer_type = [
      "صلاة الفجر",
      "الشروق",
      "صلاة الظهر",
      "صلاة العصر",
      "صلاة المغرب",
      "صلاة العشاء",
    ];

/*     List<String> prayer_times = [
      "06:35",
      "08:11",
      "13:18",
      "16:02",
      "18:26",
      "19:56",
    ]; */

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text("مواقيت الصلاة"),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.02,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "انطاليا",
                          press: () => filterBtn("Antalya"),
                          width: 0.2,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "طرابزون",
                          press: () => filterBtn("Trabzon"),
                          width: 0.2,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "بورصة",
                          press: () => filterBtn("Bursa"),
                          width: 0.2,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "انقرة",
                          press: () => filterBtn("Ankara"),
                          width: 0.2,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        RChip(
                          txt: "اسطنبول",
                          press: () => filterBtn("Istanbul"),
                          width: 0.2,
                          btnColor: btnBlue,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
                  child: FutureBuilder<PrayModel>(
                      future: Requests.getPrayTimes(_city),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data.data[0].timings;
                          return Column(
                            children: [
                              Text(
                                countryToArabic(_city),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 17),
                              ),
                              showPrayers(
                                prayer_type[0],
                                data.fajr,
                              ),
                              showPrayers(
                                prayer_type[1],
                                data.sunrise,
                              ),
                              showPrayers(
                                prayer_type[2],
                                data.dhuhr,
                              ),
                              showPrayers(
                                prayer_type[3],
                                data.asr,
                              ),
                              showPrayers(
                                prayer_type[4],
                                data.maghrib,
                              ),
                              showPrayers(
                                prayer_type[5],
                                data.isha,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        }
                        return Container(
                            height: size.height - 160,
                            child: Center(child: CircularProgressIndicator()));
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  filterBtn(city) {
    setState(() {
      _city = city;
    });
  }
 
}

Widget showPrayers(title, time) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              time,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
  );
}

String countryToArabic(String c) {
  String t;
  c == "Trabzon" ? t = "طرابزون" : "";
  c == "Antalya" ? t = "انطاليا" : "";
  c == "Bursa" ? t = "بورصه" : "";
  c == "Istanbul" ? t = "اسطنبول" : "";
  c == "Ankara" ? t = "انقرة" : "";

  return "مواقيت الصلاة في " + t;
}
