import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_01/models/order.dart';
import 'package:project_01/widgets/foldingorder.dart'; // ✅ your new FoldingOrder widget

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderModel.getOrders(); // dummy orders

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FoldingOrder(
              header: _buildTicketHeader(order),
              content: _buildTicketItems(order),
              footer: _buildTicketFooter(context, order),
            ),
          );
        },
      ),
    );
  }

  /// Top section: Order ID + Status
  Widget _buildTicketHeader(OrderModel order) {
    return ListTile(
      title: Text("Order ${order.id}",
          style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: _buildStatusChip(order.status),
    );
  }

  /// Middle section: Order Items
  Widget _buildTicketItems(OrderModel order) {
    return Column(
      children: order.items.map((item) {
        return ListTile(
          leading: Image.asset(item.image, width: 40, height: 40),
          title: Text(item.name),
          subtitle: Text(item.weight),
          trailing: Text("\$${item.price.toStringAsFixed(2)}"),
        );
      }).toList(),
    );
  }

  /// Bottom section: Date, Total, Reorder
  Widget _buildTicketFooter(BuildContext context, OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          DateFormat('MMM dd, yyyy').format(order.date),
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          "Total: \$${order.total.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Reorder placed!")),
            );
          },
          icon: const Icon(Icons.shopping_cart),
          label: const Text("Reorder"),
        ),
      ],
    );
  }

  /// Status Chip
  Widget _buildStatusChip(String status) {
    Color bgColor;
    IconData icon;

    switch (status) {
      case "Delivered":
        bgColor = Colors.green.shade100;
        icon = Icons.check_circle;
        break;
      case "Pending":
        bgColor = Colors.orange.shade100;
        icon = Icons.access_time;
        break;
      case "Cancelled":
        bgColor = Colors.red.shade100;
        icon = Icons.cancel;
        break;
      default:
        bgColor = Colors.grey.shade200;
        icon = Icons.help;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.black54),
      label: Text(status, style: const TextStyle(fontWeight: FontWeight.w500)),
      backgroundColor: bgColor,
    );
  }
}
