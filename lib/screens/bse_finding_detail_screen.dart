import 'dart:io' as io;

import 'package:flutter/material.dart';
import '../core/utils/helpers.dart';
import '../services/health_profile_service.dart';
import '../widgets/base_screen.dart';
import 'bse_marking_screen.dart';

class BseFindingDetailScreen extends StatefulWidget {
  final Map<String, dynamic> finding;
  final String patientId;

  const BseFindingDetailScreen({
    super.key,
    required this.finding,
    required this.patientId,
  });

  @override
  State<BseFindingDetailScreen> createState() => _BseFindingDetailScreenState();
}

class _BseFindingDetailScreenState extends State<BseFindingDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _editing = false;
  bool _saving = false;

  late final TextEditingController _baseFindingsController;
  late final TextEditingController _notesController;

  String? _markedImagePath;
  bool _markedImageChanged = false;

  String _extractApiErrorMessage(Map<String, dynamic> res) {
    final message = (res['message'] ?? res['error'] ?? res['raw'] ?? '').toString().trim();

    final errors = res['errors'] ?? res['error_messages'] ?? res['data'];
    if (errors is Map) {
      final mapped = errors.map((k, v) => MapEntry(k.toString(), v));
      final parts = <String>[];
      for (final entry in mapped.entries) {
        final v = entry.value;
        if (v is List) {
          final joined = v.map((e) => e.toString()).where((s) => s.trim().isNotEmpty).join(', ');
          if (joined.isNotEmpty) parts.add('${entry.key}: $joined');
        } else if (v != null && v.toString().trim().isNotEmpty) {
          parts.add('${entry.key}: ${v.toString()}');
        }
      }
      if (parts.isNotEmpty) {
        return parts.join(' | ');
      }
    }

    if (errors is List) {
      final joined = errors.map((e) => e.toString()).where((s) => s.trim().isNotEmpty).join(', ');
      if (joined.isNotEmpty) return joined;
    }

    return message.isNotEmpty ? message : 'Failed to update.';
  }

  String? _findingId() {
    String? pick(dynamic raw) {
      if (raw == null) return null;
      if (raw is String && raw.trim().isNotEmpty) return raw.trim();
      if (raw is num) return raw.toString();
      return null;
    }

    final direct =
        pick(widget.finding['id']) ??
        pick(widget.finding['bseFinding_id']) ??
        pick(widget.finding['bseFindingId']) ??
        pick(widget.finding['bse_finding_id']) ??
        pick(widget.finding['bse_findingId']) ??
        pick(widget.finding['finding_id']) ??
        pick(widget.finding['findingId']);
    if (direct != null) return direct;

    final data = widget.finding['data'];
    if (data is Map) {
      final m = data.map((k, v) => MapEntry(k.toString(), v));
      return pick(m['id']) ??
          pick(m['bseFinding_id']) ??
          pick(m['bseFindingId']) ??
          pick(m['bse_finding_id']) ??
          pick(m['bse_findingId']) ??
          pick(m['finding_id']) ??
          pick(m['findingId']);
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _baseFindingsController = TextEditingController(
      text: (widget.finding['base_findings'] ?? '').toString(),
    );
    _notesController = TextEditingController(
      text: (widget.finding['notes'] ?? '').toString(),
    );
  }

  @override
  void dispose() {
    _baseFindingsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickNewMarkedImage() async {
    final result = await Navigator.of(context).push<BseMarkingResult>(
      MaterialPageRoute(builder: (_) => const BseMarkingScreen()),
    );

    if (!mounted) return;
    if (result == null) return;

    setState(() {
      _markedImagePath = result.markedImagePath;
      _markedImageChanged = true;
      final summary = result.toSummaryString().trim();
      if (summary.isNotEmpty) {
        _baseFindingsController.text = summary;
      }
    });
  }

  Future<void> _save() async {
    if (_saving) return;

    final id = _findingId();
    if (id == null || id.trim().isEmpty) return;

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() {
      _saving = true;
    });

    try {
      final patientId = widget.patientId.trim();
      if (patientId.isEmpty) return;

      final base = _baseFindingsController.text.trim();
      if (base.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Base findings is required. Please mark on image first.')),
        );
        return;
      }

      final res = await HealthProfileService.updateBseFinding(
        patientId: patientId,
        id: id,
        baseFindings: base,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        markedImagePath: _markedImagePath,
      );

      final statusCode = res['statusCode'];
      final success = statusCode == 200 || statusCode == 201;
      if (!success) {
        final raw = _extractApiErrorMessage(res);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$raw (patient_id=$patientId, finding_id=$id)',
            ),
          ),
        );
        return;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updated successfully.')),
      );
      Navigator.of(context).pop(true);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseFindings = (widget.finding['base_findings'] ?? '').toString().trim();
    final notes = (widget.finding['notes'] ?? '').toString().trim();
    final createdAt = Helpers.formatApiDateString(widget.finding['created_at']);
    final imageUrl = (widget.finding['marked_image'] ?? '').toString().trim();

    return BaseScreen(
      title: 'BSE FINDING',
      showTitleInTopBar: true,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _editing
                      ? Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Marked Image',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 12),
                              AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _markedImagePath != null && _markedImagePath!.trim().isNotEmpty
                                      ? Image.file(
                                          io.File(_markedImagePath!),
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => const Center(
                                            child: Text('Failed to load image'),
                                          ),
                                        )
                                      : (imageUrl.isNotEmpty
                                          ? Image.network(
                                              imageUrl,
                                              fit: BoxFit.contain,
                                              errorBuilder: (_, __, ___) => const Center(
                                                child: Text('Failed to load image'),
                                              ),
                                              loadingBuilder: (context, child, progress) {
                                                if (progress == null) return child;
                                                return const Center(child: CircularProgressIndicator());
                                              },
                                            )
                                          : const Center(child: Text('No image'))),
                                ),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton(
                                onPressed: _saving ? null : _pickNewMarkedImage,
                                child: Text(
                                  _markedImageChanged ? 'Edit Image' : 'Edit Image',
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _baseFindingsController,
                                maxLines: 4,
                                validator: (v) => (v ?? '').trim().isEmpty ? 'Base findings is required.' : null,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'Base Findings',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _notesController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Notes (optional)',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _saving
                                          ? null
                                          : () {
                                              setState(() {
                                                _editing = false;
                                              });
                                            },
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _saving ? null : _save,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFE91E63),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: _saving
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                          : const Text('Save'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (baseFindings.isNotEmpty) ...[
                              const Text(
                                'Base Findings',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 6),
                              Text(baseFindings),
                              const SizedBox(height: 12),
                            ],
                            if (notes.isNotEmpty) ...[
                              const Text(
                                'Notes',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 6),
                              Text(notes),
                              const SizedBox(height: 12),
                            ],
                            if (createdAt.isNotEmpty) ...[
                              const Text(
                                'Date',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 6),
                              Text(createdAt),
                              const SizedBox(height: 12),
                            ],
                            if (imageUrl.isNotEmpty) ...[
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
                                    imageUrl,
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
                            ],
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _editing = true;
                                      });
                                    },
                                    child: const Text('Update'),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
