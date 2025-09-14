import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/load_category_model.dart';

class LoadForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController pickupLocationController;
  final TextEditingController deliveryLocationController;
  final TextEditingController weightController;
  final TextEditingController dimensionsController;
  final TextEditingController priceController;
  final RxString selectedCategoryId;
  final RxList<LoadCategoryModel> categories;
  final Rx<DateTime> pickupDate;
  final Rx<DateTime> deliveryDate;
  final Function(String) selectCategory;
  final Function(BuildContext) selectPickupDate;
  final Function(BuildContext) selectDeliveryDate;
  final Function(String?) validateTitle;
  final Function(String?) validateDescription;
  final Function(String?) validateLocation;
  final Function(String?) validateWeight;
  final Function(String?) validateDimensions;
  final Function(String?) validatePrice;
  final String formatDate;

  const LoadForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.pickupLocationController,
    required this.deliveryLocationController,
    required this.weightController,
    required this.dimensionsController,
    required this.priceController,
    required this.selectedCategoryId,
    required this.categories,
    required this.pickupDate,
    required this.deliveryDate,
    required this.selectCategory,
    required this.selectPickupDate,
    required this.selectDeliveryDate,
    required this.validateTitle,
    required this.validateDescription,
    required this.validateLocation,
    required this.validateWeight,
    required this.validateDimensions,
    required this.validatePrice,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Basic Information'),
          const SizedBox(height: 16.0),
          _buildTextField(
            controller: titleController,
            labelText: 'Title',
            hintText: 'Enter load title',
            validator: validateTitle,
            maxLength: 100,
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            controller: descriptionController,
            labelText: 'Description',
            hintText: 'Enter load description',
            validator: validateDescription,
            maxLines: 3,
          ),
          const SizedBox(height: 16.0),
          _buildCategorySelector(context),
          const SizedBox(height: 24.0),
          
          _buildSectionTitle(context, 'Location Details'),
          const SizedBox(height: 16.0),
          _buildTextField(
            controller: pickupLocationController,
            labelText: 'Pickup Location',
            hintText: 'Enter pickup address',
            validator: validateLocation,
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            controller: deliveryLocationController,
            labelText: 'Delivery Location',
            hintText: 'Enter delivery address',
            validator: validateLocation,
            prefixIcon: const Icon(Icons.location_on),
          ),
          const SizedBox(height: 24.0),
          
          _buildSectionTitle(context, 'Schedule'),
          const SizedBox(height: 16.0),
          _buildDateSelector(
            context,
            'Pickup Date',
            pickupDate,
            () => selectPickupDate(context),
          ),
          const SizedBox(height: 16.0),
          _buildDateSelector(
            context,
            'Delivery Date',
            deliveryDate,
            () => selectDeliveryDate(context),
          ),
          const SizedBox(height: 24.0),
          
          _buildSectionTitle(context, 'Load Details'),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: weightController,
                  labelText: 'Weight (kg)',
                  hintText: 'Enter weight',
                  validator: validateWeight,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: _buildTextField(
                  controller: dimensionsController,
                  labelText: 'Dimensions',
                  hintText: 'L x W x H',
                  validator: validateDimensions,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          _buildTextField(
            controller: priceController,
            labelText: 'Price (\$)',
            hintText: 'Enter price',
            validator: validatePrice,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
            ],
            prefixIcon: const Icon(Icons.attach_money),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
    int? maxLength,
    Widget? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: prefixIcon,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: (value) => validator(value),
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8.0),
        Obx(() => Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: categories.map((category) {
                final isSelected = selectedCategoryId.value == category.id;
                return ChoiceChip(
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (_) => selectCategory(category.id),
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    String label,
    Rx<DateTime> date,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8.0),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 16.0),
                Obx(() => Text(formatDate)),
                const Spacer(),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}