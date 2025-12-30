import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/app_constants.dart';

class RegisterService {
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required int? age,
    required String maritalStatus,
    required String mobile,
    required String city,
  }) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/register');
    final response = await http.post(
      uri,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'age': age,
        'marital_status': maritalStatus,
        'mobile': mobile,
        'city': city,
      }),
    );

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
