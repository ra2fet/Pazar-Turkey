import 'package:flutter/material.dart';

class TourismModel implements Comparable {
  final int id;
  final String title;
  final String name;
  final String desc;
  final String img;
  final double price;
  final int num_comments;

  final double rating;
  final String distance;
  final int cat;
  final String end;
  final String url;

  TourismModel({
    this.id,
    this.title,
    this.name,
    this.desc,
    this.img,
    this.price,
    this.rating,
    this.distance,
    this.num_comments,
    this.cat,
    this.end,    this.url,

  });

  factory TourismModel.fromJson(Map<String, dynamic> json) => TourismModel(
      id:int.parse(json["t_id"])  ,
      title: json["title"],
      name: json["t_name"],
      desc: json["t_desc"],
      cat: int.parse(json["t_cat"]),
      rating: double.parse(json["t_rating"]),
      distance: json["t_distance"],
      num_comments: int.parse(json["t_numofcomments"]),
      img: json["image"],
      price: double.parse(json["price"]),
      end: json["end_date"],
      url: json["url"],
      );

  ///Mapping the properties
  Map<String, dynamic> _toMap() {
    return {'id': id, 'title': title, 'price': price};
  }

  ///get function to get the properties of Item
  dynamic get(String propertyName) {
    var _mapRep = _toMap();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }
/* int mySortComparison(RealStateModel a, RealStateModel b) {
  if (a.price < b.price ) {
    return -1;
  } else if (a.price > a.price) {
    return 1;
  } else {
    return 0;
  }
} */

  @override
  int compareTo(other) {
    int nameComp = this.cat.compareTo(other.cat);
    if (nameComp == 0) {
      return -this.price.compareTo(other.price); // '-' for descending
    }

    return nameComp;
  }

/* List sorted(Iterable input, [compare, key]) {
  comparator(price, key) {
    if (compare == null && key == null)
      return (a, b) => a.compareTo(b);
    if (compare == null)
      return (a, b) => key(a).compareTo(key(b));
    if (key == null)
      return compare;
    return (a, b) => compare(key(a), key(b));
  }
  List copy = new List.from(input);
  copy.sort(comparator(compare, key));
  return copy;
}
 */
  @override
  String toString() {
    return price.toString();
  }
}

class TourismCatModel {
  final int cat_id;
  final String cat_name;
  final String color;
  final String icon;

  TourismCatModel({
    this.cat_id,
    this.cat_name,
    this.color,
    this.icon,
  });

  factory TourismCatModel.fromJson(Map<String, dynamic> json) =>
      TourismCatModel(
        cat_id: int.parse(json["id"])   ,
        cat_name: json["cat_name"],
        color: json["color"],
        icon: json["icon"],
      );
  Color get getmyColor {
    final hexCode = color.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
