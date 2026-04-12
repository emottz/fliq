import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AirplaneLogo extends StatelessWidget {
  final double size;
  final bool showText;
  /// Yatay mod: ikon ve metin yan yana, subtitle gösterilmez.
  /// Ana sayfa header gibi dar alanlarda kullan.
  final bool horizontal;

  const AirplaneLogo({
    super.key,
    this.size = 48,
    this.showText = true,
    this.horizontal = false,
  });

  Widget _icon() => Container(
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
      );

  @override
  Widget build(BuildContext context) {
    if (horizontal) {
      // Yatay: ikon + "Avialish" yan yana, tek satır
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _icon(),
          if (showText) ...[
            SizedBox(width: size * 0.22),
            Text(
              'Avialish',
              style: TextStyle(
                fontSize: size * 0.50,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                letterSpacing: size * 0.02,
                height: 1.0,
              ),
            ),
          ],
        ],
      );
    }

    // Dikey (varsayılan): ikon üstte, metinler altta
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _icon(),
        if (showText) ...[
          SizedBox(height: size * 0.18),
          Text(
            'Avialish',
            style: TextStyle(
              fontSize: size * 0.28,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: size * 0.02,
              height: 1.0,
            ),
          ),
          SizedBox(height: size * 0.05),
          Text(
            'Aviation English',
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
