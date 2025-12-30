import 'package:flutter/material.dart';

import '../widgets/base_screen.dart';
import '../services/health_profile_service.dart';
import 'health_profile_screen.dart';

class HealthHistoryDetailScreen extends StatefulWidget {
  final Map<String, dynamic> record;

  const HealthHistoryDetailScreen({super.key, required this.record});

  @override
  State<HealthHistoryDetailScreen> createState() => _HealthHistoryDetailScreenState();
}

class _HealthHistoryDetailScreenState extends State<HealthHistoryDetailScreen> {
  bool _deleting = false;

  Map<String, dynamic> get record => widget.record;

  String _value(String key) => (record[key] ?? '').toString();

  String? _id() {
    final raw = record['id'];
    if (raw == null) return null;
    if (raw is String && raw.trim().isNotEmpty) return raw.trim();
    if (raw is num) return raw.toString();
    return null;
  }

  String _formatCreatedAt(String createdAt) {
    if (createdAt.isEmpty) return '';
    final normalized = createdAt.replaceFirst(' ', 'T');
    final dt = DateTime.tryParse(normalized);
    if (dt == null) return createdAt;
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString();
    final hh = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy  $hh:$min';
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value.isEmpty ? '-' : value),
          ),
        ],
      ),
    );
  }

  Future<void> _edit() async {
    final id = _id();
    if (id == null || id.trim().isEmpty) return;

    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => HealthProfileScreen(
          initialRecord: record,
          healthProfileId: id,
        ),
      ),
    );

    if (!mounted) return;
    if (changed == true) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _delete() async {
    final id = _id();
    if (id == null || id.trim().isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete this health profile?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() {
      _deleting = true;
    });

    try {
      final res = await HealthProfileService.deleteHealthProfile(id: id);
      final statusCode = res['statusCode'];
      final ok = statusCode == 200 || statusCode == 201 || statusCode == 204;
      if (!mounted) return;
      if (!ok) {
        final raw = (res['message'] ?? res['raw'] ?? 'Failed to delete.').toString();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(raw)));
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleted successfully.')),
      );
      Navigator.of(context).pop(true);
    } finally {
      if (mounted) {
        setState(() {
          _deleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final createdAt = _formatCreatedAt(_value('created_at'));
    final markedImageUrl = _value('marked_image');

    return BaseScreen(
      title: 'HEALTH DETAILS',
      showTitleInTopBar: false,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Text(
              'HEALTH DETAILS',
              style: TextStyle(
                color: Color(0xFFE91E63),
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailRow('Created At', createdAt),
                        _detailRow('Patient Name', _value('patient_name')),
                        _detailRow('Patient Email', _value('patient_email')),
                        _detailRow('Height (cm)', _value('height')),
                        _detailRow('BP Upper', _value('bp_upper')),
                        _detailRow('BP Lower', _value('bp_lower')),
                        _detailRow('Recent Pap Smear', _value('recent_pap_smear')),
                        _detailRow('Recent Mammography', _value('recent_mammography')),
                        _detailRow('Gyn Visit', _value('gyn_visit')),
                        _detailRow('Period', _value('period')),
                        _detailRow('BSE Findings', _value('base_findings')),
                        const SizedBox(height: 16),
                        if (markedImageUrl.trim().isNotEmpty) ...[
                          const Text(
                            'Marked Image',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                markedImageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Text('Failed to load image'),
                                ),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _deleting ? null : _edit,
                                  child: const Text('Edit'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _deleting ? null : _delete,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: _deleting
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text('Delete'),
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
