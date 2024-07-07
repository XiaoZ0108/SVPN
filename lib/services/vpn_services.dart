import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/models/vpn_country.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VpnService extends ChangeNotifier {
  late OpenVPN engine;
  VpnStatus? status;
  String? stage;
  bool granted = false;
  late Future<String> configFuture;
  VpnCountry? currentCountry;

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
    if (currentCountry == null) {
      //default connection
      config = await configFuture; // Wait for the config to load
      country = "Singapore";
    } else {
      //custom connection
      config = currentCountry!.config ?? await configFuture;
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

  void setCountry(VpnCountry vc) {
    currentCountry = vc;
    notifyListeners();
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  void navigateTo(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
    notifyListeners();
  }

  void goBack() {
    navigatorKey.currentState?.pop();
    notifyListeners();
  }

  static Future<String> fetchIpAddress() async {
    try {
      var response = await http.get(Uri.parse('https://ipv4.seeip.org/jsonip'));
      if (response.statusCode == 200) {
        String res = response.body;
        Map<String, dynamic> json = jsonDecode(res);
        return json['ip'];
      } else {
        return "N/A";
      }
    } catch (e) {
      return "N/A";
    }
  }
}

const String defaultVpnUsername = "";
const String defaultVpnPassword = "";
