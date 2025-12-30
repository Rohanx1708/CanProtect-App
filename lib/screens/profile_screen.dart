import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';
import '../services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = ProfileService.fetchProfile();
  }

  void _refresh() {
    setState(() {
      _future = ProfileService.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'PROFILE',
      showTitleInTopBar: false,
      content: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFE91E63)),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Failed to load profile.',
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _refresh,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final data = snapshot.data ?? <String, dynamic>{};
            final statusCode = data['statusCode'];
            final isOk = statusCode == 200 || statusCode == 201;

            if (!isOk) {
              final message = _extractErrorMessage(data) ?? 'Failed to load profile.';
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _refresh,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final user = _extractUser(data);

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'PROFILE',
                      style: TextStyle(
                        color: Color(0xFFE91E63),
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ProfileForm(
                    key: ValueKey(user['id']?.toString() ?? 'profile_form'),
                    user: user,
                    onUpdated: _refresh,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Map<String, dynamic> _extractUser(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map) {
      final user = data['user'];
      if (user is Map) {
        return Map<String, dynamic>.from(user);
      }
    }
    final user = response['user'];
    if (user is Map) {
      return Map<String, dynamic>.from(user);
    }
    return <String, dynamic>{};
  }

  String? _extractErrorMessage(Map<String, dynamic> response) {
    final message = response['message'];
    if (message is String && message.trim().isNotEmpty) return message.trim();

    final error = response['error'];
    if (error is String && error.trim().isNotEmpty) return error.trim();

    final errors = response['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) {
        final v = first.first;
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
      if (first is String && first.trim().isNotEmpty) return first.trim();
    }
    return null;
  }
}

class _ProfileForm extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onUpdated;
  final TextStyle _labelStyle = const TextStyle(color: Colors.black,fontWeight: FontWeight.w600, fontSize: 14);

  const _ProfileForm({super.key, required this.user, required this.onUpdated});

  @override
  State<_ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _maritalStatusController;
  late final TextEditingController _mobileController;
  late final TextEditingController _cityController;
  late final TextEditingController _emailController;
  late final TextEditingController _roleController;
  bool _saving = false;
  String? _selectedMaritalStatus;

  static const List<String> _maritalStatusOptions = <String>[
    'Single',
    'Married',
    'Divorced',
    'Widowed',
  ];

  String _pickString(dynamic v) {
    if (v == null) return '';
    if (v is String) return v;
    if (v is num) return v.toString();
    return v.toString();
  }

  int? _tryParseInt(String v) {
    final t = v.trim();
    if (t.isEmpty) return null;
    return int.tryParse(t);
  }

  @override
  void initState() {
    super.initState();

    final profileRaw = widget.user['profile'];
    final profile = profileRaw is Map ? Map<String, dynamic>.from(profileRaw) : <String, dynamic>{};

    final name = _pickString(profile['name']).trim().isNotEmpty
        ? _pickString(profile['name']).trim()
        : _pickString(widget.user['name']).trim();
    final age = _pickString(profile['age']).trim();
    final maritalStatus = _pickString(profile['marital_status']).trim();
    final mobile = _pickString(profile['mobile']).trim();
    final city = _pickString(profile['city']).trim();
    final email = _pickString(profile['email']).trim().isNotEmpty
        ? _pickString(profile['email']).trim()
        : _pickString(widget.user['email']).trim();

    _nameController = TextEditingController(text: name);
    _ageController = TextEditingController(text: age);
    _maritalStatusController = TextEditingController(text: maritalStatus);
    _mobileController = TextEditingController(text: mobile);
    _cityController = TextEditingController(text: city);
    _emailController = TextEditingController(text: email);

    if (_maritalStatusOptions.contains(maritalStatus)) {
      _selectedMaritalStatus = maritalStatus;
    }

    final roleRaw = widget.user['role'];
    final role = roleRaw is Map ? Map<String, dynamic>.from(roleRaw) : <String, dynamic>{};
    final roleName = _pickString(role['name']).trim();
    _roleController = TextEditingController(text: roleName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _maritalStatusController.dispose();
    _mobileController.dispose();
    _cityController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving) return;

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final age = _tryParseInt(_ageController.text);
    final maritalStatus = _maritalStatusController.text.trim();
    final mobile = _mobileController.text.trim();
    final city = _cityController.text.trim();

    setState(() {
      _saving = true;
    });

    try {
      final response = await ProfileService.updateProfile(
        name: name,
        email: email,
        age: age,
        maritalStatus: maritalStatus,
        mobile: mobile,
        city: city,
      );

      final statusCode = response['statusCode'];
      final isOk = statusCode == 200 || statusCode == 201;

      if (!mounted) return;

      if (!isOk) {
        final message = _extractErrorMessage(response) ?? 'Failed to update profile.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );
      widget.onUpdated();
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  String? _extractErrorMessage(Map<String, dynamic> response) {
    final message = response['message'];
    if (message is String && message.trim().isNotEmpty) return message.trim();

    final error = response['error'];
    if (error is String && error.trim().isNotEmpty) return error.trim();

    final errors = response['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) {
        final v = first.first;
        if (v is String && v.trim().isNotEmpty) return v.trim();
      }
      if (first is String && first.trim().isNotEmpty) return first.trim();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final roleName = _roleController.text.trim();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _label('Name'),
          _field(
            controller: _nameController,
            validator: (value) {
              final v = (value ?? '').trim();
              if (v.isEmpty) return 'Name is required.';
              return null;
            },
          ),
          _label('Age'),
          _field(
            controller: _ageController,
            keyboardType: TextInputType.number,
            validator: (value) {
              final v = (value ?? '').trim();
              if (v.isEmpty) return 'Age is required.';
              final parsed = int.tryParse(v);
              if (parsed == null) return 'Age must be a number.';
              if (parsed <= 0) return 'Age must be greater than 0.';
              if (parsed > 120) return 'Age must be 120 or less.';
              return null;
            },
          ),
          _label('Marital Status'),
          _maritalStatusDropdown(),
          _label('Mobile Number'),
          _field(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              final raw = (value ?? '').trim();
              if (raw.isEmpty) return 'Mobile number is required.';
              final digitsOnly = raw.replaceAll(RegExp(r'\\D'), '');
              if (digitsOnly.length != raw.length) {
                return 'Mobile number must contain digits only.';
              }
              if (digitsOnly.length != 10) {
                return 'Mobile number must be 10 digits.';
              }
              return null;
            },
          ),
          _label('City'),
          _field(
            controller: _cityController,
            validator: (value) {
              final v = (value ?? '').trim();
              if (v.isEmpty) return 'City is required.';
              return null;
            },
          ),
          _label('Email Address'),
          _field(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              final v = (value ?? '').trim();
              if (v.isEmpty) return 'Email is required.';
              if (!v.contains('@')) return 'Enter a valid email.';
              return null;
            },
          ),
          if (roleName.isNotEmpty) ...[
            _label('Role'),
            _field(controller: _roleController, readOnly: true),
          ],
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 110,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF3D7F), Color(0xFFE91E63)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 18, offset: Offset(0, 10)),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: _saving ? null : _submit,
                  child: Center(
                    child: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Update',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 6),
        child: Text(text, style: widget._labelStyle),
      );

  Widget _field({
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: Colors.black87, fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _maritalStatusDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedMaritalStatus,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFE91E63)),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        final v = (value ?? '').trim();
        if (v.isEmpty) return 'Marital status is required.';
        return null;
      },
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      items: _maritalStatusOptions
          .map(
            (e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e, style: const TextStyle(color: Colors.black87, fontSize: 14)),
            ),
          )
          .toList(),
      onChanged: _saving
          ? null
          : (value) {
              setState(() {
                _selectedMaritalStatus = value;
                _maritalStatusController.text = value ?? '';
              });
            },
    );
  }
}
