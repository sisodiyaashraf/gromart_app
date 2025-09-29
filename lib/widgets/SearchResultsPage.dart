import 'package:flutter/material.dart';
import 'package:project_01/models/product.dart';
import 'package:project_01/pages/product_list_screen.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;
  final List<ProductModel> products;

  const SearchResultsPage({
    super.key,
    required this.query,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final results = products.where((p) {
      return p.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Search: $query"),
      ),
      body: results.isEmpty
          ? const Center(
              child: Text(
                "No products found",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ProductList(products: results),
    );
  }
}
