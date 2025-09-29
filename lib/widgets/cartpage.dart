import 'package:flutter/material.dart';
import 'package:project_01/widgets/CartItemsList.dart';
import 'package:project_01/widgets/CartSummarySection.dart';
import 'package:provider/provider.dart';
import '../pages/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My Cart",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🛒 Cart Items
          Expanded(
            child: CartItemsList(cart: cart),
          ),

          // 🧾 Bottom Summary
          CartSummarySection(cart: cart),
        ],
      ),
    );
  }
}
