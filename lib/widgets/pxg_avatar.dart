import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../intelligence_service.dart';

class PXGAvatar extends StatefulWidget {
  final String? id;
  final IconData? icon;
  final double size;
  final Color? color;

  const PXGAvatar({
    super.key,
    required this.id,
    this.icon,
    this.size = 60,
    this.color,
  });

  @override
  State<PXGAvatar> createState() => _PXGAvatarState();
}

class _PXGAvatarState extends State<PXGAvatar> {
  late Future<Uint8List?> _avatarFuture;

  @override
  void initState() {
    super.initState();
    _avatarFuture = _loadAvatar();
  }

  @override
  void didUpdateWidget(PXGAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      setState(() {
        _avatarFuture = _loadAvatar();
      });
    }
  }

  Future<Uint8List?> _loadAvatar() {
    if (widget.id == null || widget.id!.isEmpty || widget.id == 'N/A') {
      return Future.value(null);
    }
    return IntelligenceService.fetchAvatar(widget.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: (widget.color ?? Colors.white).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: FutureBuilder<Uint8List?>(
        future: _avatarFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildPlaceholder(isLoading: true);
          }

          if (snapshot.hasData && snapshot.data != null) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
            ).animate().fadeIn(duration: 400.ms);
          }

          return _buildPlaceholder(isLoading: false);
        },
      ),
    );
  }

  Widget _buildPlaceholder({required bool isLoading}) {
    return Center(
      child: isLoading
          ? SizedBox(
              width: widget.size * 0.4,
              height: widget.size * 0.4,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: widget.color ?? Colors.white.withOpacity(0.5),
              ),
            )
          : Icon(
              widget.icon ?? Icons.person,
              color: Colors.white.withOpacity(0.5),
              size: widget.size * 0.5,
            ),
    );
  }
}
