import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLoading extends StatelessWidget {
  final double size;
  final String? text;
  final Color? backgroundColor;
  final double strokeWidth;

  const AppLoading({
    super.key,
    this.size = 44,
    this.text,
    this.backgroundColor,
    this.strokeWidth = 3.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: const AlwaysStoppedAnimation(AppTheme.primaryColor),
            ),
          ),
          if (text != null) ...[
            const SizedBox(height: 12),
            Text(
              text!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
