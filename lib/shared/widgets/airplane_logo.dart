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
            borderRadius: BorderRadius.circular(size * 0.27),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.30),
                blurRadius: size * 0.35,
                offset: Offset(0, size * 0.1),
              ),
            ],
          ),
          child: Icon(Icons.flight, color: Colors.white, size: size * 0.56),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.18),
          Text(
            'FLIQ',
            style: TextStyle(
              fontSize: size * 0.46,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: size * 0.07,
              height: 1.0,
            ),
          ),
          SizedBox(height: size * 0.05),
          Text(
            'Havacılık İngilizcesi',
            style: TextStyle(
              fontSize: size * 0.22,
              color: AppColors.textSecondary,
              letterSpacing: size * 0.03,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
