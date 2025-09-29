import 'package:flutter/material.dart';
import 'package:project_01/widgets/productcart.dart';
import '../models/product.dart';
// your ProductCard

class ProductList extends StatelessWidget {
  final List<ProductModel> products;

  ProductList({super.key, required this.products});
  final List<ProductModel> product = ProductModel.getProducts();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      physics: const NeverScrollableScrollPhysics(), // stops inner scrolling
      shrinkWrap: true, // let grid fit inside scroll view
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cards per row
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
