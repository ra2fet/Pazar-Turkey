class HomeSearchModel {
  final int id;
  final String name, type;

  HomeSearchModel({this.id, this.name, this.type});

  factory HomeSearchModel.fromJson(Map<String, dynamic> jsonStr) {
    return HomeSearchModel(
        id: int.parse(jsonStr['id']) , name: jsonStr['item'], type: jsonStr['cat']);
  }
}
