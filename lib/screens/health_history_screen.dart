import 'package:flutter/material.dart';

import '../widgets/base_screen.dart';
import 'health_history_detail_screen.dart';
import '../services/health_profile_service.dart';

class HealthHistoryScreen extends StatefulWidget {
  const HealthHistoryScreen({super.key});

  @override
  State<HealthHistoryScreen> createState() => _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends State<HealthHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _recordsFuture = _loadRecords();
  }

  Future<List<Map<String, dynamic>>> _loadRecords() async {
    final response = await HealthProfileService.fetchHealthProfiles(page: 1);
    final statusCode = response['statusCode'];
    final isOk = statusCode == 200 || statusCode == 201;
    if (!isOk) return <Map<String, dynamic>>[];

    final data = response['data'];
    if (data is! Map) return <Map<String, dynamic>>[];

    final list = data['data'];
    if (list is! List) return <Map<String, dynamic>>[];

    return list
        .whereType<Map>()
        .map((m) => m.map((key, value) => MapEntry(key.toString(), value)))
        .toList();
  }

  String _formatCreatedAt(dynamic createdAt) {
    if (createdAt is! String || createdAt.isEmpty) return '';
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

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'HEALTH HISTORY',
      showTitleInTopBar: false,
      content: Column(
        children: [
          const Text(
            'HEALTH HISTORY',
            style: TextStyle(
              color: Color(0xFFE91E63),
              fontWeight: FontWeight.w700,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _recordsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                final records = snapshot.data ?? <Map<String, dynamic>>[];
                if (records.isEmpty) {
                  return const Center(
                    child: Text(
                      'No health records found.',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final r = records[index];
                    final createdAt = _formatCreatedAt(r['created_at']);
                    final subtitle = createdAt.isEmpty ? '-' : createdAt;
                    final patientName = (r['patient_name'] ?? '').toString().trim();

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          child: Icon(Icons.health_and_safety),
                        ),
                        title: Text(
                          patientName.isEmpty ? 'Health Profile #${index + 1}' : patientName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(subtitle),
                        onTap: () async {
                          final changed = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => HealthHistoryDetailScreen(record: r),
                            ),
                          );

                          if (changed == true) {
                            setState(() {
                              _recordsFuture = _loadRecords();
                            });
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
