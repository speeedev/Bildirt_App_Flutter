import 'package:bildirt/src/core/constants/image_constants.dart';
import 'package:bildirt/src/core/network/bildirt_api_service.dart';
import 'package:flutter/material.dart';

class NewNotificationViewModel extends ChangeNotifier {
  Future sendPushNotification(String title, String body, String url,
      String image, String time, int intime, ttl) async {
    var result = await BildirtApiService.sendPushNotification({
      'title': title,
      'body': body,
      'url': url,
      'icon': APP_ICON,
      'image': image,
      'time': time,
      'intime': intime,
      'ttl': ttl,
    });

    if (result == true) {
      return true;
    } else {
      return false;
    }
  }
}
