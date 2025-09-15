// lib/modules/load/pages/create_load_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_load_controller.dart';
import '../models/load_model.dart';

class CreateLoadPage extends GetView<CreateLoadController> {
  const CreateLoadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Post Load',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _buildStepIndicator(theme),
          Expanded(
            child: Obx(() => _buildCurrentStep(theme)),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Container(
      color: theme.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Obx(() => Row(
        children: [
          _buildStepItem(1, 'Load Details', 0, theme),
          _buildStepConnector(theme),
          _buildStepItem(2, 'Vehicle Type', 1, theme),
          _buildStepConnector(theme),
          _buildStepItem(3, 'Post', 2, theme),
        ],
      )),
    );
  }

  Widget _buildStepItem(int number, String title, int stepIndex, ThemeData theme) {
    final isActive = controller.currentStep.value == stepIndex;
    final isCompleted = controller.currentStep.value > stepIndex;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.white
                  : isActive
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(
                Icons.check,
                size: 18,
                color: theme.primaryColor,
              )
                  : Text(
                number.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isActive ? theme.primaryColor : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(ThemeData theme) {
    return Container(
      height: 2,
      width: 40,
      color: Colors.white.withOpacity(0.3),
      margin: const EdgeInsets.only(bottom: 20),
    );
  }

  Widget _buildCurrentStep(ThemeData theme) {
    switch (controller.currentStep.value) {
      case 0:
        return _buildLoadDetailsStep(theme);
      case 1:
        return _buildVehicleTypeStep(theme);
      case 2:
        return _buildPostStep(theme);
      default:
        return _buildLoadDetailsStep(theme);
    }
  }

  Widget _buildLoadDetailsStep(ThemeData theme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.loadDetailsFormKey,
          child: Column(
            children: [
              _buildFormCard(
                children: [
                  _buildLocationField(
                    controller: controller.pickupLocationController,
                    label: 'Pickup Point',
                    icon: Icons.location_on,
                    validator: controller.validatePickupLocation,
                  ),
                  const SizedBox(height: 16),
                  _buildLocationField(
                    controller: controller.dropLocationController,
                    label: 'Drop Point',
                    icon: Icons.location_on,
                    validator: controller.validateDropLocation,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFormCard(
                children: [
                  _buildTextField(
                    controller: controller.materialNameController,
                    label: 'Material Name',
                    icon: Icons.inventory_2,
                    validator: controller.validateMaterialName,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: controller.numberOfTonnesController,
                    label: 'Number of Tonnes',
                    icon: Icons.scale,
                    keyboardType: TextInputType.number,
                    validator: controller.validateNumberOfTonnes,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: controller.descriptionController,
                    label: 'Description',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildNextButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleTypeStep(ThemeData theme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildFormCard(
              title: 'Select Vehicle',
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3, // Increased to give more width, less height pressure
                  ),
                  itemCount: controller.vehicleTypes.length,
                  itemBuilder: (context, index) {
                    final vehicle = controller.vehicleTypes[index];

                    return Obx(() {
                      final isSelected = controller.selectedVehicleType.value == vehicle.id;

                      return GestureDetector(
                        onTap: () => controller.selectVehicleType(vehicle),
                        child: Container(
                          padding: const EdgeInsets.all(8), // Further reduced padding
                          decoration: BoxDecoration(
                            color: isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? theme.primaryColor : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible( // Wrap icon container in Flexible
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isSelected ? theme.primaryColor.withOpacity(0.1) : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getVehicleIcon(vehicle.id),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Flexible( // Wrap text in Flexible
                                child: Text(
                                  vehicle.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? theme.primaryColor : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Flexible( // Wrap capacity text in Flexible
                                child: Text(
                                  vehicle.capacityRange,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildNextButton(theme),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPostStep(ThemeData theme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.contactDetailsFormKey,
          child: Column(
            children: [
              _buildFormCard(
                title: "What's your expected price?",
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: controller.expectedPriceController,
                          label: 'Amount',
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: controller.validateExpectedPrice,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              controller.isFixedPrice.value ? 'Fix' : 'Per Tonne',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: controller.isFixedPrice.value,
                              onChanged: controller.togglePriceType,
                              activeColor: theme.primaryColor,
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFormCard(
                title: 'The number of hours visible load?',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: controller.visibilityHoursController,
                          label: 'Number of hours',
                          icon: Icons.access_time,
                          keyboardType: TextInputType.number,
                          validator: controller.validateVisibilityHours,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Hours',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFormCard(
                title: 'Pickup Contact Detail',
                children: [
                  _buildTextField(
                    controller: controller.pickupContactController,
                    label: 'Pickup Contact Detail',
                    icon: Icons.person,
                    validator: controller.validateContactName,
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.useSelfForPickup.value,
                        onChanged: (value) => controller.toggleSelfPickup(value ?? false),
                        activeColor: theme.primaryColor,
                      ),
                      const Text(
                        'My Self',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              const SizedBox(height: 16),
              _buildFormCard(
                title: 'Drop Contact Detail',
                children: [
                  _buildTextField(
                    controller: controller.dropContactController,
                    label: 'Drop Contact Detail',
                    icon: Icons.person,
                    validator: controller.validateContactName,
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Row(
                    children: [
                      Checkbox(
                        value: controller.useSelfForDrop.value,
                        onChanged: (value) => controller.toggleSelfDrop(value ?? false),
                        activeColor: theme.primaryColor,
                      ),
                      const Text(
                        'My Self',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              const SizedBox(height: 32),
              _buildPostButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard({String? title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
          ],
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Get.theme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Get.theme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildNextButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.nextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPostButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.nextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: controller.isLoading.value
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Text(
          'Post Load',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      )),
    );
  }

  String _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'lcv':
        return '🚚';
      case 'truck':
        return '🚛';
      case 'hyva':
        return '🚛';
      case 'container':
        return '🚛';
      case 'trailer':
        return '🚛';
      default:
        return '🚚';
    }
  }
}