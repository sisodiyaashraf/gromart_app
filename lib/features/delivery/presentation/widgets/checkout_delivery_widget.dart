import 'package:flutter/material.dart';
import 'address_tile.dart';
import 'delivery_toggle.dart';
import 'instructions_field.dart';
import 'slot_picker.dart';

/// Composer widget bringing together delivery mode toggle, address, slot, and instructions.
class CheckoutDeliveryWidget extends StatelessWidget {
  const CheckoutDeliveryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DeliveryToggle(),
        SizedBox(height: 12),
        AddressTile(),
        SizedBox(height: 12),
        SlotPicker(),
        SizedBox(height: 12),
        InstructionsField(),
      ],
    );
  }
}
