import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:openvpn_flutter/openvpn_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late OpenVPN engine;
  VpnStatus? status;
  String? stage;
  bool _granted = false;
  late Future<String> configFuture;

  @override
  void initState() {
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        setState(() {
          status = data;
        });
      },
      onVpnStageChanged: (data, raw) {
        setState(() {
          stage = raw;
        });
      },
    );
    configFuture = loadConfig();

    engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
          "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "VPN by Nizwar",
      lastStage: (stage) {
        setState(() {
          this.stage = stage.name;
        });
      },
      lastStatus: (status) {
        setState(() {
          this.status = status;
        });
      },
    );
    super.initState();
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
    if (!mounted) return;
  }

  Future<String> loadConfig() async {
    return await rootBundle.loadString('assets/vpn/try.ovpn');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(stage?.toString() ?? VPNStage.disconnected.toString()),
              Text(status?.toJson().toString() ?? ""),
              TextButton(
                child: const Text("Start"),
                onPressed: () {
                  initPlatformState();
                },
              ),
              TextButton(
                child: const Text("STOP"),
                onPressed: () {
                  engine.disconnect();
                },
              ),
              if (Platform.isAndroid)
                TextButton(
                  child: Text(_granted ? "Granted" : "Request Permission"),
                  onPressed: () {
                    engine.requestPermissionAndroid().then((value) {
                      setState(() {
                        _granted = value;
                      });
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

const String defaultVpnUsername = "";
const String defaultVpnPassword = "";
