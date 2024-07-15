import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:my_app/services/user_services.dart';
import 'package:provider/provider.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class VpnConnectButton extends StatefulWidget {
  const VpnConnectButton({super.key, required this.getIp});
  final Future<void> Function(bool) getIp;

  @override
  State<VpnConnectButton> createState() => VpnConnectButtonState();
}

class VpnConnectButtonState extends State<VpnConnectButton> {
  bool isLoading = false;
  Color colour = Colors.blue;
  //Timer? _disconnectTimer;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final vpnService = Provider.of<VpnService>(context, listen: false);
    UserService userService = Provider.of<UserService>(context, listen: true);
    String token = userService.token;
    if (vpnService.stage?.toString() == 'connected') {
      colour = Colors.green;
    }

    return GestureDetector(
      onTap: isLoading
          ? null
          : () async {
              if (vpnService.stage?.toString() == 'connected') {
                await disconnect(vpnService);
              } else {
                await connect(vpnService, context, token);
                colour = Colors.orange;
                isLoading = true;
                int attempt = 0;
                while (vpnService.stage?.toString() != 'connected' &&
                    attempt < 20) {
                  attempt += 1;
                  await Future.delayed(const Duration(milliseconds: 500));
                }
                if (vpnService.stage?.toString() == 'connected') {
                  colour = Colors.green;
                  await widget.getIp(true);
                } else {
                  colour = Colors.blue;
                }
                isLoading = false;
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: screenWidth * 0.5,
        height: screenHeight * 0.3,
        decoration:
            BoxDecoration(color: colour, shape: BoxShape.circle, boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.5), // Shadow color with transparency
            spreadRadius: 3, // Spread radius
            blurRadius: 7, // Blur radius
            offset: const Offset(
                0, 6), // Horizontal and vertical offset, only bottom shadow
          ),
        ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.power_settings_new_rounded,
              color: Colors.white,
              size: screenWidth * 0.2,
            ),
            Text(
              vpnService.capitalizeFirstLetter(vpnService.stage?.toString() ??
                  VPNStage.disconnected.toString()),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05),
            )
          ],
        ),
      ),
    );
  }

  Future<void> connect(
      VpnService vpnService, BuildContext context, String token) async {
    int time = await vpnService.getTime();
    final response =
        await http.post(Uri.parse('http://192.168.0.5:3000/connect'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(<String, dynamic>{
              'disconnectTime': time.toString(),
            }));
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseData['allowed']) {
        int allowedTime = (responseData['allowedTime'] as num).toInt();

        // if (allowedTime != -1) {

        //   _disconnectTimer = Timer(Duration(seconds: allowedTime), () async {
        //     await disconnect(vpnService);
        //   });
        // }
        if (allowedTime != -1) {
          final service = FlutterBackgroundService();
          if (!await service.isRunning()) {
            service.startService();
          }
          while (!await service.isRunning()) {
            await Future.delayed(const Duration(milliseconds: 500));
          }
          service.invoke('setAsForeground');
          service.invoke('countdown', {'allowTime': allowedTime});
        }
        vpnService.initPlatformState();
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You have reached your daily limit of 1 hour')),
        );
      }
    } else {
      //print(responseData['error']);
    }
  }

  disconnect(VpnService vpnService) async {
    FlutterBackgroundService().invoke('stop');
    VpnService.saveTime();
    VpnService.disconnect2();
    // await vpnService.saveTime();
    // vpnService.disconnect();
    await widget.getIp(false);
    colour = Colors.blue;
    isLoading = false;
  }
}
