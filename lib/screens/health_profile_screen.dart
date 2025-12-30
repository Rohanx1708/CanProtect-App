import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../widgets/base_screen.dart';
import 'bse_marking_screen.dart';
import 'health_history_screen.dart';
import '../services/health_profile_service.dart';

class HealthProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? initialRecord;
  final String? healthProfileId;

  const HealthProfileScreen({
    super.key,
    this.initialRecord,
    this.healthProfileId,
  });

  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  final _weightController = TextEditingController();
  final _bpHighController = TextEditingController();
  final _bpLowController = TextEditingController();
  final _papSmearController = TextEditingController();
  final _mammographyController = TextEditingController();
  final _gynVisitController = TextEditingController();
  final _periodController = TextEditingController();
  final _breastExamController = TextEditingController();
  List<BseMarker> _bseMarkers = const [];
  String? _bseMarkedImagePath;

  @override
  void initState() {
    super.initState();
    final r = widget.initialRecord;
    if (r != null) {
      _weightController.text = (r['height'] ?? '').toString();
      _bpHighController.text = (r['bp_upper'] ?? '').toString();
      _bpLowController.text = (r['bp_lower'] ?? '').toString();
      _papSmearController.text = (r['recent_pap_smear'] ?? '').toString();
      _mammographyController.text = (r['recent_mammography'] ?? '').toString();
      _gynVisitController.text = (r['gyn_visit'] ?? '').toString();
      _periodController.text = (r['period'] ?? '').toString();
      _breastExamController.text = (r['base_findings'] ?? '').toString();
    }
  }

  static const String _healthHistoryPrefsKey = 'health_history_records_v1';

  void _openPeriodSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        Widget option(String value) {
          return ListTile(
            title: Text(value, style: const TextStyle(fontSize: 18)),
            onTap: () {
              setState(() {
                _periodController.text = value;
              });
              Navigator.of(context).pop();
            },
          );
        }

        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Period',
                  style: TextStyle(
                    color: Color(0xFFE91E63),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              option('Normal'),
              option('Heavy Flow'),
              option('Uncertain'),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openBseMarking() async {
    final result = await Navigator.of(context).push<BseMarkingResult>(
      MaterialPageRoute(
        builder: (context) => BseMarkingScreen(initialMarkers: _bseMarkers),
      ),
    );

    if (result == null) return;

    setState(() {
      _breastExamController.text = result.toSummaryString();
      _bseMarkers = result.markers;
      _bseMarkedImagePath = result.markedImagePath;
    });
  }

  Future<bool> _saveHealthProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final fallbackUserId = (widget.initialRecord?['user_id'] ?? '').toString();
    final userId = _getUserIdForApi(prefs) ?? (fallbackUserId.trim().isEmpty ? null : fallbackUserId);
    if (userId == null || userId.trim().isEmpty) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found. Please login again (missing user id).')),
      );
      return false;
    }

    final papIso = _toApiDate(_papSmearController.text);
    final mammoIso = _toApiDate(_mammographyController.text);
    final gynIso = _toApiDate(_gynVisitController.text);

    final apiResponse = widget.healthProfileId != null && widget.healthProfileId!.trim().isNotEmpty
        ? await HealthProfileService.updateHealthProfile(
            id: widget.healthProfileId!.trim(),
            userId: userId.trim(),
            height: _weightController.text.trim(),
            bpUpper: _bpHighController.text.trim(),
            bpLower: _bpLowController.text.trim(),
            recentPapSmear: papIso,
            recentMammography: mammoIso,
            gynVisit: gynIso,
            period: _periodController.text.trim(),
            baseFindings: _breastExamController.text.trim(),
            markedImagePath: _bseMarkedImagePath,
          )
        : await HealthProfileService.createHealthProfile(
            userId: userId.trim(),
            height: _weightController.text.trim(),
            bpUpper: _bpHighController.text.trim(),
            bpLower: _bpLowController.text.trim(),
            recentPapSmear: papIso,
            recentMammography: mammoIso,
            gynVisit: gynIso,
            period: _periodController.text.trim(),
            baseFindings: _breastExamController.text.trim(),
            markedImagePath: _bseMarkedImagePath,
          );

    final statusCode = apiResponse['statusCode'];
    final isOk = statusCode == 200 || statusCode == 201;
    if (!isOk) {
      final message = _extractErrorMessage(apiResponse) ?? 'Failed to save health profile.';
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return false;
    }

    final record = <String, dynamic>{
      'savedAt': DateTime.now().toIso8601String(),
      'weight': _weightController.text,
      'bpHigh': _bpHighController.text,
      'bpLow': _bpLowController.text,
      'papSmear': _papSmearController.text,
      'mammography': _mammographyController.text,
      'gynVisit': _gynVisitController.text,
      'period': _periodController.text,
      'bseFindings': _breastExamController.text,
      'bseMarkers': _bseMarkers.map((m) => m.toMap()).toList(),
    };

    final existingRaw = prefs.getString(_healthHistoryPrefsKey);
    final List<dynamic> existingList = existingRaw == null
        ? <dynamic>[]
        : (jsonDecode(existingRaw) as List<dynamic>);

    existingList.insert(0, record);
    await prefs.setString(_healthHistoryPrefsKey, jsonEncode(existingList));

    if (widget.healthProfileId != null && widget.healthProfileId!.trim().isNotEmpty) {
      if (!mounted) return false;
      Navigator.of(context).pop(true);
      return true;
    }

    return true;
  }

  String? _getUserIdForApi(SharedPreferences prefs) {
    final direct = prefs.getString(AppConstants.userIdKey);
    if (direct != null && direct.trim().isNotEmpty) return direct;

    final rawProfile = prefs.getString(AppConstants.userProfileKey);
    if (rawProfile == null || rawProfile.trim().isEmpty) return null;

    try {
      final decoded = jsonDecode(rawProfile);
      if (decoded is Map) {
        final id = decoded['id'] ?? decoded['user_id'] ?? decoded['userId'];
        if (id is String && id.trim().isNotEmpty) return id.trim();
        if (id is num) return id.toString();
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  String _toApiDate(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return '';

    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(raw)) return raw;

    final parts = raw.split('/');
    if (parts.length == 3) {
      final dd = parts[0].padLeft(2, '0');
      final mm = parts[1].padLeft(2, '0');
      final yyyy = parts[2];
      if (RegExp(r'^\d{4}$').hasMatch(yyyy)) {
        return '$yyyy-$mm-$dd';
      }
    }

    return raw;
  }

  String? _extractErrorMessage(Map<String, dynamic> response) {
    String? pickFromErrors(dynamic errors) {
      if (errors is! Map) return null;
      for (final v in errors.values) {
        if (v is List && v.isNotEmpty) {
          final first = v.first;
          if (first is String && first.trim().isNotEmpty) return first.trim();
        }
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
      return null;
    }

    final message = response['message'];
    final topLevelErrors = pickFromErrors(response['errors']);

    final data = response['data'];
    final nestedErrors = data is Map ? pickFromErrors(data['errors']) : null;

    if (topLevelErrors != null) return topLevelErrors;
    if (nestedErrors != null) return nestedErrors;
    if (message is String && message.trim().isNotEmpty) return message.trim();

    final raw = response['raw'];
    if (raw is String && raw.trim().isNotEmpty) return raw.trim();
    return null;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _bpHighController.dispose();
    _bpLowController.dispose();
    _papSmearController.dispose();
    _mammographyController.dispose();
    _gynVisitController.dispose();
    _periodController.dispose();
    _breastExamController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE91E63),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
              surfaceTint: Color(0xFFE91E63),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE91E63),
              ),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
            ),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'HEALTH PROFILE',
      showTitleInTopBar: false,
      content: Align(
        alignment: const Alignment(0, -0.25),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double padding = constraints.maxWidth > 600 ? 32.0 : 20.0;
            final double spacing = constraints.maxWidth > 600 ? 8.0 : 4.0;
            final double headingSpacing = constraints.maxWidth > 600 ? 20.0 : 15.0;
            final double saveButtonSpacing = constraints.maxWidth > 600 ? 20.0 : 15.0;
            
            return Padding(
              padding: EdgeInsets.all(padding),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'HEALTH PROFILE',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    SizedBox(height: headingSpacing),
                    _buildInputField('Enter Height (cm)', _weightController, TextInputType.number),
                    SizedBox(height: spacing),
                    _buildInputField('BP (Upper Side for eg 120)', _bpHighController, TextInputType.number),
                    SizedBox(height: spacing),
                    _buildInputField('BP (Lower Side for eg 80)', _bpLowController, TextInputType.number),
                    SizedBox(height: spacing),
                    _buildDateField('Recent Pap Smear', _papSmearController),
                    SizedBox(height: spacing),
                    _buildDateField('Recent Mammography', _mammographyController),
                    SizedBox(height: spacing),
                    _buildDateField('Recent Gynaecologist Visit', _gynVisitController),
                    SizedBox(height: spacing),
                    _buildPeriodField('Period', _periodController),
                    SizedBox(height: spacing),
                    _buildBseField('Mark Breast-self-exam findings', _breastExamController),
                    SizedBox(height: saveButtonSpacing),
                    _buildSaveButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPeriodField(String label, TextEditingController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double fieldWidth = constraints.maxWidth > 600
            ? constraints.maxWidth * 0.5
            : constraints.maxWidth > 400
                ? constraints.maxWidth * 0.7
                : constraints.maxWidth * 0.9;

        return SizedBox(
          width: fieldWidth,
          child: Container(
            height: 35,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: controller,
              readOnly: true,
              onTap: _openPeriodSheet,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                hintText: label,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                alignLabelWithHint: true,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBseField(String label, TextEditingController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double fieldWidth = constraints.maxWidth > 600
            ? constraints.maxWidth * 0.5
            : constraints.maxWidth > 400
                ? constraints.maxWidth * 0.7
                : constraints.maxWidth * 0.9;

        return SizedBox(
          width: fieldWidth,
          child: Container(
            height: 35,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: controller,
              readOnly: true,
              onTap: _openBseMarking,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                hintText: label,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                alignLabelWithHint: true,
                suffixIcon: const Icon(Icons.edit, color: Colors.pink, size: 18),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, TextInputType? keyboardType) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double fieldWidth = constraints.maxWidth > 600 
            ? constraints.maxWidth * 0.5  // Increased width
            : constraints.maxWidth > 400 
                ? constraints.maxWidth * 0.7  // Increased width
                : constraints.maxWidth * 0.9; // Increased width
        
        return SizedBox(
          width: fieldWidth,
          child: Container(
            height: 35,  // Decreased height from 45 to 35
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 14, color: Colors.black),  // Increased font size and black color
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),  // Adjusted vertical padding for centering
                hintText: label,
                hintStyle: TextStyle(
                  fontSize: 14,  // Increased font size
                  color: Colors.grey.shade600,  // Faded grey color
                ),
                alignLabelWithHint: true,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double fieldWidth = constraints.maxWidth > 600 
            ? constraints.maxWidth * 0.5  // Increased width
            : constraints.maxWidth > 400 
                ? constraints.maxWidth * 0.7  // Increased width
                : constraints.maxWidth * 0.9; // Increased width

        return SizedBox(
          width: fieldWidth,
          child: Container(
            height: 35,  // Decreased height from 45 to 35
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: controller,
              readOnly: true,
              onTap: () => _selectDate(controller),
              style: const TextStyle(fontSize: 14, color: Colors.black),  // Increased font size and black color
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),  // Adjusted vertical padding for centering
                hintText: label,
                hintStyle: TextStyle(
                  fontSize: 14,  // Increased font size
                  color: Colors.grey.shade600,  // Faded grey color
                ),
                alignLabelWithHint: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month, color: Colors.pink, size: 18),  // Increased icon size
                  onPressed: () => _selectDate(controller),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: 120,
      height: 45,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF3D7F), Color(0xFFE91E63)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: () async {
            final ok = await _saveHealthProfile();
            if (!mounted) return;
            if (!ok) return;

            if (widget.healthProfileId == null || widget.healthProfileId!.trim().isEmpty) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HealthHistoryScreen()),
              );
            }
          },
          child: const Center(
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
