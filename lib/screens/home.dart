import 'package:flutter/material.dart';
import 'package:my_app/widget/vpn_select_button.dart';
import 'package:my_app/widget/vpn_connect_button.dart';
import 'package:my_app/widget/network_speed.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
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

  @override
  void initState() {
    super.initState();
    // final vpnService = Provider.of<VpnService>(context, listen: false);
    // vpnService.requestPermissionAndroid();
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

  // Future<void> _restoreIpAddress() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     current_ip = prefs.getString('ipAddress') ?? "Not Connected";
  //   });
  // }

  // Future<void> _saveIpAddress(String ip) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('ipAddress', ip);
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Color defaultColor = Colors.white;
    String ip = "Not Connected";
    // switch (vpnService.stage?.toString()) {
    //   case VpnEngine.vpnConnected:
    //     _defaultColor = Colors.green;

    //     break;
    //   case VpnEngine.vpnDisconnected:
    //     _defaultColor = Colors.white;
    //     break;
    //   default:
    //     _defaultColor = Colors.orange;
    // }
    void getIP(bool isConnected) async {
      if (isConnected == true) {
        String ipAddress = await VpnCountry.fetchIpAddress();
        setState(() {
          ip = ipAddress;
        });
      } else {
        setState(() {
          ip = "Not Connected";
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("SecureNet VPN"),
        ),
        body: Consumer<VpnService>(builder: (context, vpnService, child) {
          return Column(
            children: [
              VPNButton(color: defaultColor, country: 'Australia', ip: ip),
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
              const VpnConnectButton(),
            ],
          );
        }));
  }
}
