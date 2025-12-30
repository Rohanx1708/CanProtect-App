import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';

class HealthProfileService {
  static Future<Map<String, dynamic>> createHealthProfile({
    required String userId,
    required String height,
    required String bpUpper,
    required String bpLower,
    required String recentPapSmear,
    required String recentMammography,
    required String gynVisit,
    required String period,
    required String baseFindings,
    String? markedImagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.userTokenKey);

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/health-profiles');

    final request = http.MultipartRequest('POST', uri);
    request.headers['Accept'] = 'application/json';
    if (token != null && token.trim().isNotEmpty) {
      request.headers['Authorization'] = 'Bearer ${token.trim()}';
    }

    request.fields['user_id'] = userId;
    request.fields['height'] = height;
    request.fields['bp_upper'] = bpUpper;
    request.fields['bp_lower'] = bpLower;
    request.fields['recent_pap_smear'] = recentPapSmear;
    request.fields['recent_mammography'] = recentMammography;
    request.fields['gyn_visit'] = gynVisit;
    request.fields['period'] = period;
    request.fields['base_findings'] = baseFindings;

    final path = markedImagePath?.trim();
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (await file.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'marked_image',
            path,
          ),
        );
      }
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

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

  static Future<Map<String, dynamic>> updateHealthProfile({
    required String id,
    required String userId,
    required String height,
    required String bpUpper,
    required String bpLower,
    required String recentPapSmear,
    required String recentMammography,
    required String gynVisit,
    required String period,
    required String baseFindings,
    String? markedImagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.userTokenKey);

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/health-profiles/$id');

    final request = http.MultipartRequest('POST', uri);
    request.headers['Accept'] = 'application/json';
    if (token != null && token.trim().isNotEmpty) {
      request.headers['Authorization'] = 'Bearer ${token.trim()}';
    }

    request.fields['_method'] = 'PUT';

    request.fields['user_id'] = userId;
    request.fields['height'] = height;
    request.fields['bp_upper'] = bpUpper;
    request.fields['bp_lower'] = bpLower;
    request.fields['recent_pap_smear'] = recentPapSmear;
    request.fields['recent_mammography'] = recentMammography;
    request.fields['gyn_visit'] = gynVisit;
    request.fields['period'] = period;
    request.fields['base_findings'] = baseFindings;

    final path = markedImagePath?.trim();
    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (await file.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'marked_image',
            path,
          ),
        );
      }
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

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

  static Future<Map<String, dynamic>> fetchHealthProfiles({int page = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.userTokenKey);

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/health-profiles?page=$page');

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

  static Future<Map<String, dynamic>> deleteHealthProfile({required String id}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.userTokenKey);

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/health-profiles/$id');

    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (token != null && token.trim().isNotEmpty) {
      headers['Authorization'] = 'Bearer ${token.trim()}';
    }

    final response = await http.delete(uri, headers: headers);

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
