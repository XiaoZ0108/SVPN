import 'package:flutter/material.dart';

class NetworkSpeed extends StatelessWidget {
  const NetworkSpeed({super.key, this.up, this.down});

  final String? down;
  final String? up;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.arrow_downward_rounded,
                  size: screenWidth * 0.08,
                  color: const Color.fromARGB(255, 136, 27, 155)),
              Text(down ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035)),
            ],
          ),
        ),
        Row(
          children: [
            Icon(Icons.arrow_upward_rounded,
                size: screenWidth * 0.08,
                color: const Color.fromARGB(255, 25, 221, 211)),
            Text(up ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.035)),
          ],
        ),
      ],
    );
  }
}
