import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/edit_load_controller.dart';
import '../widgets/load_form.dart';

class EditLoadPage extends GetView<EditLoadController> {
  const EditLoadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Load'),
      ),
      body: Obx(() {
        if (controller.isLoading.value || controller.isLoadingCategories.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error message
              if (controller.errorMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12.0),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Load form
              LoadForm(
                formKey: controller.formKey,
                titleController: controller.titleController,
                descriptionController: controller.descriptionController,
                pickupLocationController: controller.pickupLocationController,
                deliveryLocationController: controller.deliveryLocationController,
                weightController: controller.weightController,
                dimensionsController: controller.dimensionsController,
                priceController: controller.priceController,
                selectedCategoryId: controller.selectedCategoryId,
                categories: controller.categories,
                pickupDate: controller.pickupDate,
                deliveryDate: controller.deliveryDate,
                selectCategory: controller.selectCategory,
                selectPickupDate: controller.selectPickupDate,
                selectDeliveryDate: controller.selectDeliveryDate,
                validateTitle: controller.validateTitle,
                validateDescription: controller.validateDescription,
                validateLocation: controller.validateLocation,
                validateWeight: controller.validateWeight,
                validateDimensions: controller.validateDimensions,
                validatePrice: controller.validatePrice,
                formatDate: controller.formatDate(controller.pickupDate.value),
              ),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.updateLoad,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: controller.isSubmitting.value
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Update Load',
                          style: TextStyle(fontSize: 16.0),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}