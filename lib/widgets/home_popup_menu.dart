import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pazar_app/pages/favorite.dart';
import 'package:pazar_app/pages/notifications.dart';
import 'package:pazar_app/pages/profile.dart';
import 'package:pazar_app/utils/constants.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePopupMenu extends StatelessWidget {
  const HomePopupMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _selected;

    return Container(
      child: PopupMenuButton(
        padding: EdgeInsets.symmetric(horizontal: 10),
        onSelected: (String value) async {
          _selected = value;
                     final SharedPreferences prefs = await SharedPreferences.getInstance();

                              

          if (_selected == "Value1")
            prefs.containsKey('fullname')? Get.to(()=>Profile()): Constants.rSnackbarError("رسالة خطأ","لا يمكن الدخول لهذا القسم بدون تسجيل الدخول");

          else if (_selected == "Value2")
            prefs.containsKey('fullname')?Get.to(()=>Favorite()): Constants.rSnackbarError("رسالة خطأ","لا يمكن الدخول لهذا القسم بدون تسجيل الدخول");
          else if (_selected == "Value3")
             Get.to(()=>Notifications());
          else if (_selected == "Value4")
            Get.defaultDialog(
                title: "حول التطبيق",
                content: Column(
                  children: [
                    Text(
                      "تطبيق بازار تركيا",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SvgPicture.asset(
                      "assets/images/logo.svg",
                      width: 100,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "الإصدار 1.0",
                      textAlign: TextAlign.center,
                    )
                  ],
                ));
          else if (_selected == "Value5") {
            final RenderBox renderBox = context.findRenderObject();
            Share.share('check out my website www.properties.pazar-tr.com',
                sharePositionOrigin:
                    renderBox.localToGlobal(Offset.zero) & renderBox.size);
          } else if (_selected == "Value6") {
            RateMyApp rateMyApp = RateMyApp(
              preferencesPrefix: 'rateMyApp_',
              minDays: 7,
              minLaunches: 10,
              remindDays: 7,
              remindLaunches: 10,
              googlePlayIdentifier: null, // 'com.rafat.example',
              appStoreIdentifier: null, //'1491556149',
            );

            rateMyApp.showStarRateDialog(
              context,
              title: 'تقييم التطبيق', // The dialog title.
              message:
                  'إذا أعجبك التطبيق؟ خذ بعض من الوقت لتقييمه', // The dialog message.

              // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
              actionsBuilder: (context, stars) {
                // Triggered when the user updates the star rating.
                return [
                  // Return a list of actions (that will be shown at the bottom of the dialog).

                  Padding(
                    padding: const EdgeInsets.only(right: 120.0),
                    child: TextButton(
                      child: Text('موافق'),
                      onPressed: () async {
                        print('شكرا لـ' +
                            (stars == null ? '0' : stars.round().toString()) +
                            ' star(s) !');
                        // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                        // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                        await rateMyApp
                            .callEvent(RateMyAppEventType.rateButtonPressed);
                        Navigator.pop<RateMyAppDialogButton>(
                            context, RateMyAppDialogButton.rate);
                      },
                    ),
                  ),
                ];
              },
              ignoreNativeDialog: Platform
                  .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
              dialogStyle: DialogStyle(
                // Custom dialog styles.
                titleAlign: TextAlign.center,
                messageAlign: TextAlign.center,
                messagePadding: EdgeInsets.only(bottom: 20),
              ),
              starRatingOptions:
                  StarRatingOptions(), // Custom star bar rating options.
              onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
                  .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
            );
          }

          print(_selected);
        },
        offset: Offset(-15, 33),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'Value1',
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'الملف الشخصي',
                  textAlign: TextAlign.end,
                )),
          ),
          const PopupMenuItem<String>(
            value: 'Value2',
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'المفضلات',
                  textAlign: TextAlign.end,
                )),
          ),
          const PopupMenuItem<String>(
            value: 'Value3',
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'الإشعارات',
                  textAlign: TextAlign.end,
                )),
          ),
          const PopupMenuItem<String>(
            value: 'Value4',
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'عن التطبيق',
                  textAlign: TextAlign.end,
                )),
          ),
          const PopupMenuItem<String>(
            value: 'Value5',
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'مشاركة التطبيق',
                  textAlign: TextAlign.end,
                )),
          ),
          const PopupMenuItem<String>(
            value: 'Value6',
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'تقييم التطبيق',
                  textAlign: TextAlign.end,
                )),
          ),
        ],
      ),
    );
  }
}
               
     
               
