import 'dart:async';

import 'package:bildirt/src/core/network/bildirt_api_service.dart';
import 'package:flutter/material.dart';

class NotificationDetailViewModel extends ChangeNotifier {
  late StreamController<bool> _isLoadingController;
  var result = <dynamic, dynamic>{};
  NotificationDetailViewModel() {
    _isLoadingController = StreamController.broadcast();
    _isLoadingController.add(false);
    notifyListeners();
  }
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  getNotificationDetail(String id) async {
    _isLoadingController.add(true);
    var newResult = await BildirtApiService.getPushDetail(id);
    result = newResult;

    _isLoadingController.add(false);
    notifyListeners();
  }
}
