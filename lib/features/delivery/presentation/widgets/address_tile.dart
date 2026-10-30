import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';
import '../providers/delivery_provider.dart';
import '../screens/address_management_screen.dart';

/// Displays selected address or prompt to select/add one during checkout.
class AddressTile extends StatelessWidget {
  const AddressTile({super.key});

  @override
  Widget build(BuildContext context) {
    final delivery = context.watch<DeliveryProvider>();
    final addressProvider = context.watch<AddressProvider>();

    if (delivery.isPickup) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.store, color: Colors.black54),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Pickup at Gromart Hub (Free)\nEstimated ready in 30 mins",
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
            ),
          ],
        ),
      );
    }

    final hasAddress = delivery.selectedAddressText != null &&
        delivery.selectedAddressText!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: delivery.isValidDelivery ? Colors.grey.shade300 : Colors.red.shade400,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.green.shade800, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Delivery Address",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () => _chooseAddress(context, addressProvider, delivery),
                child: Text(hasAddress ? "Change" : "Select"),
              ),
            ],
          ),
          if (hasAddress) ...[
            Text(delivery.selectedAddressText!, style: const TextStyle(fontSize: 13, color: Colors.black87)),
            if (delivery.validationError != null) ...[
              const SizedBox(height: 6),
              Text(
                delivery.validationError!,
                style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ] else ...[
            TextButton.icon(
              onPressed: () => _chooseAddress(context, addressProvider, delivery),
              icon: const Icon(Icons.add_location_alt_outlined, size: 18),
              label: const Text("Select or add delivery address"),
            ),
          ],
        ],
      ),
    );
  }

  void _chooseAddress(BuildContext context, AddressProvider addressProvider, DeliveryProvider delivery) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddressManagementScreen()),
    );
    final def = addressProvider.defaultAddress;
    if (def != null && delivery.selectedAddressId == null) {
      delivery.selectAddress(def);
    }
  }
}
