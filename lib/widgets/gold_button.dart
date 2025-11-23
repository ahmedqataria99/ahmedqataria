import 'package:flutter/material.dart';
import '../theme.dart';

// A reusable gold-styled button with a decorative shape beside it.
class GoldButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool showDecorative;
  final EdgeInsetsGeometry? padding;

  const GoldButton({
    super.key,
    required this.label,
    this.onPressed,
    this.showDecorative = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          style: AppButtonStyles.goldElevated,
          onPressed: onPressed,
          child: Padding(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
        ),
        if (showDecorative) const SizedBox(width: 8),
        if (showDecorative)
          // decorative rotated square (diamond) in gold with a small white center
          Transform.rotate(
            angle: 0.785398, // 45 degrees
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: ThemeColors.gold,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Center(
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: ThemeColors.background,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
