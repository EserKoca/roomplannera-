import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_spacing.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final LinearGradient? gradient;
  final bool isLoading;
  final double? width;
  final double? height;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? AppSpacing.buttonHeight,
      decoration: BoxDecoration(
        gradient: onPressed != null
            ? (gradient ?? AppColors.premiumGradient)
            : const LinearGradient(
                colors: [Color(0xFF3A3A5C), Color(0xFF2A2A4C)]),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.textPrimary,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(text, style: AppTypography.buttonText),
          ),
        ),
      ),
    );
  }
}
