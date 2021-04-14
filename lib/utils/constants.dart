import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class Constants {


  static String apiWApi= "6a7f8967ed0c12f6d0adf949014d782a";
  static String apiWUrl= "https://data.fixer.io/api/";

  static String apiWUrl2= "https://free.currconv.com/api/v7/";
    static String apiWApi2= "82ef8e01c48d84b85ee6";

  static String domain = "https://bazaar-tr.com";
 // static String domain = "http://192.168.1.101";

  static String baseUrl = "$domain/pazar/";



  static String resUrl = "$domain/pazar/resource/image/";

  static getUrl(url){

    return http.get("${Constants.baseUrl}$url",
        headers: Constants.apiAuth());
  }


 static postUrlWithPara(url,body){

    return http.post("${Constants.baseUrl}$url",body: body,
        headers: Constants.apiAuth());
  }

  static Map<String, String> apiAuth() {
    String username = 'admin';
    String password = '1234';
    String basicAuth;

    basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    return <String, String>{'authorization': basicAuth};
  }


   static Future<int> getUserId() async { 
  
           final SharedPreferences prefs = await SharedPreferences.getInstance();



           
            if(prefs.containsKey('user_id')){

            int userid =  prefs.getInt("user_id");

              return userid;
            }
}

   static rSnackbarError(title,content){
        !Get.isSnackbarOpen? Get.snackbar(title, content ,titleText:Text(title,textAlign: TextAlign.center,) ,messageText: Text(content,textAlign: TextAlign.center,),snackPosition: SnackPosition.BOTTOM,borderColor:Colors.red,borderWidth: 1,borderRadius: 12,backgroundColor: Colors.white,margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10)):Container();

    }
       static rSnackbarSuccess(title,content){
        !Get.isSnackbarOpen? Get.snackbar(title, content ,titleText:Text(title,textAlign: TextAlign.center,) ,messageText: Text(content,textAlign: TextAlign.center,),snackPosition: SnackPosition.BOTTOM,borderColor:Colors.green,borderWidth: 1,borderRadius: 12,backgroundColor: Colors.white,margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10)):Container();

    }



}
