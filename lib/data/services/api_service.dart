import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class ApiService {
  static final http.Client _client = http.Client();

  static Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  static Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    return await _client.get(
      Uri.parse('${AppConstants.baseUrl}$endpoint'),
      headers: headers,
    );
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return await _client.post(
      Uri.parse('${AppConstants.baseUrl}$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    final headers = await _getHeaders();
    return await _client.put(
      Uri.parse('${AppConstants.baseUrl}$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    return await _client.delete(
      Uri.parse('${AppConstants.baseUrl}$endpoint'),
      headers: headers,
    );
  }

  static Future<Map<String, dynamic>> registerV1({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required int? age,
    required String maritalStatus,
    required String mobile,
    required String city,
  }) async {
    final response = await post('/api/v1/register', <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'age': age,
      'marital_status': maritalStatus,
      'mobile': mobile,
      'city': city,
    });

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

  static Future<UserModel?> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await post('/users', userData);
      if (response.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  static Future<UserModel?> getUser(String userId) async {
    try {
      final response = await get('/users/$userId');
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  static Future<UserModel?> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      final response = await put('/users/$userId', userData);
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  static Future<bool> deleteUser(String userId) async {
    try {
      final response = await delete('/users/$userId');
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
