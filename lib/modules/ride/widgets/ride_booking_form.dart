import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RideBookingForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController notesController;
  final RxInt selectedSeats;
  final RxDouble totalPrice;
  final int maxSeats;
  final Function() incrementSeats;
  final Function() decrementSeats;

  const RideBookingForm({
    super.key,
    required this.formKey,
    required this.notesController,
    required this.selectedSeats,
    required this.totalPrice,
    required this.maxSeats,
    required this.incrementSeats,
    required this.decrementSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Number of Seats'),
          const SizedBox(height: 16.0),
          _buildSeatSelector(context),
          const SizedBox(height: 24.0),
          
          _buildSectionTitle(context, 'Additional Notes (Optional)'),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: notesController,
            decoration: InputDecoration(
              hintText: 'Any special requests or information',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24.0),
          
          _buildSectionTitle(context, 'Price Summary'),
          const SizedBox(height: 16.0),
          _buildPriceSummary(context),
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

  Widget _buildSeatSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Seats',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Row(
            children: [
              IconButton(
                onPressed: selectedSeats.value > 1 ? decrementSeats : null,
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Obx(() => SizedBox(
                    width: 40.0,
                    child: Text(
                      '${selectedSeats.value}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )),
              IconButton(
                onPressed: selectedSeats.value < maxSeats ? incrementSeats : null,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
          Obx(() => _buildPriceRow(
                context,
                'Seat Price',
                '\$${(totalPrice.value / selectedSeats.value).toStringAsFixed(2)}',
              )),
          const Divider(height: 24.0),
          Obx(() => _buildPriceRow(
                context,
                'Number of Seats',
                '${selectedSeats.value}',
              )),
          const Divider(height: 24.0),
          Obx(() => _buildPriceRow(
                context,
                'Total Price',
                '\$${totalPrice.value.toStringAsFixed(2)}',
                isTotal: true,
              )),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
              : Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: isTotal
              ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  )
              : Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
        ),
      ],
    );
  }
}