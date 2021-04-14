import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pazar_app/models/article_model.dart';
import 'package:pazar_app/models/car_model.dart';
import 'package:pazar_app/models/currency_model.dart';
import 'package:pazar_app/models/favorite_model.dart';
import 'package:pazar_app/models/homesearch_model.dart';
import 'package:pazar_app/models/location_model.dart';
import 'package:http/http.dart' as http;
import 'package:pazar_app/models/notification_model.dart';
import 'package:pazar_app/models/pray_model.dart';
import 'package:pazar_app/models/servicecomments_model.dart';
import 'package:pazar_app/models/social_model.dart';
import 'package:pazar_app/pages/details/articlesdetail.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Requests {
  static Future<List> getAppRequest(url, T) async {
    List list = [];

    var response = await http.get("${Constants.baseUrl}$url",
        headers: Constants.apiAuth());

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body["data"]);

      for (var item in body["data"]) {
        list.add(T.fromJson(item));
      }

      return list;
    }
    return list;
  }

  static Future<PrayModel> getPrayTimes(city) async {
    var prays = null;

    try {
      var response = await http.get(
          "https://api.aladhan.com/v1/calendarByCity?city=Turkey&country=${city}");

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        prays = PrayModel.fromJson(body);
      }
    } catch (e) {
      return prays;
    }
    return prays;
    //  return null;
  }

  static Future<List<SocialModel>> getSocialItems() async {
    List<SocialModel> social = [];


    try {
          var response = await Constants.getUrl("api/config_social/get_all/");

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      for (var item in body["data"]) {
        social.add(SocialModel.fromJson(item));
      }
      return social;
    }

    } catch (e) {
    }
    return null;
  }

  static Future<List<ServicesCommentsModel>> getUserProfile(id) async {
          List<ServicesCommentsModel> comments = [];

    var response =
        await Constants.getUrl("api/turkey_economic_comments/get_all/");

    if (response.statusCode == 200) {

      try {
        var body = jsonDecode(response.body);

      for (var item in body["data"]) {
        comments.add(ServicesCommentsModel.fromJson(item));
      }

      comments.retainWhere((s) => s.post_id == id);
              return comments;

      } catch (e) {
              return comments;

      }
      
    }

    return null;
  }

  static Future<List<ServicesCommentsModel>> getTurkeyEconomicComments(
      id) async {
              List<ServicesCommentsModel> comments = [];

    var response =
        await Constants.getUrl("api/turkey_economic_comments/get_all/");

    if (response.statusCode == 200) {

      try {
      var body = jsonDecode(response.body);


      for (var item in body["data"]) {
        comments.add(ServicesCommentsModel.fromJson(item));
      }

      comments.retainWhere((s) => s.post_id == id);
              return comments;

        
      } catch (e) {
              return comments;

      }
    }

    return null;
  }

  static Future<List<FavoriteModel>> getUserFavorites() async {
    List<FavoriteModel> fav = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt("user_id");

    var response =
        await Constants.getUrl("api/users_favorite/getUserList/$user");

    if (response.statusCode == 200) {
      try {


         var body = jsonDecode(response.body);

      for (var item in body["data"]) {
        fav.add(FavoriteModel.fromJson(item));
      }
                    return fav;

      } catch (e) {
              return fav;

      }
     

    }

    return null;
  }

  static Future<List<NotificationModel>> getNotification() async {
    List<NotificationModel> noti = [];

    var response = await Constants.getUrl("api/notification/get_all/");

    if (response.statusCode == 200) {
      try {
              var body = jsonDecode(response.body);

      for (var item in body["data"]) {
        noti.add(NotificationModel.fromJson(item));
      }
            return noti;


      } catch (e) {
                    return noti;

      }

    }

    return null;
  }

  static Future<List<CarModel>> getCars(context) async {
          List<CarModel> cars = [];

    var response = await Constants.getUrl("api/car/get_all");
    //String data =
    //  await DefaultAssetBundle.of(context).loadString("assets/json/car.json");

    if (response.statusCode == 200) {
      try {
         var body = jsonDecode(response.body);

      for (var item in body["data"]) {
        cars.add(CarModel.fromJson(item));
      }

      return cars;
      } catch (e) {
        return cars;
      }
     
    }
    //    cars.retainWhere((s) => s.post_id == id);

/*     if (cname != null && ctype != null && cengine != null)
      cars.retainWhere((u) =>
          u.carname.toLowerCase().contains(cname) &&
          u.cartype.toLowerCase().contains(ctype) &&
          u.enginetype.toLowerCase().contains(cengine));
    else if (cname != null && ctype != null)
      cars.retainWhere((u) =>
          u.carname.toLowerCase().contains(cname) &&
          u.cartype.toLowerCase().contains(ctype));
    else if (cname != null)
      cars.retainWhere((u) => u.carname.toLowerCase().contains(cname));
 */
    return null;
  }

  static Future<List<ServicesCommentsModel>> getArticlesComments(id) async {
    List<ServicesCommentsModel> comments = [];

    var response = await Constants.getUrl("api/articles_comments/get_all/");

    if (response.statusCode == 200) {
      try {
        var body = jsonDecode(response.body);

        for (var item in body["data"]) {
          comments.add(ServicesCommentsModel.fromJson(item));
        }

        comments.retainWhere((s) => s.post_id == id);
        return comments;
      } catch (e) {
        return comments;
      }
    }

    return null;
  }

  static Future<List<ServicesCommentsModel>> getRealStateComments(id) async {
    List<ServicesCommentsModel> comments = [];

    var response = await Constants.getUrl("api/realstate_comments/get_all/");

    if (response.statusCode == 200) {
      try {
        var body = jsonDecode(response.body);

        for (var item in body["data"]) {
          comments.add(ServicesCommentsModel.fromJson(item));
        }

        comments.retainWhere((s) => s.post_id == id);
        return comments;
      } catch (e) {
        return comments;
      }
    }

    return null;
  }

  static Future<List<ServicesCommentsModel>> getTourismPlacesComments(
      id) async {
    List<ServicesCommentsModel> comments = [];

    var response =
        await Constants.getUrl("api/tourism_places_comments/get_all/");

    if (response.statusCode == 200) {
      try {
        var body = jsonDecode(response.body);

        for (var item in body["data"]) {
          comments.add(ServicesCommentsModel.fromJson(item));
        }

        comments.retainWhere((s) => s.post_id == id);

        return comments;
      } catch (e) {
        return comments;
      }
    }

    return null;
  }

  static Future<List<ServicesCommentsModel>> getServiceComments(
      id, menu) async {
    List<ServicesCommentsModel> comments = [];

    var response;
    if (menu) {
      response = await Constants.getUrl("api/service_types_comments/get/$id/");
    } else {
      response = await Constants.getUrl("api/service_comments/get/$id/");
    }
    if (response.statusCode == 200) {
      try {
        var body = jsonDecode(response.body);

        for (var item in body["data"]) {
          comments.add(ServicesCommentsModel.fromJson(item));
        }
        return comments;
      } catch (e) {
        return comments;
      }

      //   comments.retainWhere((s) => s.post_id == id);

/* suggestions.retainWhere((u) => (u.name.toLowerCase().contains(filter)||
                                (u.type.toLowerCase().contains(filter)))).toList();
 */

    }
    return null;
  }

  static Future<List<HomeSearchModel>> getSuggestions(filter) async {
    List<HomeSearchModel> suggestions = [];

    var response = await Constants.getUrl("api/search/get_all");

    if (response.statusCode == 200) {
      try {
        var body = jsonDecode(response.body);
        print(body["data"]);

        for (var item in body["data"]) {
          suggestions.add(HomeSearchModel.fromJson(item));
        }
      

        suggestions.retainWhere(
            (s) => s.name.toLowerCase().contains(filter.toLowerCase()));
        return suggestions;
      } catch (e) {
        return suggestions;
      }

/* suggestions.retainWhere((u) => (u.name.toLowerCase().contains(filter)||
                                (u.type.toLowerCase().contains(filter)))).toList();
 */

    }

    return null;
  }

  static Future<Location> getLocations2(filter) async {
    var loc = null;

    try {
      var response = await Constants.getUrl("api/location/get_all");

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        loc = Location.fromJson(body);
      }
            return loc;

    } catch (e) {
      return loc;
    }
    return null;
    //  return null;
  }

  static Future<List<Location>> getLocations(filter) async {
    var response = await Constants.getUrl("api/location/get_all");
      List<Location> locations = [];

    if (response.statusCode == 200) {

      try {
         var body = jsonDecode(response.body);

      for (var item in body["data"]) {
        locations.add(Location.fromJson(item));
      }

      return locations;
      } catch (e) {
         return locations;
      }
     
    }
    return null;
  }

