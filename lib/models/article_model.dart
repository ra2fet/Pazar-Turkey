class ArticleModel {

  final int id;
  final String title,desc,url,image;

  ArticleModel({this.id, this.title, this.desc, this.url, this.image});

    factory ArticleModel.fromJson(Map<String, dynamic> json) => 
    ArticleModel(
        id: int.parse(json["id"])  ,
        title: json["title"],
        desc: json["description"],
        url: json["url"],
        image: json["image"],
    );
 
}