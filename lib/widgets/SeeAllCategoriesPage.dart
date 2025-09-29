import 'package:flutter/material.dart';
import 'package:project_01/models/categories.dart';
import 'package:project_01/widgets/CategoryProductsPage.dart';

class SeeAllCategoriesPage extends StatelessWidget {
  const SeeAllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = CategoryModel.getCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Categories",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // ✅ 3 categories per row
          crossAxisSpacing: 13,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8, // Adjust spacing for image + title
        ),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryProductsPage(category: category),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Category image
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: category.boxColor,
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(category.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Category title
                Text(
                  category.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
