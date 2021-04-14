
class SocialModel {
  final String whatsapp, phone, longitude, latitude;

  SocialModel({this.whatsapp, this.phone, this.longitude, this.latitude});

  factory SocialModel.fromJson(Map<String, dynamic> json) => SocialModel(
        whatsapp: json["whatsapp"],
        phone: json["phone"],
        longitude: json["longitude"],
        latitude: json["latitude"],
      );
}
