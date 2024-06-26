import 'package:flutter/material.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:provider/provider.dart';
import 'package:my_app/screens/home.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late VpnService vpnService;

  @override
  void initState() {
    vpnService = VpnService();
    super.initState();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider(
  //     create: (_) => vpnService,
  //     child: MaterialApp(
  //       home: Scaffold(
  //         appBar: AppBar(
  //           title: const Text('Plugin example app'),
  //         ),
  //         body: Center(
  //           child: Consumer<VpnService>(
  //             builder: (context, vpnService, child) {
  //               return Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(vpnService.stage?.toString() ??
  //                       VPNStage.disconnected.toString()),
  //                   Text(vpnService.status?.toJson().toString() ?? ""),
  //                   TextButton(
  //                     child: const Text("Start"),
  //                     onPressed: () {
  //                       vpnService.initPlatformState();
  //                     },
  //                   ),
  //                   TextButton(
  //                     child: const Text("STOP"),
  //                     onPressed: () {
  //                       vpnService.disconnect();
  //                     },
  //                   ),
  //                   if (Platform.isAndroid)
  //                     TextButton(
  //                       child: Text(vpnService.granted
  //                           ? "Granted"
  //                           : "Request Permission"),
  //                       onPressed: () {
  //                         vpnService.requestPermissionAndroid();
  //                       },
  //                     ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => vpnService,
      child: const MaterialApp(
        title: 'OpenVpn Demo',
        home: Home(),
      ),
    );
  }
}



  // @override
  // Widget build(BuildContext context) {
  //   return ChangeNotifierProvider(
  //     create: (_) => vpnService,
  //     child: MaterialApp(
  //       home: Scaffold(
  //         appBar: AppBar(
  //           title: const Text('Plugin example app'),
  //         ),
  //         body: Center(
  //           child: Consumer<VpnService>(
  //             builder: (context, vpnService, child) {
  //               return Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Text(vpnService.stage?.toString() ??
  //                       VPNStage.disconnected.toString()),
  //                   Text(vpnService.status?.toJson().toString() ?? ""),
  //                   TextButton(
  //                     child: const Text("Start"),
  //                     onPressed: () {
  //                       vpnService.initPlatformState();
  //                     },
  //                   ),
  //                   TextButton(
  //                     child: const Text("STOP"),
  //                     onPressed: () {
  //                       vpnService.disconnect();
  //                     },
  //                   ),
  //                   if (Platform.isAndroid)
  //                     TextButton(
  //                       child: Text(vpnService.granted
  //                           ? "Granted"
  //                           : "Request Permission"),
  //                       onPressed: () {
  //                         vpnService.requestPermissionAndroid();
  //                       },
  //                     ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }