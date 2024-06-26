import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class VpnConnectButton extends StatelessWidget {
  const VpnConnectButton({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Color colour = Colors.blue;
    bool isLoading = false;
    return Consumer<VpnService>(builder: (context, vpnService, child) {
      return GestureDetector(
        onTap: isLoading
            ? null
            : () async {
                if (vpnService.stage?.toString() == 'connected') {
                  vpnService.disconnect();
                  colour = Colors.blue;
                } else {
                  vpnService.initPlatformState();
                  colour = Colors.orange;
                  isLoading = true;
                  int attempt = 0;
                  while (vpnService.stage?.toString() != 'connected' &&
                      attempt < 20) {
                    attempt += 1;
                    await Future.delayed(const Duration(milliseconds: 500));
                  }
                  vpnService.stage?.toString() == 'connected'
                      ? colour = Colors.green
                      : colour = Colors.blue;
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
              color: Colors.black
                  .withOpacity(0.5), // Shadow color with transparency
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
                vpnService.stage?.toString() ??
                    VPNStage.disconnected.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.05),
              )
            ],
          ),
        ),
      );
    });
  }
}
