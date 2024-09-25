import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:luvpark_get/auth/authentication.dart';
import 'package:luvpark_get/custom_widgets/variables.dart';
import 'package:luvpark_get/http/http_request.dart';
import 'package:luvpark_get/sqlite/pa_message_model.dart';
import 'package:luvpark_get/sqlite/pa_message_table.dart';
import 'package:luvpark_get/sqlite/reserve_notification_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tzz;

import 'http/api_keys.dart';
import 'routes/routes.dart';
import 'sqlite/notification_model.dart';

class NotificationController {
  static ReceivedAction? initialAction;

  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
      null, //'resource://drawable/res_app_icon',//
      [
        NotificationChannel(
          channelKey: 'alerts',
          channelName: 'Alerts',
          channelDescription: 'Notification tests as alerts',
          playSound: true,
          onlyAlertOnce: true,
          groupAlertBehavior: GroupAlertBehavior.Children,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: Colors.deepPurple,
          ledColor: Colors.deepPurple,
        ),
      ],
      debug: true,
    );

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  static ReceivePort? receivePort;
  static Future<void> initializeIsolateReceivePort() async {
    receivePort = ReceivePort('Notification action port in main isolate')
      ..listen(
          (silentData) => onActionReceivedImplementationMethod(silentData));

    // This initialization only happens on the main isolate
    IsolateNameServer.registerPortWithName(
      receivePort!.sendPort,
      'notification_action_port',
    );
  }

  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction) {
      await executeLongTaskInBackground();
    } else {
      if (receivePort == null) {
        SendPort? sendPort =
            IsolateNameServer.lookupPortByName('notification_action_port');

        if (sendPort != null) {
          sendPort.send(receivedAction);
          return;
        }
      }

      return onActionReceivedImplementationMethod(receivedAction);
    }
  }

  static Future<void> executeLongTaskInBackground() async {
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    print(re.body);
  }

  //Parking notification
  static Future<void> parkingNotif(int id, int geoShareId, String? title,
      String? body, String? payload) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'alerts',
        title: title!,
        body: body!,
        wakeUpScreen: true,
        autoDismissible: true,
        notificationLayout: NotificationLayout.BigPicture,
        payload: {'notificationId': payload!, "geo_share_id": "$geoShareId"},
      ),
    );
  }
  //Share token notif

  static Future<void> shareTokenNotification(int id, int geoShareId,
      String? title, String? body, String? payload) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'alerts',
        title: title!,
        body: body!,
        wakeUpScreen: true,
        autoDismissible: true,
        notificationLayout: NotificationLayout.BigPicture,
        payload: {'notificationId': payload!, "geo_share_id": "$geoShareId"},
      ),
    );
  }

