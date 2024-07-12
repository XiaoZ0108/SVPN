import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveObject<T>(T object, String key) async {
    String jsonStr = json.encode((object as dynamic).toJson());
    await _storage.write(key: key, value: jsonStr);
  }

  static Future<T?> getObject<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    String? jsonStr = await _storage.read(key: key);
    if (jsonStr != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonStr);
      return fromJson(jsonMap);
    }
    return null;
  }
}
