import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_selection_controller.dart';
import '../widgets/language_tile.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller here since it's not in bindings
    final controller = Get.put(LanguageSelectionController());

    return Scaffold(
      appBar: AppBar(
        title: Text('select_language'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    Icons.language,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Choose your preferred language',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You can change this later in settings',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Language List
            Expanded(
              child: Obx(() => ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: controller.availableLanguages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final language = controller.availableLanguages[index];
                  return Obx(() => LanguageTile(
                    language: language,
                    isSelected: controller.isSelected(language),
                    onTap: () => controller.changeLanguage(language),
                    isLoading: controller.isChanging.value &&
                        controller.isSelected(language),
                  ));
                },
              )),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text('back'.tr),
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