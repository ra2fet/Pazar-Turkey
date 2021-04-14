// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'dart:convert';

List<Location> locationFromJson(String str) => List<Location>.from(json.decode(str).map((x) => Location.fromJson(x)));

String locationToJson(List<Location> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Location {
    Location({
        this.id,
        this.name,
        this.filter,
    });

    String id;
    String name;
    Filter filter;

    factory Location.fromJson(Map<String, dynamic> json) => 
    Location(
        id: json["id"],
        name: json["name"],
        filter: json["filter"] == null ? null : filterValues.map[json["filter"]],
    );


   static List<Location> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => Location.fromJson(item)).toList();
  }


    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "filter": filter == null ? null : filterValues.reverse[filter],
    };


    
 @override
  String toString() => name;

}


enum Filter { N, EMPTY }

final filterValues = EnumValues({
    "": Filter.EMPTY,
    "n": Filter.N
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}


