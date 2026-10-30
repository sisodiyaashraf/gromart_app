import 'package:flutter/material.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_radius.dart';
import 'package:project_01/core/theme/app_spacing.dart';
import 'package:project_01/core/theme/app_text_styles.dart';
import 'package:project_01/widgets/CategoryProductsPage.dart';
import 'package:project_01/widgets/SeeAllCategoriesPage.dart';
import '../models/categories.dart';

class HomeCategories extends StatelessWidget {
  final List<CategoryModel> categories;

  const HomeCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final double scale = textScaler.scale(14) / 14;
    final double listHeight = (100.0 + (scale * 20.0)).clamp(115.0, 160.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Categories', style: AppTextStyles.headline),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SeeAllCategoriesPage(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Text(
                  'See all',
                  style: AppTextStyles.subtitle.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: listHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: InkWell(
                  borderRadius: AppRadius.lgBorder,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryProductsPage(category: category),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: category.boxColor,
                          borderRadius: AppRadius.lgBorder,
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.6),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: AppRadius.lgBorder,
                          child: Image.asset(
                            category.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.category_rounded,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      SizedBox(
                        width: 72,
                        child: Text(
                          category.title,
                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
