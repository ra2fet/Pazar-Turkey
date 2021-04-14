class ImagesModel {

  final String image1,image2,image3,image4,image5,image6;

  ImagesModel({ this.image1, this.image2, this.image3, this.image4, this.image5, this.image6});

    factory ImagesModel.fromJson(Map<String, dynamic> json) => 
    ImagesModel(
        image1: json["Image1"]  ,
        image2: json["Image2"],
        image3: json["Image3"],
        image4: json["Image4"],
        image5: json["Image5"],
        image6: json["Image6"],
    );
 
}