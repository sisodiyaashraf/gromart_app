import 'package:flutter/material.dart';
import 'package:project_01/core/widgets/empty_state.dart';
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
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          "My Cart",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: cart.cartItems.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: "Your cart is empty",
              message: "Looks like you haven't added any items to your cart yet.",
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  CartItemsList(
                    cart: cart,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  CartSummarySection(cart: cart),
                ],
              ),
            ),
    );
  }
}