//to notify users about  reported damage
  static Future<void> createInformationMessage(int id, int geoShareId,
      String? title, String? body, String? payload) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'alerts',
          title: title!,
          body: body!,
          wakeUpScreen: true,
          autoDismissible: false,
          notificationLayout: NotificationLayout.BigPicture,
          payload: {'notificationId': payload!},
        ),
        actionButtons: [
          NotificationActionButton(key: 'MESSAGE', label: 'View Message'),
        ]);
  }

  // MAKE A FOREGROUND NOTIFICATION
  static Future<void> createForegroundNotif(int id, int geoShareId,
      String? title, String? body, String? payload) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'alerts',
        title: title!,
        body: body!,
        wakeUpScreen: true,
        autoDismissible: false,
        notificationLayout: NotificationLayout.BigPicture,
        payload: {
          'notificationId': payload!,
          "geo_share_id": "$geoShareId",
        },
      ),
      actionButtons: [
        NotificationActionButton(key: 'VIEW_SHARING', label: 'View Sharing'),
      ],
    );
  }

  static Future<void> scheduleNewNotification(int id, String title, String body,
      String? dateSched, String payLoad) async {
    try {
      tz.initializeTimeZones();
      // Check if timezone database is initialized, if not initialize it

      final tzz.TZDateTime scheduledTime = tzz.TZDateTime.from(
        DateTime.parse(dateSched!),
        tzz.getLocation('Asia/Manila'),
      ).subtract(const Duration(minutes: 10));

      bool isAllowed = await AwesomeNotifications().isNotificationAllowed();

      if (!isAllowed) {
        return;
      }

      await myNotifyScheduleInHours(
        id: id,
        title: title,
        msg: body,
        hoursFromNow: scheduledTime,
        repeatNotif: false,
        payLoad: payLoad,
      );
    } catch (e) {}
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }

  static Future<void> cancelNotificationsById(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  static Future<void> onActionReceivedImplementationMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.payload!["notificationId"] == "parking") {
      Get.toNamed(Routes.parking, arguments: "N");
    }
    if (receivedAction.buttonKeyPressed.toLowerCase() == "message") {
      Get.toNamed(Routes.message);
    }
  }

  static Future<void> myNotifyScheduleInHours({
    required tzz.TZDateTime hoursFromNow,
    required String title,
    required String msg,
    required String payLoad,
    required int id,
    bool repeatNotif = false,
  }) async {
    await AwesomeNotifications().createNotification(
      schedule: NotificationCalendar(
        weekday: null,
        hour: hoursFromNow.hour,
        minute: hoursFromNow.minute,
        second: 0,
        repeats: repeatNotif,
        allowWhileIdle: true,
      ),
      content: NotificationContent(
        id: id,
        channelKey: 'alerts',
        title: title,
        body: msg,
        payload: {
          'notificationId': payLoad,
        },
      ),
    );
  }
}

Future<void> updateLocation(LatLng position) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var geoConId = prefs.getString('geo_connect_id');

  if (geoConId == null) return;
  var jsonParam = {
    "geo_connect_id": geoConId,
    "latitude": position.latitude,
    "longitude": position.longitude
  };

  HttpRequest(api: ApiKeys.gApiLuvParkPutUpdateUsersLoc, parameters: jsonParam)
      .put()
      .then((returnData) async {
    if (returnData == "No Internet") {
      return;
    }
    if (returnData == null) {
      return;
    }
    if (returnData["success"] == "Y") {
      return;
    }
  });
}

