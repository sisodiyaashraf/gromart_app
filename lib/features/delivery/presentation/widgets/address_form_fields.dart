import 'package:flutter/material.dart';

/// Reusable address form fields with validation.
class AddressFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController labelController;
  final TextEditingController line1Controller;
  final TextEditingController line2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;

  const AddressFormFields({
    super.key,
    required this.formKey,
    required this.labelController,
    required this.line1Controller,
    required this.line2Controller,
    required this.cityController,
    required this.stateController,
    required this.zipController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelChips(),
          const SizedBox(height: 12),
          TextFormField(
            controller: line1Controller,
            decoration: const InputDecoration(
              labelText: "Address Line 1 *",
              hintText: "House/Flat no., Building, Street",
              border: OutlineInputBorder(),
            ),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? "Address Line 1 is required" : null,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: line2Controller,
            decoration: const InputDecoration(
              labelText: "Address Line 2 (Optional)",
              hintText: "Apartment, Landmark, Area",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: "City *",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "City is required" : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: stateController,
                  decoration: const InputDecoration(
                    labelText: "State",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: zipController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "PIN / ZIP",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabelChips() {
    final options = ['Home', 'Work', 'Other'];
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          children: options.map((opt) {
            final isSelected = labelController.text.trim().toLowerCase() ==
                opt.toLowerCase();
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(opt),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => labelController.text = opt);
                  }
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
