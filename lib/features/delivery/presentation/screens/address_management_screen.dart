import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/entities/address.dart';
import '../providers/address_provider.dart';
import 'address_picker_map.dart';

class AddressManagementScreen extends StatelessWidget {
  const AddressManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Addresses")),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location_alt),
        label: const Text("Add Address"),
        onPressed: () => _openPicker(context),
      ),
      body: Consumer<AddressProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.addresses.isEmpty) {
            return const LoadingView(message: "Loading addresses...");
          }
          if (provider.addresses.isEmpty) {
            return EmptyState(
              icon: Icons.location_off_outlined,
              title: "No addresses saved",
              message: "Add your delivery address to start shopping.",
              buttonText: "Add Address",
              onAction: () => _openPicker(context),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.addresses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _buildAddressCard(context, provider, provider.addresses[i]),
          );
        },
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, AddressProvider provider, Address a) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: a.isDefault ? BorderSide(color: Colors.green.shade800, width: 1.5) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(a.label.toLowerCase() == 'work' ? Icons.work : Icons.home, size: 20, color: Colors.green.shade800),
                const SizedBox(width: 8),
                Text(a.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                if (a.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)),
                    child: Text("DEFAULT", style: TextStyle(color: Colors.green.shade800, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(a.fullAddress, style: const TextStyle(color: Colors.black87, fontSize: 14)),
            const Divider(height: 20),
            Row(
              children: [
                if (!a.isDefault)
                  TextButton.icon(
                    onPressed: () => provider.setDefault(a.id),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text("Set Default"),
                  ),
                const Spacer(),
                IconButton(
                  tooltip: "Edit",
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _openPicker(context, a),
                ),
                IconButton(
                  tooltip: "Delete",
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  onPressed: () => _confirmDelete(context, provider, a),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openPicker(BuildContext context, [Address? address]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddressPickerMap(initialAddress: address)),
    );
  }

  Future<void> _confirmDelete(BuildContext context, AddressProvider provider, Address a) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Address"),
        content: Text("Are you sure you want to delete '${a.label}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await provider.deleteAddress(a.id);
    }
  }
}
