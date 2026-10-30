import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/delivery_provider.dart';

/// Allows user to select a delivery time slot, rejecting slots in the past.
class SlotPicker extends StatelessWidget {
  const SlotPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final delivery = context.watch<DeliveryProvider>();
    if (delivery.isPickup) return const SizedBox.shrink();

    final availableSlots = _generateSlots();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Preferred Delivery Slot", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: availableSlots.map((slot) {
              final isSelected = delivery.slot != null &&
                  delivery.slot!.year == slot.year &&
                  delivery.slot!.month == slot.month &&
                  delivery.slot!.day == slot.day &&
                  delivery.slot!.hour == slot.hour;

              final label = _formatSlotLabel(slot);

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black87)),
                  selected: isSelected,
                  selectedColor: Colors.green.shade800,
                  onSelected: (selected) {
                    if (selected) {
                      delivery.setSlot(slot);
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<DateTime> _generateSlots() {
    final now = DateTime.now();
    final List<DateTime> slots = [];

    // Today slots (if not past)
    final todayEvening = DateTime(now.year, now.month, now.day, 18);
    if (todayEvening.isAfter(now)) {
      slots.add(todayEvening);
    }

    // Tomorrow slots
    final tomorrow = now.add(const Duration(days: 1));
    slots.add(DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9));
    slots.add(DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 14));
    slots.add(DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 18));

    return slots;
  }

  String _formatSlotLabel(DateTime dt) {
    final now = DateTime.now();
    final isToday = dt.year == now.year && dt.month == now.month && dt.day == now.day;
    final prefix = isToday ? "Today" : "Tomorrow";
    final timeStr = DateFormat('ha').format(dt);
    return "$prefix $timeStr";
  }
}
