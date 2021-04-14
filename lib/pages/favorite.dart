import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pazar_app/models/favorite_model.dart';
import 'package:pazar_app/pages/details/articlesdetail.dart';
import 'package:pazar_app/pages/details/realestate_details.dart';
import 'package:pazar_app/pages/details/servicedetail.dart';
import 'package:pazar_app/pages/details/tourism_places_details.dart';
import 'package:pazar_app/pages/details/turkeyeconomicdetail.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/widgets/home_popup_menu.dart';
import 'package:pazar_app/widgets/itemhome1.dart';
import 'package:pazar_app/widgets/itemhome2.dart';
import 'package:pazar_app/widgets/itemhome3.dart';
import 'package:pazar_app/widgets/itemhome4.dart';
import 'package:pazar_app/widgets/rbutton.dart';
import 'package:pazar_app/widgets/rchip.dart';
import 'package:pazar_app/widgets/realestate_popup_menu.dart';
import 'package:pazar_app/widgets/searchbox.dart';

class Favorite extends StatefulWidget {
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<FavoriteModel> fav = [];
  bool loading =true;

  @override
  void initState() {


      
    Requests.getUserFavorites().then((value) {

      setState(() {
                    fav = value;
                  loading=false;
            });
    
    });


        super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("المفضلات"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: loading? Center(child: CircularProgressIndicator(),) :fav.length == 0? Center(child:Text("لا توجد أية عناصر في قائمة المفضلة"),): Container(
        width: double.infinity,
        height: size.height,
        child: ListView.builder(
          itemCount: fav.length,
          itemBuilder: (BuildContext context, int index) {
            return 
                realEstateItem(
                  fav[index],index
                );
              
            
          },
        ),
      ),
    );
  }

  Widget realEstateItem(list,index){

    return InkWell(
      onTap: () => goToPage(list.type,list.itemid),
      child: Container(
      
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 8),
        child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),


                  
                    

                  
                  Row(
                    children: [

                        Expanded(flex: 1,child:   IconButton(icon: Icon(Icons.delete,color: Colors.red,), onPressed: () {
                  
                    Requests.removeFromFavorite(list.itemid, list.type);
                                      
                              setState(() => fav.removeAt(index));
                          }),),

                      Expanded(flex:9,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                                 Text(checkType(list.type),style: TextStyle(color: Colors.grey),),
                                SizedBox(height: 10,),
                              Text(
                               list.title,
                                style: TextStyle(color: btnBlue, fontSize: 17),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                 list.subtitle,maxLines: 2,overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                
                                                

                            ],
                          ),
                        ),
                      ),

                    
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

void goToPage(status,itemid) {

    if(status == "realstate"){
      Get.to(()=>RealEstateDetails(id: int.parse(itemid),));


    }else if (status == "servicetype"){
      print("go to servicetype");

          
          
      Get.to(()=>ServiceDetail(id: int.parse(itemid),));


    }else if (status == "article"){
      print("go to article");
     
      Get.to(()=>ArticlesDetail(id: int.parse(itemid),));
      
    }else if (status == "toursim"){
      print("go to toursim");
            Get.back();
      Get.to(()=>TourismPlacesDetails(id: int.parse(itemid),));


    }else if(status =="turkeyeconomic"){
      Get.to(()=>TurkeyEconomicDetail(id: int.parse(itemid),));


    }

}

checkType(status){
  var type;
if(status == "realstate"){
      
      type="قسم العقارات";

    }else if (status == "servicetype"){
      type="قسم الخدمات";


    }else if (status == "article"){
      type="قسم المقالات";

    }else if (status == "toursim"){
      type="قسم الأماكن السياحية";


    }else if(status =="turkeyeconomic"){
    type = "قسم أخبار سراي بوست";

    }

    return type;
}