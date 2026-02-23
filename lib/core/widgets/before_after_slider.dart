import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class BeforeAfterSlider extends StatefulWidget {
  final ImageProvider beforeImage;
  final ImageProvider afterImage;
  final double? height;

  const BeforeAfterSlider({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    this.height,
  });

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  double _sliderPosition = 0.5;

  // Track which thresholds have been crossed for haptic feedback
  final Set<double> _crossedThresholds = {};

  void _onDragUpdate(DragUpdateDetails details, double maxWidth) {
    setState(() {
      _sliderPosition += details.delta.dx / maxWidth;
      _sliderPosition = _sliderPosition.clamp(0.0, 1.0);
    });

    // Check haptic feedback thresholds
    for (final threshold in [0.25, 0.5, 0.75]) {
      if ((_sliderPosition - threshold).abs() < 0.01) {
        if (!_crossedThresholds.contains(threshold)) {
          _crossedThresholds.add(threshold);
          HapticFeedback.selectionClick();
        }
      } else {
        _crossedThresholds.remove(threshold);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final effectiveHeight = widget.height ?? constraints.maxHeight;

        return SizedBox(
          height: effectiveHeight,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) =>
                _onDragUpdate(details, maxWidth),
            child: Stack(
              children: [
                // After image (full width, bottom layer)
                Positioned.fill(
                  child: Image(
                    image: widget.afterImage,
                    fit: BoxFit.cover,
                  ),
                ),

                // Before image (clipped, top layer)
                Positioned.fill(
                  child: ClipRect(
                    clipper: _BeforeClipper(sliderPosition: _sliderPosition),
                    child: Image(
                      image: widget.beforeImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Divider line
                Positioned(
                  left: maxWidth * _sliderPosition - 1.5,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 3,
                    color: Colors.white,
                  ),
                ),

                // Handle
                Positioned(
                  left: maxWidth * _sliderPosition - 24,
                  top: effectiveHeight / 2 - 24,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_left,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                        Icon(
                          Icons.arrow_right,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BeforeClipper extends CustomClipper<Rect> {
  final double sliderPosition;

  _BeforeClipper({required this.sliderPosition});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * sliderPosition, size.height);
  }

  @override
  bool shouldReclip(covariant _BeforeClipper oldClipper) {
    return oldClipper.sliderPosition != sliderPosition;
  }
}