/* Future<Model> getRequest(url) async{

try {
   var response= await http.get(url);

  var model = null;

  if(response.statusCode == 200){

    var body = jsonDecode(response.body);

      model=Model.fromJson(jsonMap);
  }
} catch (e) {
     return model;

}
    return model;

} */

  static addComments(url, rating, comment, postid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("user_id");

    var response = await Constants.postUrlWithPara(url, {
      "c_comment": comment,
      "c_rating": rating.toString(),
      "c_user_id": userid.toString(),
      "post_id": postid.toString(),
    });

    var body = jsonDecode(response.body);

    if (body['status'] == 200) {
      print("success");

      return "success";
    }
  }

  static editProfileInfo(id, name, email, mobile, pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("user_id");

    var response = await Constants.postUrlWithPara("api/users/edit/$id", {
      "fullname": name,
      "email": email,
      "mobile": mobile,
      "password": pass,
    });

    var body = jsonDecode(response.body);

    if (body['status'] == 200) {
      print("success");

      return "success";
    }
  }

  static removeFromFavorite(itemid, type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("user_id");

    var response =
        await Constants.postUrlWithPara("api/users_favorite/delete", {
      "item_id": itemid.toString(),
      "user_id": userid.toString(),
      "type": type,
    });

    var body = jsonDecode(response.body);

    if (body['status'] == 200) {
      print("success");

      return "success";
    }
  }

  static checkFavorite(id, type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int user = prefs.getInt("user_id");

    var response =
        await Constants.getUrl("api/users_favorite/get/1/articles/1/");

    if (response.statusCode == 200) {
      // print("success ${response.exist}");
      var body = jsonDecode(response.data);

      return true;
    }

    return false;
  }

  static addToFavorite(itemid, title, subtitle, type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("user_id");

    var response =
        await Constants.postUrlWithPara("api/users_favorite/addnew", {
      "item_id": itemid.toString(),
      "title": title,
      "subtitle": subtitle,
      "user_id": userid.toString(),
      "type": type,
    });

    var body = jsonDecode(response.body);

    if (body['status'] == 200) {
      print("success");

      return "success";
    }

    return null;
  }

  static reserveCar(name, email, mobile, passport, nat, birth, days, price,
      carname, pickupdate, dropoffdate, locationfrom, locationto) async {
    var response =
        await Constants.postUrlWithPara("api/reservation/addnewcar/", {
      "fullname": name,
      "email": email,
      "mobile": mobile,
      "passport": passport,
      "nationality": nat,
      "birthday": birth,
      "numofdays": days.toString(),
      "price": price.toString(),
      "carname": carname,
      "pickupdate": pickupdate.toString(),
      "dropoffdate": dropoffdate.toString(),
      "locationfrom": locationfrom.toString(),
      "locationto": locationto.toString()
    });

    var body = jsonDecode(response.body);

    if (body['status'] == 200) {
      print("success");

      return "success";
    }
  }

  static reserveRealState(name, email, mobile, passport, nat, birth, days,
      price, realstatename, realstatetype, pickupdate, dropoffdate) async {
    var response =
        await Constants.postUrlWithPara("api/reservation/addnewrealstate", {
      "fullname": name,
      "email": email,
      "mobile": mobile,
      "passport": passport,
      "nationality": nat,
      "birthday": birth,
      "numofdays": days.toString(),
      "price": price.toString(),
      "realstatename": realstatename,
      "realstatetype": realstatetype,
      "pickupdate": pickupdate.toString(),
      "dropoffdate": dropoffdate.toString(),
    });

    var body = jsonDecode(response.body);

    if (body['status'] == 200) {
      print("success");

      return "success";
    }
  }

  static reserveTourismProgram(name, email, mobile, passport, nat, birth, price,
      programname, pickupdate) async {
    var response = await Constants.postUrlWithPara(
        "api/reservation/addnewtourismprogram", {
      "fullname": name,
      "email": email,
      "mobile": mobile,
      "passport": passport,
      "nationality": nat,
      "birthday": birth,
      "price": price.toString(),
      "programname": programname,
      "pickupdate": pickupdate.toString(),
    });

    var body = jsonDecode(response.body);

    if (body['status'] == 200) {
      print("success");

      return "success";
    }
  }

  static List<String> arabCurList = <String>[
    "ليك ألباني",
"دولار شرق الكاريبي",
"اليورو",
"دولار بربادوسي",
"نغولتروم بوتاني",
"دولار بروناي",
"فرنك وسط أفريفيا",
"بيزو كوبي",
"دولار الولايات المتحدة",
"جزر فوكلاند جنيه",
"جنيه جبل طارق",
"فورنت مجري",
"ريال ايراني",
"دولار جامايكي",
"دولار استرالي",
"لاو كيب",
"دينار ليبي",
"دينار مقدوني",
"فرنك غرب أفريقي",
"الدولار النيوزيلندي",
"ريال عماني",
"كينا بابوا غينيا الجديدة",
"فرنك رواندي",
"ساموا تالا",
"دينار صربي",
"كرونة سويدية",
"شلن تنزاني",
"درام أرميني",
"دولار باهامي",
"البوسنة والهرسك كونفرتي",
"اسكودو الرأس الأخضر",
"اليوان الصيني",
"كولون كوستاريكي",
"الكورونا التشيكية",
"ناكفا إريتريا",
"لاري جورجي",
"الجورد الهايتي",
"روبية هندية",
"دينار أردني",
"وون كوريا الجنوبية",
"ليرة لبنانية",
"كواشا الملاوية",
"الأوقية الموريتانية",
"متكال موزمبيقي",
"هولندا جزر الأنتيل غولدن",
"نويفو سول بيرو",
"ريال قطري",
"دوبرا ساو تومي وبرينسيبي",
"ليون سيراليوني",
"شلن صومالي",
"جنيه سوداني",
"الليرة السورية",
"الأنغولية كوانزا",
"فلورين أروبي",
"دينار بحريني",
"دولار بليزي"
"بوتسوانا بولا",
"فرنك بوروندي",
"دولار جزر كايمان",
"بيزو كولومبي",
"كرونة دانمركية",
"كوتزال غواتيمالا",
"هندوراس لمبيرا",
"روبية إندونيسية",
"شيكل إسرائيلي جديد",
"التنغ الكازاخستاني",
"دينار كويتي",
"ليسوتو لوتي",
"رينغيت ماليزي",
"روبية موريشيوسية",
"التوغريك المنغولي",
"ميانما كيات",
"النيرة النيجيرية",
"بالبوا بنمي",
"بيزو فلبيني",
"ليو روماني",
"الريال السعودي",
"دولار سينغافوري",
"راند جنوب أفريقيا",
"دولار سورينامي",
"دولار تايواني جديد",
"بانغا",
"الدينار الجزائري",
"بيزو أرجنتيني",
"المانات الأذربيجاني",
"روبل بيلاروسي",
"بوليفيانو بوليفي",
"ليف بلغاري",
"دولار كندي",
"بيزو شيلى",
"فرنك كونغولي",
"بيزو دومنيكاني",
"دولار فيجي",
"الدالاسي الجامبي",
"دولار جوياني",
"كرونا أيسلندية",
"الدينار العراقي",
"الين الياباني",
"وون كوريا الشمالية",
"لاتس لاتفية",
"فرنك سويسري",
"مدغشقر أرياري",
"ليو مولدوفا",
"درهم مغربي",
"روبية نيبالية",
"كوردوبا النيكاراغوية",
"روبية باكستانية",
"غواراني باراغواي",
"جنيه سانت هيلينا",
"روبية سيشيلية",
"دولار جزر سليمان",
"روبية سريلانكية",
"بات تايلاندي",
"الليرة التركية الجديدة",
"درهم إماراتي",
"فانواتو فاتو",
"ريال يمني",
"أفغاني أفغاني",
"تاكا بنجلاديشي",
"ريال برازيلي",
"رييال كمبودي",
"فرنك جزر القمر",
"كونا كرواتية",
"فرنك جيبوتي",
"الجنيه المصري",
"البر الإثيوبي",
"فرنك سي إف بي",
"سيدي غانا",
"فرنك غينيا",
"الدولار هونج كونج",
"حقوق السحب الخاصة",
"شلن كيني",
"سوم قيرغيزستاني",
"دولار ليبيري",
"باتاكا ماكاوي",
"الروفيا المالديفية",
"بيزو مكسيكي",
"دولار ناميبي",
"كرونة نرويجية",
"الزلوتي البولن,دي",
"روبل روسي",
"سوازي ليلانجيني",
"طاجيكستان سوموني",
"دولار ترينيداد وتوباغو",
"شلن أوغندي",
"بيزو أوروغواي",
"دونغ فيتنامي",
"دينار تونسي",
"هريفنيا أوكرانية",
"سوم أوزبكستان",
"تركمانستان مانات",
"الجنيه البريطاني",
"كواشا زامبيا",
"بيتكوين",
"روبل بيلاروسي جديد",
"دولار برمودي",
"جنيه جيرنزي",
"وحدة الحساب الشيلية",
"بيزو كوبي قابل للتحويل",
"مانكس جنيه",
"جيرسي الجنيه",
"كولون سلفادوري",
"الكواشا الزامبية القديمة",
"الفضة (أونصة تروي)",
"دولار زيمبابوي"
  ];

  static List<String> natList = <String>[
    "أفغاني",
    "الألبانية",
    "جزائري",
    "أمريكي",
    "أندورا",
    "الأنغولية",
    "أنتيجوان",
    "الأرجنتيني",
    "أرميني",
    "الاسترالية",
    "النمساوي",
    "أذربيجان",
    "جزر البهاما",
    "بحريني",
    "بنجلاديشية",
    "بربادوس",
    "باربودان",
    "باتسوانا",
    "البيلاروسية",
    "بلجيكي",
    "بليز",
    "بنين",
    "بوتاني",
    "بوليفي",
    "البوسنية",
    "برازيلي",
    "بريطاني",
    "بروناي",
    "البلغارية",
    "بوركينا فاسو",
    "البورمية",
    "بوروندي",
    "كمبودي",
    "الكاميروني",
    "كندي",
    "الرأس الأخضر",
    "أفريقيا الوسطى",
    "التشادية",
    "تشيلي",
    "صينى",
    "الكولومبي",
    "جزر القمر",
    "الكونغولية",
    "كوستاريكا",
    "الكرواتية",
    "الكوبي",
    "القبرصي",
    "التشيكية",
    "دانماركي",
    "جيبوتي",
    "الدومينيكان",
    "هولندي",
    "التيموريون الشرقيون",
    "الاكوادوري",
    "مصري",
    "أميركي",
    "غينيا الاستوائية",
    "اريتريا",
    "الإستونية",
    "الاثيوبية",
    "فيجي",
    "الفلبينية",
    "الفنلندية",
    "فرنسي",
    "الغابونية",
    "غامبي",
    "الجورجية",
    "ألمانية",
    "الغانية",
    "اليونانية",
    "غرينادا",
    "غواتيمالا",
    "غينيا بيساوان",
    "غينيا",
    "جوياني",
    "الهايتي",
    "هيرزيغوفينيان",
    "هندوراس",
    "المجرية",
    "آي كيريباتي",
    "آيسلندي",
    "هندي",
    "الأندونيسية",
    "إيراني",
    "عراقي",
    "إيرلندي",
    "إسرائيلي",
    "إيطالي",
    "ساحل العاج",
    "جامايكا",
    "اليابانية",
    "أردني",
    "الكازاخستانية",
    "كيني",
    "كيتيان ونيفيسيان",
    "كويتي",
    "قيرغيزستان",
    "اللاوسي",
    "لاتفيا",
    "لبناني",
    "الليبيرية",
    "ليبي",
    "ليختنشتاينر",
    "الليتوانية",
    "لوكسمبورج",
    "المقدونية",
    "مدغشقر",
    "مالاوي",
    "ماليزي",
    "مالديفان",
    "مالي",
    "المالطية",
    "مارشال",
    "موريتاني",
    "موريشيوس",
    "مكسيكي",
    "ميكرونيزي",
    "مولدوفا",
    "موناكان",
    "المنغولية",
    "مغربي",
    "موسوتو",
    "موتسوانا",
    "موزمبيقى",
    "الناميبي",
    "ناورو",
    "النيبالية",
    "نيوزيلندي",
    "نيكاراغوا",
    "نيجيري",
    "النيجر",
    "كوري شمالي",
    "شمالية إيرلندية",
    "النرويجية",
    "عماني",
    "باكستاني",
    "بالاوان",
    "بنمي",
    "بابوا غينيا الجديدة",
    "باراغواي",
    "بيرو",
    "تلميع",
    "البرتغالية",
    "قطري",
    "روماني",
    "الروسية",
    "رواندا",
    "سانت لوسيان",
    "السلفادورية",
    "ساموا",
    "سان مارينيزي",
    "ساو توميان",
    "سعودي",
    "اسكتلندي",
    "سنغالي",
    "الصربية",
    "سيشيل",
    "سيراليوني",
    "سنغافوري",
    "السلوفاكية",
    "السلوفينية",
    "جزر سليمان",
    "الصومالية",
    "جنوب افريقيا",
    "كوريا الجنوبية",
    "الأسبانية",
    "سري لانكا",
    "سوداني",
    "سورينامير",
    "سوازي",
    "السويدية",
    "سويسري",
    "سوري",
    "تايوانية",
    "طاجيك",
    "التنزانية",
    "التايلاندية",
    "التوغو",
    "تونغا",
    "ترينيدادية أو توباغونية",
    "تونسي",
    "اللغة التركية",
    "توفالوان",
    "أوغندا",
    "الأوكرانية",
    "أوروغواي",
    "أوزبكستان",
    "فنزويلية",
    "الفيتنامية",
    "ويلزي",
    "يمني",
    "زامبيا",
    "زمبابوي"
  ];

  static IconData getIcons(icon) {
    if (icon == "r1")
      icon = Icons.shopping_bag;
    else if (icon == "r2")
      icon = Icons.restaurant;
    else if (icon == "r3")
      icon = Icons.local_drink;
    else if (icon == "r4")
      icon = Icons.park;
    else if (icon == "r5")
      icon = Icons.family_restroom;
    else if (icon == "r6")
      icon = Icons.home_work_outlined;
    else if (icon == "r7")
      icon = Icons.traffic_sharp;
    else if (icon == "r8")
      icon = Icons.nature_people_outlined;
    else if (icon == "r9")
      icon = Icons.phonelink_rounded;
    else if (icon == "r10")
      icon = Icons.medical_services_sharp;
    else if (icon == "r11")
      icon = Icons.medical_services_sharp;
    else if (icon == "r12") icon = Icons.place;

    return icon;
  }
}
