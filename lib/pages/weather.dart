import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pazar_app/models/weather_model.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/widgets/custom_listtile.dart';
import 'package:pazar_app/widgets/rchip.dart';

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  WeatherModel _weathermodel;
  String _city = "Antalya";
  String lat, lon;

  void getCityCords(String city) {
    if (city == "Antalya") {
      lat = "36.7741";
      lon = "30.7178";
    }
    if (city == "Trabzon") {
      lat = "40.9167";
      lon = "39.8333";
    }
    if (city == "Bursa") {
      lat = "40.1667";
      lon = "29.0833";
    }
    if (city == "Ankara") {
      lat = "39.9199";
      lon = "32.8543";
    }
    if (city == "Istanbul") {
      lat = "28.9833";
      lon = "41.0351";
    }
  }

  Future<WeatherModel> getWeather(String city) async {
    getCityCords(city);

    var response = await http.get(
        "https://api.openweathermap.org/data/2.5/onecall?lat=${lat}&lon=${lon}&exclude=alerts,minutely,hourly,current&appid=494b6c616a69c4e8f08d3001d281cb64&units=metric&lang=ar");

    final body = json.decode(response.body);
    setState(() {
      _weathermodel = WeatherModel.fromJson(body);
    });

    return _weathermodel;
  }

  @override
  void initState() {
    super.initState();

    getWeather(_city);
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
        title: Text("حالة الطقس"),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.height * 0.02,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
              SizedBox(
                height: size.height * 0.02,
              ),
              _weathermodel == null
                  ? Container(
                      height: size.height - 160,
                      child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: Column(
                        children: [
                          Text(
                            countryToArabic(_city),
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 17),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _weathermodel.daily.length - 1,
                              itemBuilder: (BuildContext context, int index) {
                                return showWeatherDays(
                                    _weathermodel
                                        .daily[index].weather[0].getUrlIcon,
                                    _weathermodel.daily[index].dayDate,
                                    _weathermodel
                                        .daily[index].weather[0].description,
                                    "${_weathermodel.daily[index].temp.min.toStringAsFixed(0)} / ${_weathermodel.daily[index].temp.max.toStringAsFixed(0)}");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  filterBtn(city) {
    setState(() {
      _city = city;
      getWeather(_city);
    });
  }
}

Widget showWeatherDays(img, title, subtitle, degree) {
  return Card(
    elevation: 3,
    child: ListTile(
      leading: img.toString().contains("01d")
          ? SvgPicture.asset(
              "assets/icons/sunny.svg",
              semanticsLabel: "$img",
            )
          : img.toString().contains("10d")
              ? SvgPicture.asset(
                  "assets/icons/rain.svg",
                  semanticsLabel: "$img",
                )
              : img.toString().contains("02d")
                  ? SvgPicture.asset(
                      "assets/icons/sunny_cloud.svg",
                      semanticsLabel: "$img",
                    )
                  : img.toString().contains("11d")
                      ? SvgPicture.asset(
                          "assets/icons/thunder.svg",
                          semanticsLabel: "$img",
                        )
                      : Image.network(img),
      title: Text("$title"),
      subtitle: Text("$subtitle"),
      trailing: Text(
        "$degree",
        style: TextStyle(color: btnYellow, fontSize: 16,fontWeight: FontWeight.w400),
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

  return "  حالة الطقس في " + t;
}
