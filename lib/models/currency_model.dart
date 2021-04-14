// To parse this JSON data, do
//
//     final currencyModel = currencyModelFromJson(jsonString);

import 'dart:convert';

CurrenyModel currencyModelFromJson(String str) => CurrenyModel.fromJson(json.decode(str));

String currencyModelToJson(CurrenyModel data) => json.encode(data.toJson());

class CurrenyModel {
    CurrenyModel({
        this.rates,
        this.base,
        this.date,
    });

    Map<String, double> rates;
    String base;
    DateTime date;

    factory CurrenyModel.fromJson(Map<String, dynamic> json) => CurrenyModel(
        rates: Map.from(json["rates"]).map((k, v) => MapEntry<String, double>(k, v.toDouble())),
        base: json["base"],
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "base": base,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    };
}

class Currency2Model {

  final countryName;

  Currency2Model({this.countryName});

factory Currency2Model.fromJson(Map<String, dynamic> json) => Currency2Model(
      countryName: json["countryName"],
);
    
}