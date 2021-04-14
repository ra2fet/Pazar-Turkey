class ServicesCommentsModel {
  final int id;
  final String name;
  final String comment;
  final double rating;
  final  post_id;

  ServicesCommentsModel(
      {this.id, this.name, this.comment, this.rating, this.post_id});

  factory ServicesCommentsModel.fromJson(Map<String, dynamic> json) =>
      ServicesCommentsModel(
          id: int.parse(json["c_id"]) ,
          name: json["fullname"],
          comment: json["c_comment"],
          rating: double.parse(json["c_rating"]) ,
          post_id: int.parse(json["post_id"]) );
}
