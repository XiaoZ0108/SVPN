import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class VpnService extends ChangeNotifier {
  late OpenVPN engine;
  VpnStatus? status;
  String? stage;
  bool granted = false;
  late Future<String> configFuture;

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
    String config = await configFuture; // Wait for the config to load
    engine.connect(
      config,
      "USA",
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
}

const String defaultVpnUsername = "";
const String defaultVpnPassword = "";
