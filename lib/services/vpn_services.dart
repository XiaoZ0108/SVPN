import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:my_app/models/vpn_country.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

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
      country = "Australia";
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
  }
}

const String defaultVpnUsername = "";
const String defaultVpnPassword = "";
