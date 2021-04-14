class FavoriteModel {
  final String title,subtitle,type,itemid;

  FavoriteModel({this.title, this.subtitle,this.itemid, this.type});

    factory FavoriteModel.fromJson(Map<String, dynamic> json) => 
    FavoriteModel(
        
        title: json["title"],
        subtitle: json["subtitle"],
        itemid:json["item_id"] ,
        type: json["type"],
    );
 
}