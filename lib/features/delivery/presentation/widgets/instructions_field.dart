import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/delivery_provider.dart';

/// Text field for special delivery instructions.
class InstructionsField extends StatelessWidget {
  const InstructionsField({super.key});

  @override
  Widget build(BuildContext context) {
    final delivery = context.watch<DeliveryProvider>();
    if (delivery.isPickup) return const SizedBox.shrink();

    return TextFormField(
      initialValue: delivery.instructions,
      decoration: const InputDecoration(
        labelText: "Delivery Instructions",
        hintText: "e.g. Ring the doorbell, leave at front gate",
        border: OutlineInputBorder(),
        isDense: true,
        prefixIcon: Icon(Icons.note_alt_outlined, size: 20),
      ),
      onChanged: (val) => delivery.setInstructions(val),
    );
  }
}
