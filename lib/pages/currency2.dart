import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pazar_app/logic/currency_controller.dart';
import 'package:pazar_app/models/currency_model.dart';
import 'package:pazar_app/providers/requests.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:pazar_app/utils/rtextbox.dart';
import 'package:pazar_app/widgets/custom_listtile.dart';
import 'package:pazar_app/widgets/rbutton.dart';
import 'package:pazar_app/widgets/rchip.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Currency2 extends StatefulWidget {
  @override
  _Currency2State createState() => _Currency2State();
}

class _Currency2State extends State<Currency2> {
  final controller = Get.put(CurrencyController());

  List<String> currencies;
  List<String> currenciesnames;
  String fromCurrency;
  String fromCurrencyname;

  String toCurrency;
  String toCurrencyname;

  String result;
  TextEditingController valueController = TextEditingController();
  
  Future<String> loadCurrencies() async {
    String uri = "${Constants.apiWUrl2}currencies?apiKey=${Constants.apiWApi2}";
    print(uri);

    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});

    var body = json.decode(response.body);
//print(body);
    Map curMap = body["results"];
   currencies = curMap.keys.toList();
   /* curMap.forEach((k,v) { 
        currenciesnames.add(currenciesnames[k].toString());
   }); */

  currenciesnames= curMap.entries.map((e) => e.value["currencyName"].toString()).toList();
  // for (var value in curMap.values){
     //   print(value["currencyName"].toString());

    //  currenciesnames = value["currencyName"].toList();

  // }


  print(currencies);
  print(currenciesnames);
    setState(() {});
    return "Success";
  }

  Future<String> getConversion() async {
    print(
        "From : ${controller.fromCurrencyCode} To : ${controller.toCurrencyCode}");

        var curId = "${controller.fromCurrencyCode}_${controller.toCurrencyCode}";
print("curId $curId");
    String uri =
        "${Constants.apiWUrl2}convert?q=$curId&compact=y&apiKey=${Constants.apiWApi2}";
        print(uri);
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});

    var body = json.decode(response.body);
print(body);
    setState(() {
      result = (double.parse(valueController.text) *
              body[curId]["val"])
          .toStringAsFixed(3);
    });
    print(result);
    return "Success";
  }

  @override
  void initState() {
    super.initState();

    loadCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    void _fromCurrencyDialog() {
      Get.defaultDialog(
          title: "اختر الدولة",
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: size.width,
              height: size.height / 2,
              child: ListView.builder(
                  itemCount: currencies.length,
                  itemBuilder: (context, index) {
                    fromCurrency = currencies[index];
                    fromCurrencyname = currenciesnames[index];

                    return InkWell(
                      onTap: () {
                        fromCurrency = currencies[index];
                        fromCurrencyname = currenciesnames[index];

                        controller.updateFromCurrency(
                            fromCurrency, fromCurrencyname);
                        //   print(fromCurrency);

                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              fromCurrency,
                              textAlign: TextAlign.start,
                            ),
                            Flexible(
                              child: Text(
                                fromCurrencyname,
                                textAlign: TextAlign.end,style: TextStyle(fontSize: 14),
                              ),
                            ),

                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ]),
          radius: 10.0);
    }

    void _toCurrencyDialog() {
      Get.defaultDialog(
          title: "اختر الدولة",
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: size.width,
              height: size.height / 2,
              child: ListView.builder(
                  itemCount: currencies.length,
                  itemBuilder: (context, index) {
                    toCurrency = currencies[index];
                    toCurrencyname = currenciesnames[index];

                    return InkWell(
                      onTap: () {
                        toCurrency = currencies[index];
                        toCurrencyname = currenciesnames[index];

                        controller.updateToCurrency(toCurrency, toCurrencyname);
                        print(toCurrency);

                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              toCurrency,
                              textAlign: TextAlign.start,
                            ),
                            Flexible(
                              child: Text(
                                toCurrencyname,
                                textAlign: TextAlign.end,style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ]),
          radius: 10.0);
    }

//https://sp-today.com/fcur/fcur2.json
//https://sp-today.com/app_api/cur_damascus.json
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text("تحويل العملات"),
      ),
      body: currencies == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: size.height,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    GetBuilder<CurrencyController>(builder: (_) {
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    "إلى",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _toCurrencyDialog(),
                                  child: Container(
                                    height: 100,
                                    width: size.width * 0.33,
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            controller.toCurrencyName,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            controller.toCurrencyCode,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Icon(
                                    Icons.arrow_right_alt,
                                    size: 30,
                                    color: btnYellow,
                                  ),
                                ),
                                Container(
                                  height: 10,
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Icon(
                                      Icons.arrow_right_alt,
                                      size: 30,
                                      color: btnYellow,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    "من",
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _fromCurrencyDialog(),
                                  child: Container(
                                    height: 100,
                                    width: size.width * 0.33,
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            controller.fromCurrencyName,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            controller.fromCurrencyCode,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: RButton(
                            txt: "تحويل",
                            press: () => convert(),
                            btnColor: btnBlue,
                            width: 0.32,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                "القيمة",
                                textAlign: TextAlign.end,
                              ),
                            ),
                            RTextBox(
                                width: 0.44,
                                type: TextInputType.number,
                                controller: valueController,
                                ispass: false,
                                hinttxt: "أدخل القيمة هنا")
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 50),
                        width: size.width * 0.5,
                        alignment: Alignment.center,
                        child: result == null
                            ? Text("-",textAlign: TextAlign.center,)
                            : Text(
                                "$result (${controller.toCurrencyCode})",textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  convert() {
    if (controller.fromCurrencyCode == "المراد تحويل منها") {
      Constants.rSnackbarError("تنبيه", "اختر العملة المراد التحويل منها");
     
    } else if (controller.toCurrencyCode == "المراد تحويل إليها") {
      Constants.rSnackbarError("تنبيه", "اختر العملة المراد التحويل إليها");

    } else if (valueController.text.isEmpty) {

            Constants.rSnackbarError("تنبيه", "حدد القيمة المراد تحويلها");

    } else {
      getConversion();
    }
  }
}
