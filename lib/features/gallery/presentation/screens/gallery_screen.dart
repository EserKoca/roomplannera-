import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:room_ai/core/constants/app_colors.dart';
import 'package:room_ai/core/constants/app_typography.dart';
import 'package:room_ai/core/constants/app_spacing.dart';
import 'package:room_ai/core/router/app_router.dart';
import 'package:room_ai/core/widgets/gradient_button.dart';
import 'package:room_ai/features/design/data/repositories/design_repository.dart';
import 'package:room_ai/features/design/providers/design_provider.dart';

class GalleryScreen extends ConsumerStatefulWidget {
  const GalleryScreen({super.key});

  @override
  ConsumerState<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends ConsumerState<GalleryScreen> {
  List<DesignResult> _designs = [];
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _loadDesigns();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when returning to this screen
    _loadDesigns();
  }

  void _loadDesigns() {
    final repository = ref.read(designRepositoryProvider);
    setState(() {
      _designs = repository.getAllDesigns();
    });
  }

  List<DesignResult> get _filteredDesigns {
    if (_showFavoritesOnly) {
      return _designs.where((d) => d.isFavorite).toList();
    }
    return _designs;
  }

  Future<void> _toggleFavorite(String id) async {
    final repository = ref.read(designRepositoryProvider);
    await repository.toggleFavorite(id);
    _loadDesigns();
  }

  Future<void> _deleteDesign(String id) async {
    final repository = ref.read(designRepositoryProvider);
    await repository.deleteDesign(id);
    _loadDesigns();
  }

  void _openDesign(DesignResult design) {
    ref.read(designFlowProvider.notifier).loadFromDesignResult(design);
    context.go(RoutePaths.result);
  }

  Future<void> _shareDesign(DesignResult design) async {
    try {
      final file = File(design.generatedImagePath);
      if (await file.exists()) {
        await Share.shareXFiles(
          [XFile(design.generatedImagePath)],
          text: 'Room design created with RoomAI - ${design.styleName}',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share: $e'),
            backgroundColor: AppColors.bgSecondary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showOptionsSheet(DesignResult design) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.open_in_new_rounded,
                  color: AppColors.primary,
                ),
                title: Text('View Design', style: AppTypography.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _openDesign(design);
                },
              ),
              ListTile(
                leading: Icon(
                  design.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: design.isFavorite
                      ? AppColors.error
                      : AppColors.textSecondary,
                ),
                title: Text(
                  design.isFavorite
                      ? 'Remove from Favorites'
                      : 'Add to Favorites',
                  style: AppTypography.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _toggleFavorite(design.id);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.share_rounded,
                  color: AppColors.primaryLight,
                ),
                title:
                    Text('Share Design', style: AppTypography.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _shareDesign(design);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                ),
                title: Text(
                  'Delete Design',
                  style: AppTypography.bodyLarge
                      .copyWith(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(design);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(DesignResult design) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        title: Text('Delete Design', style: AppTypography.h3),
        content: Text(
          'Are you sure you want to delete this design? This action cannot be undone.',
          style: AppTypography.bodyMedium
              .copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTypography.labelLarge
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDesign(design.id);
            },
            child: Text(
              'Delete',
              style: AppTypography.labelLarge
                  .copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredDesigns;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        centerTitle: false,
        title: Text('My Designs', style: AppTypography.h2),
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: !_showFavoritesOnly,
                  onTap: () =>
                      setState(() => _showFavoritesOnly = false),
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Favorites',
                  isSelected: _showFavoritesOnly,
                  onTap: () =>
                      setState(() => _showFavoritesOnly = true),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : _buildGrid(filtered),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_library_rounded,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No designs yet',
              style: AppTypography.h3
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            GradientButton(
              text: 'Create Your First Design',
              width: 240,
              onPressed: () => context.go(RoutePaths.styleSelection),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<DesignResult> designs) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: designs.length,
      itemBuilder: (context, index) {
        final design = designs[index];
        return _buildGridItem(design, index);
      },
    );
  }

  Widget _buildGridItem(DesignResult design, int index) {
    final generatedFile = File(design.generatedImagePath);
    final fileExists = generatedFile.existsSync();

    return GestureDetector(
      onTap: () => _openDesign(design),
      onLongPress: () => _showOptionsSheet(design),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image or placeholder
            if (design.generatedImagePath.isNotEmpty && fileExists)
              Image.file(
                generatedFile,
                fit: BoxFit.cover,
                height: 200,
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.cardGradient,
                ),
                child: const Center(
                  child: Icon(
                    Icons.palette_rounded,
                    size: 40,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),

            // Bottom gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Style name + room type bottom-left
            Positioned(
              bottom: AppSpacing.sm,
              left: AppSpacing.sm,
              right: 36,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    design.styleName,
                    style: AppTypography.labelMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (design.roomTypeName.isNotEmpty)
                    Text(
                      design.roomTypeName,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Favorite icon top-right
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: GestureDetector(
                onTap: () => _toggleFavorite(design.id),
                child: Icon(
                  design.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color:
                      design.isFavorite ? Colors.red : Colors.white70,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: (index * 80).ms,
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
          delay: (index * 80).ms,
          curve: Curves.easeOut,
        );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surfaceGlass,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.surfaceBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
