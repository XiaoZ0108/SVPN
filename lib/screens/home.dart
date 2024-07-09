import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_app/widget/vpn_select_button.dart';
import 'package:my_app/widget/vpn_connect_button.dart';
import 'package:my_app/widget/network_speed.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:my_app/models/vpn_country.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  late VpnService vpnService;
  String ip = "Not Connected";

  @override
  void initState() {
    super.initState();
    _restoreIpAddress();
  }

  // Future<void> _restoreVpnState() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _vpnState = prefs.getString('vpnState') ?? VpnEngine.vpnDisconnected;
  //   });
  // }

  // Future<void> _saveVpnState(String state) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('vpnState', state);
  // }

  Future<void> _restoreIpAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ip = prefs.getString('ipAddress') ?? "Not Connected";
    });
  }

  Future<void> _saveIpAddress(String ip) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('ipAddress', ip);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Access passed data
    final String userId = arguments?['email'] ?? '';

    double screenWidth = MediaQuery.of(context).size.width;
    Future<void> getIP(bool isConnected) async {
      if (isConnected == true) {
        String ipAddress = await VpnCountry.fetchIpAddress();
        setState(() {
          ip = ipAddress;
          _saveIpAddress(ip);
        });
      } else {
        setState(() {
          ip = "Not Connected";
          _saveIpAddress(ip);
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "SecureNet VPN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<VpnService>(
        builder: (context, vpnService, child) {
          Color defaultColor;
          switch (vpnService.stage?.toString()) {
            case 'connected':
              defaultColor = Colors.green;
              break;
            case 'disconnected':
              defaultColor = Colors.white;
              break;
            default:
              defaultColor = Colors.orange;
              break;
          }
          return Column(
            children: [
              VPNButton(color: defaultColor, country: 'Singapore', ip: ip),
              Container(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.08,
                    right: screenWidth * 0.08,
                    top: screenWidth * 0.06),
                child: NetworkSpeed(
                  down: vpnService.status?.byteIn,
                  up: vpnService.status?.byteIn,
                ),
              ),
              VpnConnectButton(getIp: getIP),
              Text(userId),
            ],
          );
        },
      ),
    );
  }
}
