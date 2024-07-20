import 'package:flutter/material.dart';

class NetworkSpeed extends StatelessWidget {
  const NetworkSpeed({super.key, this.up, this.down, this.time});

  final String? down;
  final String? up;
  final String? time;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.arrow_downward_rounded,
                size: screenWidth * 0.08,
                color: const Color.fromARGB(255, 136, 27, 155)),
            Text(down != "" ? formatBytesFromString(down!) : "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.035)),
          ],
        ),
        Center(
          child: Text(time == "00:00:00" ? "" : time!,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: screenWidth * 0.05)),
        ),
        Row(
          children: [
            Icon(Icons.arrow_upward_rounded,
                size: screenWidth * 0.08,
                color: const Color.fromARGB(255, 25, 221, 211)),
            Text(up != "" ? formatBytesFromString(up!) : "",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.035)),
          ],
        ),
      ],
    );
  }

  String formatBytesFromString(String byteString) {
    try {
      // Convert the input string to an integer
      int bytes = int.parse(byteString);

      // Define conversion constants
      const int kb = 1024;
      const int mb = kb * 1024;
      const int gb = mb * 1024;

      // Format based on the size
      if (bytes >= gb) {
        return (bytes / gb).toStringAsFixed(2) + ' GB';
      } else if (bytes >= mb) {
        return (bytes / mb).toStringAsFixed(2) + ' MB';
      } else if (bytes >= kb) {
        return (bytes / kb).toStringAsFixed(2) + ' KB';
      } else {
        return '$bytes B';
      }
    } catch (e) {
      // Handle the case where the input string is not a valid number
      return 'Invalid input';
    }
  }
}
