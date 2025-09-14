import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_item.dart';
import '../widgets/page_indicator.dart';

class OnboardingPage extends GetView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Language Selection Button
                  IconButton(
                    onPressed: () => Get.toNamed('/language-selection'),
                    icon: const Icon(Icons.language),
                    tooltip: 'select_language'.tr,
                  ),
                  // Skip Button
                  TextButton(
                    onPressed: controller.skipOnboarding,
                    child: Text(
                      'skip'.tr,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Onboarding Content
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.onboardingItems.length,
                itemBuilder: (context, index) {
                  return OnboardingItemWidget(
                    item: controller.onboardingItems[index],
                  );
                },
              ),
            ),

            // Bottom Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page Indicators
                  Obx(() => PageIndicator(
                    currentIndex: controller.currentIndex.value,
                    itemCount: controller.onboardingItems.length,
                    onTap: controller.goToPage,
                  )),

                  const SizedBox(height: 32),

                  // Navigation Buttons
                  Row(
                    children: [
                      // Previous Button
                      Obx(() => controller.currentIndex.value > 0
                          ? Expanded(
                        child: OutlinedButton(
                          onPressed: controller.previousPage,
                          child: Text('back'.tr),
                        ),
                      )
                          : const Spacer()),

                      const SizedBox(width: 16),

                      // Next/Get Started Button
                      Expanded(
                        flex: 2,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.nextPage,
                          child: Text(
                            controller.isLastPage.value
                                ? 'get_started'.tr
                                : 'next'.tr,
                          ),
                        )),
                      ),
                    ],
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