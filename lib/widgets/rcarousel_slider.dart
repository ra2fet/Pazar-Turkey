import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RCarouselSlider extends StatefulWidget {
  final List<String> imgList;
  final list;
  final type;

  const RCarouselSlider({
    Key key,
    this.imgList,
    this.list,
    this.type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RCarouselSliderState();
  }
}

class _RCarouselSliderState extends State<RCarouselSlider> {
  int _current = 0;
  bool _pressed = false;
  List<Widget> imageSliders = [];

  Future<String> checkFav(id, type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt("user_id");
    print("connect 1");

    var response =
        await Constants.getUrl("api/users_favorite/get/$id/$type/$user/");

    if (response.statusCode == 200) {
      try {
        var body = json.decode(response.body);
        print(body["data"]);

        setState(() {
          _pressed = body["data"][0]["exist"];
        });
      } catch (e) {}

      return "Success";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    checkFav(widget.list.id, widget.type);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width, autoplay,infinite;

    widget.imgList.length != 1 ? width = 1000.0 : Container();
    widget.imgList.length != 1 ? autoplay = true : autoplay = false;
    widget.imgList.length != 1 ? infinite = true : infinite = false;

    imageSliders = widget.imgList.map((item) {
      return Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                FadeInImage(
                  image: NetworkImage("${Constants.resUrl}$item"),
                  fit: BoxFit.cover,
                  width: width,
                  placeholder: AssetImage(
                    "assets/icons/placeholder.jpg",
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    /*   padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              'No. ${imgList.indexOf(item)} image',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ), */
                  ),
                ),
              ],
            )),
      );
    }).toList();

    return Container(
      child: Stack(
        children: [
          Column(children: [
            widget.imgList.length == 0
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.grey.withOpacity(0.7),
                    height: 200)
                : CarouselSlider(
                    items: imageSliders,
                    options: CarouselOptions(
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlay: autoplay,
                        enlargeCenterPage: true,
                                    enableInfiniteScroll: infinite,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imgList.map((url) {
                int index = widget.imgList.indexOf(url);
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? btnYellow
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
          ]),
          Positioned(
            top: 15,
            right: size.width * 0.1,
            child: RawMaterialButton(
              onPressed: () {
                setState(() => _pressed = !_pressed);
                if (_pressed == true)
                  Requests.addToFavorite(widget.list.id, widget.list.title,
                      widget.list.desc, widget.type);
                else
                  Requests.removeFromFavorite(widget.list.id, widget.type);
              },
              elevation: 2.0,
              fillColor: Colors.white,
              child: _pressed
                  ? Icon(
                      Icons.star,
                      size: 23.0,
                      color: btnYellow,
                    )
                  : Icon(
                      Icons.star,
                      size: 23.0,
                      color: Colors.grey,
                    ),
              padding: EdgeInsets.all(5.0),
              shape: CircleBorder(),
            ),
          )
        ],
      ),
    );
  }
}
