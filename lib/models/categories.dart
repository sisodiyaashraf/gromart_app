import 'package:flutter/material.dart';

class CategoryModel {
  String title;
  String image;
  Color boxColor;

  CategoryModel({
    required this.title,
    required this.image,
    required this.boxColor,
  });

  // You can also create a static method to return sample categories if needed
  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(
        title: "Drinks",
        image: "assets/images/coldring.png",

        boxColor: Colors.blue.shade100,
      ),
      CategoryModel(
        title: "Vegetable",
        image: "assets/images/vegetable.png",
        boxColor: Colors.green.shade100,
      ),
      CategoryModel(
        title: "Cooking Essential",
        image: "assets/images/cookingessential.png",
        boxColor: Colors.orange.shade100,
      ),
      CategoryModel(
        title: "Sweet",
        image: "assets/images/chocolates.png",
        boxColor: Colors.white54,
      ),
      CategoryModel(
        title: "Drinks",
        image: "assets/images/coldring.png",

        boxColor: Colors.blue.shade100,
      ),
      CategoryModel(
        title: "Vegetable",
        image: "assets/images/vegetable.png",
        boxColor: Colors.green.shade100,
      ),
    ];
  }
}
