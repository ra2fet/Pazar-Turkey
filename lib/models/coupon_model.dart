class CouponModel {

  final String coupon_code,coupon_discount,type,end_date;

  CouponModel({this.coupon_code, this.coupon_discount, this.type, this.end_date});

    factory CouponModel.fromJson(Map<String, dynamic> json) => 
    CouponModel(
        coupon_code: json["coupon_code"],
        coupon_discount: json["coupon_discount"],
        type: json["type"],
        end_date: json["end_date"],
    );
 
}