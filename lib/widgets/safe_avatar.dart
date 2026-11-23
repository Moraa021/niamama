import 'package:flutter/material.dart';

/// Circle avatar that loads a network image but degrades gracefully offline:
/// when the image is missing or fails to load, [fallback] is shown instead.
class SafeAvatar extends StatefulWidget {
  final String? url;
  final double radius;
  final Color? backgroundColor;
  final Widget fallback;

  const SafeAvatar({
    super.key,
    required this.url,
    required this.radius,
    required this.fallback,
    this.backgroundColor,
  });

  @override
  State<SafeAvatar> createState() => _SafeAvatarState();
}

class _SafeAvatarState extends State<SafeAvatar> {
  bool _failed = false;

  @override
  void didUpdateWidget(SafeAvatar old) {
    super.didUpdateWidget(old);
    if (old.url != widget.url) _failed = false;
  }

  @override
  Widget build(BuildContext context) {
    final showImage = widget.url != null && !_failed;
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: widget.backgroundColor,
      backgroundImage: showImage ? NetworkImage(widget.url!) : null,
      onBackgroundImageError: showImage
          ? (_, __) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_failed) setState(() => _failed = true);
              });
            }
          : null,
      child: showImage ? null : widget.fallback,
    );
  }
}
