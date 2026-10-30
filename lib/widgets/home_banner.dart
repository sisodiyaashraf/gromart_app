import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:project_01/core/theme/app_radius.dart';

class HomeBanner extends StatelessWidget {
  final List<String> imgList;

  const HomeBanner({super.key, required this.imgList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CarouselSlider(
        items: imgList.map((item) {
          return ClipRRect(
            borderRadius: AppRadius.mdBorder,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: AppRadius.mdBorder,
                image: DecorationImage(
                  image: AssetImage(item),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 180,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.92,
        ),
      ),
    );
  }
}
