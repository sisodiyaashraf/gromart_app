import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../providers/delivery_provider.dart';

/// Shows delivery fee breakdown, distance, and free pickup indicator.
class FeeSummary extends StatelessWidget {
  const FeeSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final delivery = context.watch<DeliveryProvider>();

    final label = delivery.isDelivery && delivery.distanceKm != null
        ? "Delivery Charge (${delivery.distanceKm!.toStringAsFixed(1)} km)"
        : "Delivery Charge";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          delivery.fee == 0.0 ? "Free" : CurrencyFormatter.format(delivery.fee),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: delivery.fee == 0.0 ? Colors.green.shade800 : Colors.black87,
          ),
        ),
      ],
    );
  }
}
