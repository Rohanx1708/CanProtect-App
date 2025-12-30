import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';

class LogoutService {
  static Future<Map<String, dynamic>> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.userTokenKey);

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/logout');

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.trim()}';
    }

    final response = await http.post(uri, headers: headers);

    Map<String, dynamic> decoded;
    try {
      final body = jsonDecode(response.body);
      decoded = body is Map<String, dynamic> ? body : <String, dynamic>{'data': body};
    } catch (_) {
      decoded = <String, dynamic>{'raw': response.body};
    }

    decoded['statusCode'] = response.statusCode;
    return decoded;
  }
}
