// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:io';
// import 'dart:async';
// import 'package:my_app/models/vpn_country.dart';
// import 'package:openvpn_flutter/openvpn_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:my_app/services/storage_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class VpnService extends ChangeNotifier {
//   late OpenVPN engine;
//   VpnStatus? status;
//   String? stage;
//   bool granted = false;
//   late Future<String> configFuture;
//   VpnCountry? currentCountry = VpnCountry(country: 'Default');
//   VpnService() {
//     engine = OpenVPN(
//       onVpnStatusChanged: (data) {
//         status = data;
//         notifyListeners();
//       },
//       onVpnStageChanged: (data, raw) {
//         stage = raw;
//         notifyListeners();
//       },
//     );
//     configFuture = loadConfig();
//     getObject();
//     engine.initialize(
//       groupIdentifier: "group.com.laskarmedia.vpn",
//       providerBundleIdentifier:
//           "id.laskarmedia.openvpnFlutterExample.VPNExtension",
//       localizedDescription: "VPN by Nizwar",
//       lastStage: (stage) {
//         this.stage = stage.name;
//         notifyListeners();
//       },
//       lastStatus: (status) {
//         this.status = status;
//         notifyListeners();
//       },
//     );
//   }

//   Future<void> initPlatformState() async {
//     String config;
//     String country;
//     if (currentCountry!.country == 'Default') {
//       //default connection
//       config = await configFuture; // Wait for the config to load
//       country = "Default";
//     } else {
//       //custom connection
//       config = currentCountry!.config!;
//       country = currentCountry!.country;
//     }

//     engine.connect(
//       config,
//       country,
//       username: defaultVpnUsername,
//       password: defaultVpnPassword,
//       certIsRequired: true,
//     );
//   }

//   Future<String> loadConfig() async {
//     return await rootBundle.loadString('assets/vpn/try.ovpn');
//   }

//   void disconnect() {
//     engine.disconnect();
//     status = VpnStatus.empty();
//   }

//   Future<void> requestPermissionAndroid() async {
//     if (Platform.isAndroid) {
//       granted = await engine.requestPermissionAndroid();
//       notifyListeners();
//     }
//   }

//   String capitalizeFirstLetter(String s) {
//     if (s.isEmpty) return s;
//     return s[0].toUpperCase() + s.substring(1);
//   }

//   final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//   void navigateTo(String routeName, {Map<String, dynamic>? arguments}) {
//     navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
//     notifyListeners();
//   }

//   void goBack() {
//     navigatorKey.currentState?.pop();
//     notifyListeners();
//   }

//   void setCountry(VpnCountry vc) async {
//     currentCountry = vc;
//     await saveObject(vc);
//     notifyListeners();
//   }

//   Future<void> saveObject(VpnCountry object) async {
//     await SecureStorageService.saveObject(object, 'vpnCountry');
//     notifyListeners();
//   }

//   Future<void> getObject() async {
//     VpnCountry? country = await SecureStorageService.getObject(
//         'vpnCountry', (json) => VpnCountry.fromJson(json));
//     if (country != null) {
//       currentCountry = country;
//       notifyListeners();
//     }
//     notifyListeners();
//   }

//   Future<void> removeObject() async {
//     await SecureStorageService.removeObject('vpnCountry');
//     currentCountry = VpnCountry(country: 'Default');
//     notifyListeners();
//   }

//   Future<void> saveTime() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('currentTime', DateTime.now().millisecondsSinceEpoch);
//     print('gg');
//     print(DateTime.now().millisecondsSinceEpoch);
//   }

//   Future<int> getTime() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int currentTime = prefs.getInt('currentTime') ?? 0;
//     //print(currentTime);
//     return currentTime;
//   }
// }

// const String defaultVpnUsername = "";
// const String defaultVpnPassword = "";
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'dart:async';
import 'package:my_app/models/vpn_country.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VpnService extends ChangeNotifier {
  static final OpenVPN engine = OpenVPN(
    onVpnStatusChanged: (data) {
      _instance.status = data;
      _instance.notifyListeners();
    },
    onVpnStageChanged: (data, raw) {
      _instance.stage = raw;
      _instance.notifyListeners();
    },
  );

  VpnStatus? status;
  String? stage;
  bool granted = false;
  late Future<String> configFuture;
  VpnCountry? currentCountry = VpnCountry(country: 'Default');

  // Private constructor for singleton pattern
  VpnService._private() {
    configFuture = loadConfig();
    getObject();
  }

  // Singleton instance variable
  static final VpnService _instance = VpnService._private();

  // Getter for singleton instance
  factory VpnService() {
    return _instance;
  }

  // Method to initialize the engine, separate from the constructor to avoid recursion
  static void initializeEngine() {
    engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
          "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "VPN by Nizwar",
      lastStage: (stage) {
        _instance.stage = stage.name;
        _instance.notifyListeners();
      },
      lastStatus: (status) {
        _instance.status = status;
        _instance.notifyListeners();
      },
    );
  }

  Future<void> initPlatformState() async {
    String config;
    String country;
    if (currentCountry!.country == 'Default') {
      //default connection
      config = await configFuture; // Wait for the config to load
      country = "Default";
    } else {
      //custom connection
      config = currentCountry!.config!;
      country = currentCountry!.country;
    }

    engine.connect(
      config,
      country,
      username: defaultVpnUsername,
      password: defaultVpnPassword,
      certIsRequired: true,
    );
  }

  Future<String> loadConfig() async {
    return await rootBundle.loadString('assets/vpn/try.ovpn');
  }

  static void disconnect2() {
    engine.disconnect();
  }

  void disconnect() {
    engine.disconnect();
    status = VpnStatus.empty();
  }

  Future<void> requestPermissionAndroid() async {
    if (Platform.isAndroid) {
      granted = await engine.requestPermissionAndroid();
      notifyListeners();
    }
  }

  String capitalizeFirstLetter(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  void navigateTo(String routeName, {Map<String, dynamic>? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
    notifyListeners();
  }

  void goBack() {
    navigatorKey.currentState?.pop();
    notifyListeners();
  }

  void setCountry(VpnCountry vc) async {
    currentCountry = vc;
    await saveObject(vc);
    notifyListeners();
  }

  Future<void> saveObject(VpnCountry object) async {
    await SecureStorageService.saveObject(object, 'vpnCountry');
    notifyListeners();
  }

  Future<void> getObject() async {
    VpnCountry? country = await SecureStorageService.getObject(
        'vpnCountry', (json) => VpnCountry.fromJson(json));
    if (country != null) {
      currentCountry = country;
      notifyListeners();
    }
  }

  Future<void> removeObject() async {
    await SecureStorageService.removeObject('vpnCountry');
    currentCountry = VpnCountry(country: 'Default');
    notifyListeners();
  }

  static Future<void> saveTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentTime', DateTime.now().millisecondsSinceEpoch);
  }

  Future<int> getTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentTime = prefs.getInt('currentTime') ?? 0;
    return currentTime;
  }

  Future<void> setAllowTime(int time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('allowTime', time);
  }

  Future<int> getAllowTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int allowTime = prefs.getInt('allowTime') ?? 0;
    return allowTime;
  }
}

const String defaultVpnUsername = "";
const String defaultVpnPassword = "";
