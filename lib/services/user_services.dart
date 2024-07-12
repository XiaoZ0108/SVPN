import 'package:flutter/material.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/services/storage_service.dart';

class UserService extends ChangeNotifier {
  UserInfo? currentUserinfo;

  UserService() {
    _init();
  }
  Future<void> _init() async {
    await getObject();
  }

  void setUser(UserInfo ui) async {
    currentUserinfo = ui;
    await saveObject(ui);
    notifyListeners();
  }

  Future<void> saveObject(UserInfo object) async {
    await SecureStorageService.saveObject(object, 'userInfo');
    notifyListeners();
  }

  Future<void> getObject() async {
    UserInfo? uInfo = await SecureStorageService.getObject(
        'userInfo', (json) => UserInfo.fromJson(json));
    if (uInfo != null) {
      currentUserinfo = uInfo;
      notifyListeners();
    }
  }
}
