import 'package:flutter/material.dart';

class ServicesModel {
  final int id;
  final String title, subtitle, desc,color,url,image;
  final int isMenu;
  ServicesModel({
    this.id,
    this.title,
    this.subtitle,
    this.desc,
     this.color,
          this.url,
          this.image,
this.isMenu, 
  });

   
  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
        id: int.parse(json["s_id"]) ,
        title: json["s_title"],
        subtitle: json["s_subtitle"],
        desc: json["s_desc"],
        color: json["color"],
        url: json["url"],
        image: json["Image"],
        isMenu:int.parse(json["isMenu"]) ,


      );



Color get getmyColor {
  final hexCode = color.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}


     
}
class ServicesDetailsModel {
  final int id,s_id,cat;
  final String title, subtitle, desc,url,image;

  ServicesDetailsModel({
    this.id,
    this.title,
    this.subtitle,
    this.desc,
        this.image,

    this.url,
        this.s_id,
    this.cat
  });

   
  factory ServicesDetailsModel.fromJson(Map<String, dynamic> json) => ServicesDetailsModel(
        id: int.parse(json["st_id"]) ,
        title: json["st_title"],
        subtitle: json["st_subtitle"],
        desc: json["st_desc"],
        url: json["url"],
        s_id: int.parse(json["s_id"]),
        cat:int.parse(json["cat"]),
        image:json["image"]


      );
}