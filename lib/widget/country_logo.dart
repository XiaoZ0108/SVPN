import 'package:flutter/material.dart';

class CountryLogo extends StatelessWidget {
  final String country;
  final String? ip;
  final bool? selected;
  const CountryLogo({required this.country, this.ip, super.key, this.selected});
  @override
  Widget build(BuildContext context) {
    //dynamic width
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Image(
          image: AssetImage('assets/logo/$country.png'),
        ),
        SizedBox(
          width: screenWidth * 0.05,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              country,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05),
            ),
            if (ip != null)
              Text(
                'IP $ip',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05),
              )
          ],
        ),
      ],
    );
  }
}
