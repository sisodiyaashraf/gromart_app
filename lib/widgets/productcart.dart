import 'package:flutter/material.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_radius.dart';
import 'package:project_01/core/theme/app_spacing.dart';
import 'package:project_01/core/theme/app_text_styles.dart';
import 'package:project_01/core/utils/currency_formatter.dart';
import 'package:project_01/pages/product_detail_page.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: product.boxColor,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      elevation: 1,
      shadowColor: AppColors.shadow,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: ClipRRect(
                borderRadius: AppRadius.mdBorder,
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) return child;
                    return Container(color: Colors.white.withValues(alpha: 0.3));
                  },
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.white.withValues(alpha: 0.5),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 32,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              product.name,
              style: AppTextStyles.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              "weight ${product.weight}",
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "${CurrencyFormatter.format(product.price)} /${product.unit}",
                    style: AppTextStyles.price,
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  child: IconButton(
                    tooltip: "Add to cart",
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                    icon: const Icon(
                      Icons.add_circle,
                      color: AppColors.primary,
                      size: 26,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
