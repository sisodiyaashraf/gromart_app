import 'package:flutter/material.dart';

class ProductModel {
  String name;
  String image;
  String weight;
  double price;
  String unit;
  Color boxColor;
  String category;

  ProductModel({
    required this.name,
    required this.image,
    required this.weight,
    required this.price,
    required this.unit,
    required this.boxColor,
    required this.category,
  });

  // Sample product list
  static List<ProductModel> getProducts() {
    return [
      ProductModel(
        name: "Broccoli",
        image: "assets/images/broccali.png",
        weight: "100g",
        price: 4,
        unit: "kg",
        boxColor: Colors.green.shade100,
        category: "Drinks",
      ),
      ProductModel(
        name: "Banana",
        image: "assets/images/milk.png",
        weight: "100g",
        price: 100,
        unit: "RS/kg",
        boxColor: Colors.yellow.shade100,
        category: "Vegetable",
      ),
      ProductModel(
        name: "Tomato",
        image: "assets/images/broccali.png",
        weight: "250g",
        price: 2.5,
        unit: "kg",
        boxColor: Colors.red.shade100,
        category: "Cooking Essential",
      ),
      ProductModel(
        name: "Milk",
        image: "assets/images/milk.png",
        weight: "1L",
        price: 1.5,
        unit: "L",
        boxColor: Colors.blue.shade100,
        category: "Sweet",
      ),
    ];
  }
}
