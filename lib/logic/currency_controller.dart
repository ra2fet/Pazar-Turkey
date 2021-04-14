import 'package:get/get.dart';

class CurrencyController extends GetxController{

  String fromCurrencyName= "اختر العملة";
  String fromCurrencyCode= "المراد تحويل منها";

  int convertFactor = 0;

  String toCurrencyName= "اختر العملة";
  String toCurrencyCode= "المراد تحويل إليها";


  void updateFromCurrency(value1,value2) {

    fromCurrencyCode=value1;
    fromCurrencyName=value2;
    
    update(); // use update() to update counter variable on UI when increment be called
  }

  void updateToCurrency(value1,value2) {

    toCurrencyCode=value1;
    toCurrencyName=value2;
    
    update(); // use update() to update counter variable on UI when increment be called
  }

  


}