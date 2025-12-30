import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../widgets/base_screen.dart';

enum BseMarkerType { lump, nippleDischarge, pain }

class BseMarker {
  final Offset normalizedPosition;
  final BseMarkerType type;
  final double radius;
  final double opacity;

  const BseMarker({
    required this.normalizedPosition,
    required this.type,
    required this.radius,
    required this.opacity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dx': normalizedPosition.dx,
      'dy': normalizedPosition.dy,
      'type': type.name,
      'radius': radius,
      'opacity': opacity,
    };
  }

  static BseMarker fromMap(Map<String, dynamic> map) {
    final dxRaw = map['dx'];
    final dyRaw = map['dy'];
    final typeRaw = map['type'];
    final radiusRaw = map['radius'];
    final opacityRaw = map['opacity'];

    final dx = (dxRaw is num) ? dxRaw.toDouble() : 0.0;
    final dy = (dyRaw is num) ? dyRaw.toDouble() : 0.0;
    final radius = (radiusRaw is num) ? radiusRaw.toDouble() : 7.0;
    final opacity = (opacityRaw is num) ? opacityRaw.toDouble() : 1.0;

    BseMarkerType type = BseMarkerType.lump;
    if (typeRaw is String) {
      for (final t in BseMarkerType.values) {
        if (t.name == typeRaw) {
          type = t;
          break;
        }
      }
    }

    return BseMarker(
      normalizedPosition: Offset(dx, dy),
      type: type,
      radius: radius,
      opacity: opacity,
    );
  }
}

class BseMarkingResult {
  final List<BseMarker> markers;
  final String? markedImagePath;

  const BseMarkingResult({required this.markers, this.markedImagePath});

  int countOf(BseMarkerType type) => markers.where((m) => m.type == type).length;

  String toSummaryString() {
    return 'Lump: ${countOf(BseMarkerType.lump)}, Nipple Discharge: ${countOf(BseMarkerType.nippleDischarge)}, Pain: ${countOf(BseMarkerType.pain)}';
  }
}

class BseMarkingScreen extends StatefulWidget {
  final List<BseMarker> initialMarkers;

  const BseMarkingScreen({super.key, this.initialMarkers = const []});

  @override
  State<BseMarkingScreen> createState() => _BseMarkingScreenState();
}

class _BseMarkingScreenState extends State<BseMarkingScreen> {
  static const String _assetPath = 'assets/images/bse_editing_img.png';

  final GlobalKey _captureKey = GlobalKey();

  late List<BseMarker> _markers;
  final List<BseMarker> _redoStack = [];

  BseMarkerType _selectedType = BseMarkerType.lump;
  double _brushRadius = 7;
  double _brushOpacity = 1;

  @override
  void initState() {
    super.initState();
    _markers = [...widget.initialMarkers];
  }

  void _addMarker(Offset localPosition, Size boxSize) {
    final dx = (localPosition.dx / boxSize.width).clamp(0.0, 1.0);
    final dy = (localPosition.dy / boxSize.height).clamp(0.0, 1.0);

    setState(() {
      _markers.add(
        BseMarker(
          normalizedPosition: Offset(dx, dy),
          type: _selectedType,
          radius: _brushRadius,
          opacity: _brushOpacity,
        ),
      );
      _redoStack.clear();
    });
  }

