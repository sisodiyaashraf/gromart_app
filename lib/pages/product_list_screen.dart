import 'package:flutter/material.dart';
import 'package:project_01/core/widgets/empty_state.dart';
import 'package:project_01/widgets/productcart.dart';
import '../models/product.dart';

class ProductList extends StatelessWidget {
  final List<ProductModel> products;

  const ProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: EmptyState(
          icon: Icons.search_off_rounded,
          title: "No products found",
          message: "Check back later or try a different search.",
        ),
      );
    }

    final textScaler = MediaQuery.textScalerOf(context);
    final double scale = textScaler.scale(14) / 14;
    final double cardExtent = (210.0 + (scale * 70.0)).clamp(260.0, 380.0);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisExtent: cardExtent,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
