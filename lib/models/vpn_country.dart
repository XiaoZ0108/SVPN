import 'package:http/http.dart' as http;
import 'dart:convert';

class VpnCountry {
  VpnCountry({required this.country, this.ip, this.config});

  final String country;
  final String? ip;
  final String? config;

  static Future<String> fetchIpAddress() async {
    try {
      var response = await http.get(Uri.parse('https://ipv4.seeip.org/jsonip'));
      if (response.statusCode == 200) {
        String res = response.body;
        Map<String, dynamic> json = jsonDecode(res);
        return json['ip'];
      } else {
        return "N/A";
      }
    } catch (e) {
      return "N/A";
    }
  }
}
