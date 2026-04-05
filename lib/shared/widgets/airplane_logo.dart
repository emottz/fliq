import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AirplaneLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AirplaneLogo({super.key, this.size = 48, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(size * 0.22),
          ),
          child: Icon(Icons.flight, color: Colors.white, size: size * 0.55),
        ),
        if (showText) ...[
          const SizedBox(height: 8),
          const Text(
            'FLIQ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: 3,
            ),
          ),
          const Text(
            'Aviation English',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
        ],
      ],
    );
  }
}
