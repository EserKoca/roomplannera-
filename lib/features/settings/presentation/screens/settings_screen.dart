import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/constants/api_constants.dart';
import 'package:room_ai/core/widgets/glass_card.dart';
import 'package:room_ai/core/widgets/gradient_button.dart';
import 'package:room_ai/features/design/data/repositories/design_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(designRepositoryProvider);
    final designCount = repository.getDesignCount();
    final isPremium =
        Hive.box('settings').get('is_premium', defaultValue: false) as bool;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar area
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Text('Settings', style: AppTypography.h2),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Account Section ──
                  const SizedBox(height: AppSpacing.sm),
                  const _SectionLabel(label: 'Account'),
                  const SizedBox(height: AppSpacing.sm),
                  GlassCard(
                    child: Column(
                      children: [
                        _SettingsRow(
                          icon: Icons.workspace_premium_rounded,
                          iconColor: AppColors.accent,
                          label: 'Subscription',
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: isPremium
                                  ? AppColors.primary.withValues(alpha: 0.12)
                                  : AppColors.warmGray.withValues(alpha: 0.5),
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusSm),
                            ),
                            child: Text(
                              isPremium ? 'Pro' : 'Free',
                              style: AppTypography.labelMedium.copyWith(
                                color: isPremium
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const _Divider(),
                        _SettingsRow(
                          icon: Icons.design_services_rounded,
                          iconColor: AppColors.primaryLight,
                          label: 'Designs Used',
                          trailing: Text(
                            isPremium
                                ? '$designCount (Unlimited)'
                                : '$designCount / ${ApiConstants.maxFreeDesigns}',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── API Key Section ──
                  const SizedBox(height: AppSpacing.lg),
                  const _SectionLabel(label: 'API Key'),
                  const SizedBox(height: AppSpacing.sm),
                  const _ApiKeySection(),

                  // ── Preferences Section ──
                  const SizedBox(height: AppSpacing.lg),
                  const _SectionLabel(label: 'Preferences'),
                  const SizedBox(height: AppSpacing.sm),
                  GlassCard(
                    child: Column(
                      children: [
                        _SettingsRow(
                          icon: Icons.language_rounded,
                          iconColor: AppColors.primary,
                          label: 'Language',
                          trailing: _LanguageToggle(),
                        ),
                        const _Divider(),
                        _SettingsRow(
                          icon: Icons.light_mode_rounded,
                          iconColor: AppColors.energyYellow,
                          label: 'Theme',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Light',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusSm),
                                ),
                                child: Text(
                                  'Active',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.accent,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Support Section ──
                  const SizedBox(height: AppSpacing.lg),
                  const _SectionLabel(label: 'Support'),
                  const SizedBox(height: AppSpacing.sm),
                  GlassCard(
                    child: Column(
                      children: [
                        _SettingsRow(
                          icon: Icons.star_rounded,
                          iconColor: AppColors.energyYellow,
                          label: 'Rate Us',
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textTertiary,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('App Store rating coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        const _Divider(),
                        _SettingsRow(
                          icon: Icons.mail_rounded,
                          iconColor: AppColors.primary,
                          label: 'Contact Us',
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textTertiary,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Contact support coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        const _Divider(),
                        _SettingsRow(
                          icon: Icons.privacy_tip_rounded,
                          iconColor: AppColors.textSecondary,
                          label: 'Privacy Policy',
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textTertiary,
                          ),
                          onTap: () {},
                        ),
                        const _Divider(),
                        _SettingsRow(
                          icon: Icons.description_rounded,
                          iconColor: AppColors.textSecondary,
                          label: 'Terms of Service',
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textTertiary,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  // ── Danger Zone Section ──
                  const SizedBox(height: AppSpacing.lg),
                  const _SectionLabel(label: 'Danger Zone'),
                  const SizedBox(height: AppSpacing.sm),
                  GlassCard(
                    child: Column(
                      children: [
                        _SettingsRow(
                          icon: Icons.warning_amber_rounded,
                          iconColor: AppColors.error,
                          label: 'Clear Gallery',
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textTertiary,
                          ),
                          onTap: () =>
                              _showClearGalleryDialog(context, ref),
                        ),
                        const _Divider(),
                        _SettingsRow(
                          icon: Icons.restore_rounded,
                          iconColor: AppColors.textSecondary,
                          label: 'Restore Purchases',
                          trailing: const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textTertiary,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Restore purchases coming soon'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // ── Footer ──
                  const SizedBox(height: AppSpacing.xl),
                  Center(
                    child: Text(
                      'RoomAI v1.0.0',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearGalleryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        title: Text('Clear Gallery', style: AppTypography.h3),
        content: Text(
          'Are you sure you want to delete all designs? This action cannot be undone.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final repository = ref.read(designRepositoryProvider);
              await repository.clearAll();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gallery cleared'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text(
              'Clear All',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section Label ──
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.labelLarge.copyWith(
        color: AppColors.textTertiary,
        fontSize: 13,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ── Settings Row ──
class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(label, style: AppTypography.bodyLarge),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

// ── Divider ──
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Divider(
        color: AppColors.warmGray.withValues(alpha: 0.4),
        height: 1,
      ),
    );
  }
}

// ── API Key Section (ConsumerStatefulWidget for reactive API key) ──
class _ApiKeySection extends ConsumerStatefulWidget {
  const _ApiKeySection();

  @override
  ConsumerState<_ApiKeySection> createState() => _ApiKeySectionState();
}

class _ApiKeySectionState extends ConsumerState<_ApiKeySection> {
  late final TextEditingController _apiKeyController;
  final _settingsBox = Hive.box('settings');

  bool _isValidating = false;
  _ValidationState _validationState = _ValidationState.none;

  @override
  void initState() {
    super.initState();
    final savedKey =
        _settingsBox.get('openai_api_key', defaultValue: '') as String;
    _apiKeyController = TextEditingController(text: savedKey);
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveApiKey() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) {
      // Clear the key
      _settingsBox.put('openai_api_key', '');
      ref.read(apiKeyProvider.notifier).state = '';
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('API key cleared'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Validate the key
    setState(() {
      _isValidating = true;
      _validationState = _ValidationState.none;
    });

    try {
      // Save first so the provider chain rebuilds
      _settingsBox.put('openai_api_key', key);
      ref.read(apiKeyProvider.notifier).state = key;

      final openAIService = ref.read(openAIServiceProvider);
      final isValid = await openAIService.validateApiKey();

      if (!mounted) return;

      if (isValid) {
        setState(() {
          _validationState = _ValidationState.valid;
          _isValidating = false;
        });
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: 20),
                const SizedBox(width: 8),
                const Text('API key verified and saved'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        setState(() {
          _validationState = _ValidationState.invalid;
          _isValidating = false;
        });
        // Clear the invalid key
        _settingsBox.put('openai_api_key', '');
        ref.read(apiKeyProvider.notifier).state = '';
      }
    } catch (e) {
      if (!mounted) return;
      // Network error during validation - save the key anyway
      _settingsBox.put('openai_api_key', key);
      ref.read(apiKeyProvider.notifier).state = key;
      setState(() {
        _validationState = _ValidationState.networkError;
        _isValidating = false;
      });
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Key saved but could not validate (network error)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.key_rounded, size: 22, color: AppColors.accent),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child:
                    Text('OpenAI API Key', style: AppTypography.bodyLarge),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _apiKeyController,
            obscureText: true,
            style: AppTypography.bodyMedium,
            onChanged: (_) {
              if (_validationState != _ValidationState.none) {
                setState(() => _validationState = _ValidationState.none);
              }
            },
            decoration: InputDecoration(
              hintText: 'sk-...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              filled: true,
              fillColor: AppColors.bgTertiary,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: _getBorderColor()),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(color: _getBorderColor()),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide(
                  color: _validationState == _ValidationState.invalid
                      ? AppColors.error
                      : AppColors.primary,
                ),
              ),
              suffixIcon: _buildSuffixIcon(),
            ),
          ),

          // Validation message
          if (_validationState == _ValidationState.invalid)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                'Invalid API key. Please check and try again.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),

          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 120,
              child: GradientButton(
                text: _isValidating ? 'Validating...' : 'Save',
                height: AppSpacing.buttonHeightSmall,
                onPressed: _isValidating ? null : _saveApiKey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBorderColor() {
    switch (_validationState) {
      case _ValidationState.valid:
        return AppColors.success;
      case _ValidationState.invalid:
        return AppColors.error;
      case _ValidationState.networkError:
        return AppColors.accent;
      case _ValidationState.none:
        return AppColors.warmGray.withValues(alpha: 0.4);
    }
  }

  Widget? _buildSuffixIcon() {
    if (_isValidating) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      );
    }
    switch (_validationState) {
      case _ValidationState.valid:
        return const Icon(Icons.check_circle_rounded,
            color: AppColors.success);
      case _ValidationState.invalid:
        return const Icon(Icons.error_outline_rounded,
            color: AppColors.error);
      case _ValidationState.networkError:
        return const Icon(Icons.warning_amber_rounded,
            color: AppColors.accent);
      case _ValidationState.none:
        return null;
    }
  }
}

enum _ValidationState { none, valid, invalid, networkError }

// ── Language Toggle ──
class _LanguageToggle extends StatefulWidget {
  @override
  State<_LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<_LanguageToggle> {
  late String _currentLanguage;
  final _settingsBox = Hive.box('settings');

  @override
  void initState() {
    super.initState();
    _currentLanguage =
        _settingsBox.get('language', defaultValue: 'en') as String;
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'en' ? 'tr' : 'en';
    });
    _settingsBox.put('language', _currentLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLanguage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border:
              Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Text(
          _currentLanguage == 'en' ? 'English' : 'Turkce',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
