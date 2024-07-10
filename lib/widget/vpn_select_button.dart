import 'package:flutter/material.dart';
import 'package:my_app/widget/country_logo.dart';

class VPNButton extends StatefulWidget {
  const VPNButton(
      {super.key,
      required this.color,
      required this.country,
      required this.ip,
      this.changeScreen});

  final Function? changeScreen;
  final Color color;
  final String country;
  final String ip;

  @override
  State<VPNButton> createState() {
    return VPNButtonState();
  }
}

class VPNButtonState extends State<VPNButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        // Provider.of<VpnService>(context, listen: false)
        //     .navigateTo('/countryScreen');
        Navigator.pushNamed(context, '/countryScreen');
      },
      child: Container(
        height: screenHeight * 0.08,
        margin: EdgeInsets.only(
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
            top: screenWidth * 0.03),
        padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
        ),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(0, 2),
              blurRadius: 7,
            )
          ],
        ),
        child: Row(
          children: [
            CountryLogo(
              country: widget.country,
              ip: widget.ip,
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: screenWidth * 0.07,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
