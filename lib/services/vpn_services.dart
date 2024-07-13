import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'dart:async';
import 'package:my_app/models/vpn_country.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VpnService extends ChangeNotifier {
  late OpenVPN engine;
  VpnStatus? status;
  String? stage;
  bool granted = false;
  late Future<String> configFuture;
  VpnCountry? currentCountry = VpnCountry(country: 'Default');
  VpnService() {
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        status = data;
        notifyListeners();
      },
      onVpnStageChanged: (data, raw) {
        stage = raw;
        notifyListeners();
      },
    );
    configFuture = loadConfig();
    getObject();
    engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
          "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "VPN by Nizwar",
      lastStage: (stage) {
        this.stage = stage.name;
        notifyListeners();
      },
      lastStatus: (status) {
        this.status = status;
        notifyListeners();
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
    notifyListeners();
  }

  Future<void> removeObject() async {
    await SecureStorageService.removeObject('vpnCountry');
    currentCountry = VpnCountry(country: 'Default');
    notifyListeners();
  }

  Future<void> saveTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentTime', DateTime.now().millisecondsSinceEpoch);
    print('gg');
    print(DateTime.now().millisecondsSinceEpoch);
  }

  Future<int> getTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentTime = prefs.getInt('currentTime') ?? 0;
    //print(currentTime);
    return currentTime;
  }
}

const String defaultVpnUsername = "";
const String defaultVpnPassword = "";
