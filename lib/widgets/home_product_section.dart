import 'package:flutter/material.dart';
import 'package:project_01/core/theme/app_text_styles.dart';
import 'package:project_01/pages/product_list_screen.dart';
import 'package:project_01/widgets/tabbar.dart';
import '../models/product.dart';

class HomeProductSection extends StatelessWidget {
  final List<ProductModel> products;

  const HomeProductSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const CustomTabs(),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Products",
            style: AppTextStyles.headline,
          ),
        ),
        ProductList(products: products),
      ],
    );
  }
}
