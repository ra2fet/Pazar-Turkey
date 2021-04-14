import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar_app/pages/details/articlesdetail.dart';
import 'package:pazar_app/pages/details/realestate_details.dart';
import 'package:pazar_app/pages/details/servicedetail.dart';
import 'package:pazar_app/pages/details/tourism_places_details.dart';
import 'package:pazar_app/pages/details/turkeyeconomicdetail.dart';
import 'package:pazar_app/providers/message/message.dart';
import 'package:pazar_app/utils/app_colors.dart';
import 'package:pazar_app/widgets/rbutton.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsProvider {
  void notitficationPermission(FirebaseMessaging messaging) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}

void initMessaging(fltNotification) {
  FirebaseMessaging.instance.subscribeToTopic("all");
  var androiInit = AndroidInitializationSettings('ic_launcher');
  //var androiInit = new AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosInit = IOSInitializationSettings();

  var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

  fltNotification = FlutterLocalNotificationsPlugin();

  fltNotification.initialize(initSetting);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('1Message data back: ${message.data}');

    RemoteNotification notification = message.notification;

    //    showNotification(fltNotification);
    _showDialog(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('2Message data back: ${message.data}');

    //  Get.toNamed('/message',arguments: MessageArguments(message, true));
    RemoteNotification notification = message.notification;

    _showDialog(message);
  });
}

void showNotification(fltNotification) async {
  var androidDetails =
      AndroidNotificationDetails('1', 'channelName', 'channel Description');

  var iosDetails = IOSNotificationDetails();

  var generalNotificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);

  await fltNotification.show(0, 'title', 'body', generalNotificationDetails,
      payload: 'Notification');
}

void _showDialog(RemoteMessage message) {
  var status = message.data["status"];
  var itemid = message.data["itemid"];

  print("here is $status $itemid");

  RemoteNotification notification = message.notification;

  Get.defaultDialog(
      title: notification.title,
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(notification.body),
            ),
            SizedBox(height: 50),
            Center(
                child: RButton(
              txt: "موافق",
              press: () => checkNoti(status, itemid),
              width: 0.5,
              btnColor: btnBlue,
            ))
          ],
        ),
      ));
}

void checkNoti(status, itemid) {
  if (status == "realstate") {
    print("go to realstate $itemid");

    Get.back();
    Get.to(() => RealEstateDetails(
          id: int.parse(itemid),
        ));
  } else if (status == "servicetype") {
    print("go to servicetype");

    Get.back();
    Get.to(() => ServiceDetail(
          id: int.parse(itemid),ismenu: true,
        ));
  }else if (status == "service") {
    print("go to service");

    Get.back();
    Get.to(() => ServiceDetail(
          id: int.parse(itemid),
        ));
  }  else if (status == "article") {
    print("go to article");
    Get.back();
    Get.to(() => ArticlesDetail(
          id: int.parse(itemid),
        ));
  } else if (status == "toursim") {
    print("go to toursim");
    Get.back();
    Get.to(() => TourismPlacesDetails(
          id: int.parse(itemid),
        ));
  } else if (status == "turkeyeconomic") {
    print("go to turkeyeconomic");
    Get.back();
    Get.to(() => TurkeyEconomicDetail(
          id: int.parse(itemid),
        ));
  } else {
    print("show notification only");
    Get.back();
  }
}
