import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';

class ProfileService {
  static Future<Map<String, dynamic>> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.userTokenKey);

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/profile');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.trim()}';
    }

    final response = await http.get(uri, headers: headers);

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

  static Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required int? age,
    required String maritalStatus,
    required String mobile,
    required String city,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.userTokenKey);

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/profile');

    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.trim()}';
    }

    final payload = <String, dynamic>{
      'name': name,
      'email': email,
      'age': age,
      'marital_status': maritalStatus,
      'mobile': mobile,
      'city': city,
    };

    final response = await http.put(uri, headers: headers, body: jsonEncode(payload));

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
