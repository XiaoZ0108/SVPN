import 'package:flutter/material.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:provider/provider.dart';
import 'package:my_app/screens/home.dart';

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
