import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/delivery_provider.dart';

/// Segmented toggle for choosing between delivery and pickup.
class DeliveryToggle extends StatelessWidget {
  const DeliveryToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeliveryProvider>();

    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(
            value: 'delivery',
            label: Text('Delivery'),
            icon: Icon(Icons.delivery_dining),
          ),
          ButtonSegment(
            value: 'pickup',
            label: Text('Pickup'),
            icon: Icon(Icons.storefront),
          ),
        ],
        selected: {provider.type},
        onSelectionChanged: (Set<String> newSelection) {
          provider.setType(newSelection.first);
        },
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: Colors.green.shade800,
          selectedForegroundColor: Colors.white,
        ),
      ),
    );
  }
}
