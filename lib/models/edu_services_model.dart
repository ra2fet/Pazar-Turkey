class EduServicesModel {
  final int id;
  final String title, subtitle, desc,url;
  final String type;

  EduServicesModel( {
    this.id,
    this.title,
    this.subtitle,
    this.desc,
    this.type,
    this.url
  });

  factory EduServicesModel.fromJson(Map<String, dynamic> json) => EduServicesModel(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        desc: json["desc"],
        type: json["type"],
        url: json["url"],

      );
}
