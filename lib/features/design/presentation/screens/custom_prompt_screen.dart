import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:room_ai/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/router/app_router.dart';
import 'package:room_ai/core/widgets/gradient_button.dart';
import 'package:room_ai/features/design/providers/design_provider.dart';

class CustomPromptScreen extends ConsumerStatefulWidget {
  const CustomPromptScreen({super.key});

  @override
  ConsumerState<CustomPromptScreen> createState() =>
      _CustomPromptScreenState();
}

class _CustomPromptScreenState extends ConsumerState<CustomPromptScreen> {
  late final TextEditingController _controller;

  static const List<String> _suggestionKeys = [
    'chipNaturalLight',
    'chipPlants',
    'chipMinimalist',
    'chipWarmTones',
    'chipCoolTones',
    'chipOpenSpace',
    'chipCozy',
    'chipLargeWindows',
  ];

  @override
  void initState() {
    super.initState();
    final existingPrompt = ref.read(designFlowProvider).customPrompt;
    _controller = TextEditingController(text: existingPrompt ?? '');
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getSuggestionText(AppLocalizations l10n, String key) {
    switch (key) {
      case 'chipNaturalLight':
        return l10n.chipNaturalLight;
      case 'chipPlants':
        return l10n.chipPlants;
      case 'chipMinimalist':
        return l10n.chipMinimalist;
      case 'chipWarmTones':
        return l10n.chipWarmTones;
      case 'chipCoolTones':
        return l10n.chipCoolTones;
      case 'chipOpenSpace':
        return l10n.chipOpenSpace;
      case 'chipCozy':
        return l10n.chipCozy;
      case 'chipLargeWindows':
        return l10n.chipLargeWindows;
      default:
        return key;
    }
  }

  bool _isChipSelected(String chipText) {
    return _controller.text.contains(chipText);
  }

  void _toggleChip(String chipText) {
    final currentText = _controller.text;
    if (currentText.contains(chipText)) {
      // Remove chip text
      final newText = currentText
          .replaceAll(chipText, '')
          .replaceAll(RegExp(r',\s*,'), ',')
          .replaceAll(RegExp(r'^\s*,\s*'), '')
          .replaceAll(RegExp(r'\s*,\s*$'), '')
          .trim();
      _controller.text = newText;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    } else {
      // Append chip text
      if (currentText.isNotEmpty && currentText.trim().isNotEmpty) {
        _controller.text = '${currentText.trim()}, $chipText';
      } else {
        _controller.text = chipText;
      }
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  void _onGenerate() {
    ref
        .read(designFlowProvider.notifier)
        .setCustomPrompt(_controller.text.trim());
    context.push(RoutePaths.generating);
  }

  void _onSkip() {
    context.push(RoutePaths.generating);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final designState = ref.watch(designFlowProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.customize, style: AppTypography.h3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top info row: thumbnail + style + room type ──────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Thumbnail of selected image
                  if (designState.imagePath != null)
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusFull),
                      child: Image.file(
                        File(designState.imagePath!),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  // Style chip
                  if (designState.selectedStyle != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Text(
                        designState.selectedStyle!.name,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.primaryLight),
                      ),
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  // Room type chip
                  if (designState.selectedRoomType != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Text(
                        designState.selectedRoomType!.name,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.primaryLight),
                      ),
                    ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            // ── Scrollable content ───────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),

                    // ── Text field ───────────────────────────────────
                    TextField(
                      controller: _controller,
                      maxLines: 4,
                      style: AppTypography.bodyMedium,
                      decoration: InputDecoration(
                        hintText: l10n.addCustomInstructions,
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        filled: true,
                        fillColor: AppColors.bgCard,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                          borderSide:
                              const BorderSide(color: AppColors.surfaceBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                          borderSide:
                              const BorderSide(color: AppColors.surfaceBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusLg),
                          borderSide:
                              const BorderSide(color: AppColors.primary),
                        ),
                        contentPadding: const EdgeInsets.all(AppSpacing.md),
                      ),
                    ).animate().fadeIn(duration: 500.ms),

                    const SizedBox(height: AppSpacing.lg),

                    // ── Suggestions label ────────────────────────────
                    Text(
                      l10n.suggestions,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // ── Suggestion chips ─────────────────────────────
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: _suggestionKeys.map((key) {
                        final text = _getSuggestionText(l10n, key);
                        final isSelected = _isChipSelected(text);

                        return ActionChip(
                          label: Text(
                            text,
                            style: AppTypography.bodySmall.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                          backgroundColor: isSelected
                              ? AppColors.primary
                              : AppColors.bgCard,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.surfaceBorder,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          onPressed: () => _toggleChip(text),
                        );
                      }).toList(),
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),

            // ── Bottom buttons ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  GradientButton(
                    text: l10n.generateDesign,
                    onPressed: _onGenerate,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: _onSkip,
                    child: Text(
                      l10n.skipCustomize,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
