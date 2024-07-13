import 'package:flutter/material.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends ChangeNotifier {
  UserInfo? currentUserinfo;
  bool login = false;
  String token = '';
  String time = '';
  UserService() {
    _init();
  }
  Future<void> _init() async {
    await getObject();
    await getToken();
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

  Future<void> removeObject() async {
    await SecureStorageService.removeObject('userInfo');
    currentUserinfo = null;
    notifyListeners();
  }

  Future<void> saveLoginStatus(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('login', status);
    login = status;
    notifyListeners();
  }

  Future<void> saveToken(String newtoken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', newtoken);
    token = newtoken;
    notifyListeners();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String newtoken = prefs.getString('token') ?? '';
    token = newtoken;
    return newtoken;
  }
}
