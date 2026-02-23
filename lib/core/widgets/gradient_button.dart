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
    final isEnabled = onPressed != null;

    return Container(
      width: width ?? double.infinity,
      height: height ?? AppSpacing.buttonHeight,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? (gradient ?? AppColors.premiumGradient)
            : LinearGradient(
                colors: [
                  AppColors.warmGray,
                  AppColors.warmGrayLight,
                ],
              ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
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
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    text,
                    style: AppTypography.buttonText.copyWith(
                      color: isEnabled ? Colors.white : AppColors.textTertiary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
