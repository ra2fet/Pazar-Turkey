import 'package:pazar_app/utils/constants.dart';

class CarModel {
  final String carname, cartype, enginetype, imageurl;
  final int carid, driverage, licenseage, luggagenum, persons;
  final double dailyprice;

  CarModel(
      {this.carname,
      this.cartype,
      this.enginetype,
      this.imageurl,
      this.carid,
      this.driverage,
      this.licenseage,
      this.luggagenum,
      this.persons,
      this.dailyprice});

get imageUrl{

  return Constants.resUrl+imageurl;
}
  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
      carname: json["c_name"],
      cartype: json["c_fueltype"],
      enginetype: json["c_engine"],
      imageurl: json["image"],
      carid:  int.parse(json["c_id"])  ,
      driverage: int.parse(json["c_age"])  ,
      licenseage: int.parse(json["c_licenceage"]),
      luggagenum: int.parse(json["c_laggagenum"]),
      persons: int.parse(json["c_numpeople"]),
      dailyprice: double.parse(json["c_dailyprice"]));
}
