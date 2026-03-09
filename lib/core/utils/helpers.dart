import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static void showSnackBar(BuildContext context, String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('d MMM, y').format(dateTime);
  }

  static String formatApiDateString(dynamic value) {
    final raw = (value ?? '').toString().trim();
    if (raw.isEmpty) return '';

    final normalized = raw.contains(' ') ? raw.replaceFirst(' ', 'T') : raw;
    final dt = DateTime.tryParse(normalized);
    if (dt == null) return raw;
    return formatDateTime(dt);
  }
  
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }
  
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
