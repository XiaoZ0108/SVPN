import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieW extends StatelessWidget {
  final String lottie; // Lottie animation file name
  final String text; // Text to display at the bottom
  final Color color;
  const LottieW(
      {super.key,
      required this.lottie,
      required this.text,
      required this.color});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 1.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.asset(
              'assets/animation/$lottie.json', // Adjust path to your Lottie animation file
              width: screenWidth * 0.8, // Adjust width as needed
              height: screenWidth * 0.8,
              fit: BoxFit.contain, // Adjust fit as needed
            ),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
