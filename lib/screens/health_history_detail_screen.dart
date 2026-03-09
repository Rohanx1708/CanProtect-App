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
  late Future<Map<String, dynamic>> _detailFuture;

  Map<String, dynamic> get record => widget.record;

  String? _id() {
    final raw = record['id'];
    if (raw == null) return null;
    if (raw is String && raw.trim().isNotEmpty) return raw.trim();
    if (raw is num) return raw.toString();
    return null;
  }

  @override
  void initState() {
    super.initState();
    _detailFuture = _loadDetail();
  }

  Future<Map<String, dynamic>> _loadDetail() async {
    final id = _id();
    if (id == null || id.trim().isEmpty) return <String, dynamic>{};
    return HealthProfileService.fetchHealthProfileById(id: id);
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

  Future<void> _delete() async {
    final id = _id();
    if (id == null || id.trim().isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text(
            'Delete',
            style: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'Are you sure you want to delete this health profile?',
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
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
    return BaseScreen(
      title: 'HEALTH DETAILS',
      showTitleInTopBar: false,
      content: FutureBuilder<Map<String, dynamic>>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? <String, dynamic>{};
          final statusCode = data['statusCode'];
          final ok = statusCode == null || statusCode == 200 || statusCode == 201;

          Map<String, dynamic> detail = <String, dynamic>{};
          final raw = data['data'];
          if (raw is Map) {
            detail = raw.map((k, v) => MapEntry(k.toString(), v));
          }

          if (!ok || detail.isEmpty) {
            return const Center(
              child: Text(
                'Failed to load health details.',
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
            );
          }

          final markedImageUrl = (detail['marked_image'] ?? '').toString();
          final id = _id();

          return Padding(
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
                            _detailRow('Patient Name', (detail['patient_name'] ?? '').toString()),
                            _detailRow('Patient Email', (detail['patient_email'] ?? '').toString()),
                            _detailRow('Height (cm)', (detail['height'] ?? '').toString()),
                            _detailRow('BP Upper', (detail['bp_upper'] ?? '').toString()),
                            _detailRow('BP Lower', (detail['bp_lower'] ?? '').toString()),
                            _detailRow('Recent Pap Smear', (detail['recent_pap_smear'] ?? '').toString()),
                            _detailRow('Recent Mammography', (detail['recent_mammography'] ?? '').toString()),
                            _detailRow('Gyn Visit', (detail['gyn_visit'] ?? '').toString()),
                            _detailRow('Period', (detail['period'] ?? '').toString()),
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
                            ],
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: (id == null || id.trim().isEmpty)
                                        ? null
                                        : () async {
                                            final changed = await Navigator.of(context).push<bool>(
                                              MaterialPageRoute(
                                                builder: (_) => HealthProfileScreen(
                                                  initialRecord: detail,
                                                  healthProfileId: id,
                                                ),
                                              ),
                                            );

                                            if (!mounted) return;
                                            if (changed == true) {
                                              setState(() {
                                                _detailFuture = _loadDetail();
                                              });
                                            }
                                          },
                                    child: const Text('Update'),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
