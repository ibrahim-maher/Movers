import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/onboarding_item_model.dart';
import '../../../core/themes/text_styles.dart';

class OnboardingItemWidget extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 1),

          // Illustration
          Container(
            height: 280,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: _buildIllustration(context),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            item.title,
            style: AppTextStyles.onboardingTitle.copyWith(
              color: Theme
                  .of(context)
                  .colorScheme
                  .onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            item.subtitle,
            style: AppTextStyles.onboardingSubtitle.copyWith(
              color: Theme
                  .of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    // Check if the image is an SVG or regular image
    if (item.image.endsWith('.svg')) {
      return SvgPicture.asset(
        item.image,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => _buildPlaceholder(context),
      );
    } else {
      return Image.asset(
        item.image,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholder(context),
      );
    }
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 80,
          color: Theme
              .of(context)
              .colorScheme
              .onSurfaceVariant,
        ),
      ),
    );
  }
}