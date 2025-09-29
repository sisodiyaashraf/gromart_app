import 'package:flutter/material.dart';
import 'package:project_01/models/categories.dart';
import '../models/product.dart';

class CategoryProductsPage extends StatelessWidget {
  final CategoryModel category;

  const CategoryProductsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final allProducts = ProductModel.getProducts();
    final filtered = allProducts
        .where((p) => p.category == category.title)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.title,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: filtered.isEmpty
          ? const Center(child: Text("No products found"))
          : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final product = filtered[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: Image.asset(product.image, height: 40),
                    title: Text(product.name),
                    subtitle: Text("${product.weight} • \$${product.price}"),
                  ),
                );
              },
            ),
    );
  }
}
