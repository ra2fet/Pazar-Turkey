import 'dart:ui';

class RealStateModel implements Comparable {

 final int id;
 final String title;
  final String subtitle;
  final String desc;
  final  String img ,url,code,rooms,wcs,area,city,region,numstairs,landtype,age,landbuilding,landarea;
  final  String monthlyprice,dailyprice;
  final int type;
  final  double price;

  final int isOccupy;

    RealStateModel( {this.id,this.title,this.subtitle,this.desc,this.img,this.isOccupy,this.type,this.price,this.dailyprice,this.monthlyprice,this.url,this.code, this.rooms, this.wcs, this.area, this.city, this.region,this.numstairs,this.landtype,this.age,this.landarea,this.landbuilding});

    factory RealStateModel.fromJson(Map<String, dynamic> json) =>
       RealStateModel(
        id: int.parse(json["r_id"]) ,
        title: json["r_title"],
         subtitle: json["r_subtitle"],
        desc: json["r_desc"],
        img: json["image"],
        isOccupy:  int.parse(json["r_isSold"]) ,
        type: int.parse(json["r_type"]),
        price:double.parse(json["r_price"]) ,
        dailyprice:json["daily_price"] ,
        monthlyprice:json["monthly_price"] ,
       url: json["r_url"],
       code: json["r_code"],
       age: json["r_age"],

       
       rooms: json["r_rooms"],
       wcs: json["r_num_of_wcs"],
       area: json["r_area"],
       city: json["r_city"],
       region: json["region"],
       numstairs: json["numstairs"],
       landtype: json["landtype"],
       landarea: json["landarea"],
       landbuilding: json["landbuilding"],

    );

      ///Mapping the properties
  Map<String, dynamic> _toMap() {
    return {'id': id,'title': title, 'price': price};
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
   

   int nameComp = this.type.compareTo(other.type);
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


class RealStateCatModel {
  final int cat_id;
  final String cat_name;
  final String color;

  RealStateCatModel({
    this.cat_id,
    this.cat_name,
    this.color,
  });

  factory RealStateCatModel.fromJson(Map<String, dynamic> json) =>
      RealStateCatModel(
        cat_id: int.parse(json["cat_id"]) ,
        cat_name: json["cat_name"],
        color: json["color"],
      );
      
  Color get getmyColor {
    final hexCode = color.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