  void _openBrushSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Widget colorBox(BseMarkerType type) {
              final bool selected = _selectedType == type;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedType = type;
                  });
                  setModalState(() {});
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _colorFor(type),
                    borderRadius: BorderRadius.circular(6),
                    border: selected ? Border.all(color: Colors.black87, width: 2) : null,
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Brush',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFE91E63),
                      thumbColor: const Color(0xFFE91E63),
                      overlayColor: const Color(0xFFE91E63),
                      inactiveTrackColor: const Color(0xFFE91E63),
                    ),
                    child: Slider(
                      value: _brushRadius,
                      min: 3,
                      max: 18,
                      onChanged: (v) {
                        setState(() {
                          _brushRadius = v;
                        });
                        setModalState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Opacity',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFE91E63),
                      thumbColor: const Color(0xFFE91E63),
                      overlayColor: const Color(0xFFE91E63),
                      inactiveTrackColor: const Color(0xFFE91E63),
                    ),
                    child: Slider(
                      value: _brushOpacity,
                      min: 0.1,
                      max: 1,
                      onChanged: (v) {
                        setState(() {
                          _brushOpacity = v;
                        });
                        setModalState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      colorBox(BseMarkerType.lump),
                      const SizedBox(width: 10),
                      colorBox(BseMarkerType.nippleDischarge),
                      const SizedBox(width: 10),
                      colorBox(BseMarkerType.pain),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _undo() {
    if (_markers.isEmpty) return;
    setState(() {
      _redoStack.add(_markers.removeLast());
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      _markers.add(_redoStack.removeLast());
    });
  }

  Future<String?> _captureMarkedImageToTempFile() async {
    final boundary = _captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;

    final captureContext = _captureKey.currentContext;
    if (captureContext == null) return null;

    final pixelRatio = View.of(captureContext).devicePixelRatio;

    final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final Uint8List bytes = byteData.buffer.asUint8List();
    final String filename = 'bse_marked_${DateTime.now().millisecondsSinceEpoch}.png';
    final File file = File('${Directory.systemTemp.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Color _colorFor(BseMarkerType type) {
    switch (type) {
      case BseMarkerType.lump:
        return Colors.red;
      case BseMarkerType.nippleDischarge:
        return Colors.yellow;
      case BseMarkerType.pain:
        return Colors.lightBlue;
    }
  }

  String _labelFor(BseMarkerType type) {
    switch (type) {
      case BseMarkerType.lump:
        return 'LUMP';
      case BseMarkerType.nippleDischarge:
        return 'NIPPLE\nDISCHARGE';
      case BseMarkerType.pain:
        return 'PAIN';
    }
  }

  Widget _typeSelector(BseMarkerType type) {
    final bool selected = _selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _colorFor(type),
              border: selected ? Border.all(color: Colors.white, width: 3) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _labelFor(type),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'SCHEDULE',
      showTitleInTopBar: false,
      content: Align(
        alignment: const Alignment(0, -0.25),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'SCHEDULE',
                  style: TextStyle(
                    color: Color(0xFFE91E63),
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final double imageSize = constraints.maxWidth;

                          return SizedBox(
                            width: imageSize,
                            height: imageSize,
                            child: RepaintBoundary(
                              key: _captureKey,
                              child: Builder(
                                builder: (context) {
                                  return GestureDetector(
                                    onTapDown: (details) {
                                      final box = context.findRenderObject() as RenderBox?;
                                      if (box == null) return;
                                      _addMarker(details.localPosition, box.size);
                                    },
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Image.asset(
                                            _assetPath,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                                          ),
                                        ),
                                        ..._markers.map((m) {
                                          final double r = m.radius;
                                          final double left = m.normalizedPosition.dx * imageSize - r;
                                          final double top = m.normalizedPosition.dy * imageSize - r;

                                          return Positioned(
                                            left: left,
                                            top: top,
                                            child: Container(
                                              width: r * 2,
                                              height: r * 2,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _colorFor(m.type).withOpacity(m.opacity),
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _typeSelector(BseMarkerType.lump),
                          _typeSelector(BseMarkerType.nippleDischarge),
                          _typeSelector(BseMarkerType.pain),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: _openBrushSheet,
                            icon: const Icon(Icons.edit, color: Colors.black87),
                          ),
                          IconButton(
                            onPressed: _markers.isEmpty ? null : _undo,
                            icon: const Icon(Icons.undo, color: Colors.black87),
                          ),
                          IconButton(
                            onPressed: _redoStack.isEmpty ? null : _redo,
                            icon: const Icon(Icons.redo, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final navigator = Navigator.of(context);
                            final String? path = await _captureMarkedImageToTempFile();
                            if (!mounted) return;
                            navigator.pop(BseMarkingResult(markers: _markers, markedImagePath: path));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