Future<void> getParkingTrans(int ctr) async {
  var akongId = await Authentication().getUserId();

  HttpRequest(
    api:
        "${ApiKeys.gApiSubFolderGetActiveParking}?luvpay_id=${akongId.toString()}",
  ).get().then((notificationData) async {
    print("notificationData $notificationData");
    if (notificationData == "No Internet") {
      return;
    }
    if (notificationData["items"].isEmpty) {
      NotificationDatabase.instance.deleteAll();
      AwesomeNotifications().cancelAllSchedules();
      return;
    }
    if (notificationData != null && notificationData["items"] != null) {
      List itemData = notificationData["items"].where((element) {
        DateTime timeOut = DateTime.parse(element["dt_out"].toString());
        return DateTime.now().isBefore(timeOut);
      }).toList();
      for (var dataRow in itemData) {
        int resIdInatay = int.parse(dataRow["mreservation_id"]?.toString() ??
            dataRow["reservation_id"].toString());

        var returnData = await NotificationDatabase.instance
            .readNotificationByResId(resIdInatay);
        DateTime pdt = DateTime.parse(dataRow["dt_in"].toString());
        DateTime targetDate =
            DateTime(pdt.year, pdt.month, pdt.day, pdt.hour, pdt.minute);

        if (!Variables.withinOneHourRange(targetDate)) continue;
        var resData = {
          NotificationDataFields.reservedId: resIdInatay,
          NotificationDataFields.userId: int.parse(akongId.toString()),
          NotificationDataFields.mTicketId: dataRow["mticket_id"] ?? 0,
          NotificationDataFields.mreservedId: dataRow["mreservation_id"] ?? 0,
          NotificationDataFields.notifDate: dataRow["dt_out"].toString(),
          NotificationDataFields.dtIn: dataRow["dt_in"].toString(),
        };

        if (returnData == null) {
          NotificationController.parkingNotif(
            int.parse(dataRow["reservation_id"].toString()),
            0,
            'Check In',
            "Great! You have successfully checked in to ${dataRow["park_area_name"]} parking area.",
            "parking",
          );
          NotificationController.scheduleNewNotification(
            int.parse(dataRow["reservation_id"].toString()),
            "luvpark",
            "Your Parking at ${dataRow["park_area_name"]} is about to expire.",
            dataRow["dt_out"].toString(),
            "parking",
          );
          NotificationController.scheduleNewNotification(
            int.parse(dataRow["reservation_id"].toString()) + 10,
            "luvpark",
            "Your parking at ${dataRow["park_area_name"]} will be closing soon.",
            dataRow["end_time"].toString(),
            "",
          );
          await NotificationDatabase.instance.insertUpdate(resData);
        } else {
          if (dataRow["dt_in"].toString().toLowerCase() !=
              returnData["dt_in"].toString().toLowerCase()) {
            NotificationController.cancelNotificationsById(
                dataRow["mreservation_id"]);
            NotificationController.parkingNotif(
              int.parse(dataRow["mreservation_id"].toString()),
              0,
              'Parking Auto Extend',
              "You've paid ${dataRow["amount"]} for your parking. Please check your balance.",
              "parking",
            );
            NotificationController.scheduleNewNotification(
              int.parse(dataRow["mreservation_id"].toString()),
              "luvpark",
              "Your Parking at ${dataRow["park_area_name"]} is about to expire.",
              dataRow["dt_out"].toString(),
              "parking",
            );
            await NotificationDatabase.instance.insertUpdate(resData);
          }
        }
      }
    }
  });
}

//GET PARKING QUE

Future<void> getParkingQueue() async {
  var akongId = await Authentication().getUserId();

  HttpRequest(
    api: "${ApiKeys.gApiLuvParkResQueue}?user_id=${akongId.toString()}",
  ).get().then((queueData) async {
    if (queueData == "No Internet") {
      return;
    }
    // if (queueData != null) {}
  });
}

//GET MEssage from PA
Future<void> getMessNotif() async {
  var akongId = await Authentication().getUserId();

  HttpRequest(
    api: "${ApiKeys.gApiLuvParkMessageNotif}?user_id=$akongId",
  ).get().then((messageData) async {
    if (messageData == "No Internet" || messageData == null) {
      return;
    }
    if (messageData["items"].isNotEmpty) {
      for (dynamic dataRow in messageData["items"]) {
        PaMessageDatabase.instance
            .readNotificationById(dataRow["push_msg_id"])
            .then((objData) {
          if (objData == null) {
            Object json = {
              PaMessageDataFields.pushMsgId: dataRow["push_msg_id"],
              PaMessageDataFields.userId: dataRow["user_id"],
              PaMessageDataFields.message: dataRow["message"],
              PaMessageDataFields.createdDate: dataRow["created_on"],
              PaMessageDataFields.status: dataRow["push_status"],
              PaMessageDataFields.runOn: dataRow["run_on"],
              PaMessageDataFields.isRead: "N",
            };

            PaMessageDatabase.instance.insertUpdate(json).then((value) {
              Variables.tts.speak(dataRow["message"]);
              NotificationController.createInformationMessage(
                  dataRow["push_msg_id"],
                  0,
                  'Attention',
                  "You have new message from your parking attendant",
                  "message");
            });
          }
        });
      }
    }
  });
}

List<dynamic> getLastColumn(List<Map<String, dynamic>> list) {
  List<dynamic> lastColumn = [];

  for (var map in list) {
    // Get all keys of the map
    List<String> keys = map.keys.toList();

    // Get the last key (last column)
    String lastKey = keys.last;

    // Get the value corresponding to the last key
    dynamic lastValue = map[lastKey];

    lastColumn.add(lastValue);
  }

  return lastColumn;
}
