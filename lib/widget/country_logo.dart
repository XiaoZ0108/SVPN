import 'package:flutter/material.dart';

class CountryLogo extends StatelessWidget {
  final String country;
  final String? ip;

  CountryLogo({required this.country, required this.ip});
  @override
  Widget build(BuildContext context) {
    //dynamic width
    double screenWidth = MediaQuery.of(context).size.width;

    return Flexible(
      flex: 1,
      child: Container(
        child: Row(
          children: [
            Image(
              image: AssetImage('assets/logo/$country.png'),
            ),
            SizedBox(
              width: screenWidth * 0.05,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05),
                ),
                Text(
                  'IP $ip',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
