import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';
import '../services/health_profile_service.dart';
import 'bse_marking_screen.dart';
import '../core/utils/helpers.dart';
import 'bse_finding_detail_screen.dart';

class BseFindingsScreen extends StatefulWidget {
  final String patientId;

  const BseFindingsScreen({
    super.key,
    required this.patientId,
  });

  @override
  State<BseFindingsScreen> createState() => _BseFindingsScreenState();
}

class _BseFindingsScreenState extends State<BseFindingsScreen> {
  Future<List<Map<String, dynamic>>> _bseFindingsFuture = Future.value(<Map<String, dynamic>>[]);
  bool _savingLatest = false;

  @override
  void initState() {
    super.initState();
    _bseFindingsFuture = _loadBseFindings();
  }

  void _refreshRecords() {
    setState(() {
      _bseFindingsFuture = _loadBseFindings();
    });
  }

  Future<List<Map<String, dynamic>>> _loadBseFindings() async {
    final patientId = widget.patientId.trim();
    if (patientId.isEmpty) return <Map<String, dynamic>>[];

    final res = await HealthProfileService.fetchBseFindings(patientId: patientId);
    final statusCode = res['statusCode'];
    final isOk = statusCode == 200 || statusCode == 201;
    if (!isOk) return <Map<String, dynamic>>[];

    final data = res['data'];
    if (data is! List) return <Map<String, dynamic>>[];

    return data
        .whereType<Map>()
        .map((m) => m.map((key, value) => MapEntry(key.toString(), value)))
        .toList();
  }

  String? _idFromRecord(Map<String, dynamic> record) {
    final raw = record['id'];
    if (raw == null) return null;
    if (raw is String && raw.trim().isNotEmpty) return raw.trim();
    if (raw is num) return raw.toString();
    return null;
  }

  Future<void> _saveNewFinding(BseMarkingResult result) async {
    if (_savingLatest) return;

    final userId = widget.patientId.trim();
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to continue: missing user id.')),
      );
      return;
    }

    final markedPath = result.markedImagePath?.trim();
    if (markedPath == null || markedPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save: missing marked image.')),
      );
      return;
    }

    setState(() {
      _savingLatest = true;
    });

    try {
      final res = await HealthProfileService.createBseFinding(
        patientId: userId,
        baseFindings: result.toSummaryString(),
        markedImagePath: markedPath,
      );

      final statusCode = res['statusCode'];
      final ok = statusCode == 200 || statusCode == 201;
      if (!ok) {
        final raw = (res['message'] ?? res['raw'] ?? 'Failed to save.').toString();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(raw)));
        return;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved successfully.')),
      );
      _refreshRecords();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingLatest = false;
        });
      }
    }
  }

  Future<void> _markNewFinding() async {
    if (_savingLatest) return;

    final userId = widget.patientId.trim();
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to continue: missing user id.')),
      );
      return;
    }

    final result = await Navigator.of(context).push<BseMarkingResult>(
      MaterialPageRoute(builder: (_) => const BseMarkingScreen()),
    );

    if (!mounted) return;
    if (result == null) return;

    final markedPath = result.markedImagePath?.trim();
    if (markedPath == null || markedPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to save: missing marked image.')),
      );
      return;
    }

    setState(() {
      _savingLatest = true;
    });

    try {
      await _saveNewFinding(result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingLatest = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BaseScreen(
        title: 'SCHEDULE',
        showTitleInTopBar: true,
        content: Column(
          children: [
            const TabBar(
              labelColor: Color(0xFFE91E63),
              unselectedLabelColor: Colors.black54,
              indicatorColor: Color(0xFFE91E63),
              tabs: [
                Tab(text: 'Mark Findings'),
                Tab(text: 'View Findings'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Stack(
                    children: [
                      BseMarkingEditor(
                        showScheduleHeader: false,
                        onSave: (result) => _saveNewFinding(result),
                      ),
                      if (_savingLatest)
                        const Positioned.fill(
                          child: ColoredBox(
                            color: Color(0x66FFFFFF),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                    ],
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _bseFindingsFuture,
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: records.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final r = records[index];
                          final createdAt = Helpers.formatApiDateString(r['created_at']);
                          final notes = (r['notes'] ?? '').toString().trim();
                          final baseFindings = (r['base_findings'] ?? '').toString().trim();
                          final subtitle = [
                            if (createdAt.isNotEmpty) createdAt,
                            if (notes.isNotEmpty) notes,
                          ].join('  •  ');

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFE91E63),
                                foregroundColor: Colors.white,
                                child: Icon(Icons.event_note),
                              ),
                              title: Text(
                                baseFindings.isEmpty ? 'BSE Finding #${index + 1}' : baseFindings,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(subtitle.isEmpty ? '-' : subtitle),
                              onTap: () async {
                                final patientId = widget.patientId.trim();
                                if (patientId.isEmpty) return;

                                final changed = await Navigator.of(context).push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => BseFindingDetailScreen(
                                      finding: r,
                                      patientId: patientId,
                                    ),
                                  ),
                                );

                                if (!mounted) return;
                                if (changed == true) {
                                  _refreshRecords();
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
