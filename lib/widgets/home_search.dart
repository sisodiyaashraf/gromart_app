import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_radius.dart';
import 'package:project_01/core/theme/app_text_styles.dart';
import 'package:project_01/core/utils/currency_formatter.dart';
import '../models/product.dart';

class HomeSearch extends StatelessWidget {
  final Function(String) onSearch;
  final Function(String) onTyping;
  final String searchQuery;
  final List<ProductModel> products;

  const HomeSearch({
    super.key,
    required this.onSearch,
    required this.onTyping,
    required this.searchQuery,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.button,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: onTyping,
              onSubmitted: onSearch,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintText: 'Search Gromart',
                hintStyle: AppTextStyles.bodySecondary.copyWith(
                  color: AppColors.textHint,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    "assets/icons/Search.svg",
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.button,
                  borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.button,
                  borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.button,
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),
        ),
        if (searchQuery.isNotEmpty) _buildSuggestions(),
      ],
    );
  }

  Widget _buildSuggestions() {
    final results = products.where((p) {
      return p.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text("No suggestions found", style: AppTextStyles.bodySecondary),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: results.length.clamp(0, 5),
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          dense: true,
          leading: ClipRRect(
            borderRadius: AppRadius.smBorder,
            child: Image.asset(item.image, width: 36, height: 36, fit: BoxFit.contain),
          ),
          title: Text(item.name, style: AppTextStyles.subtitle, maxLines: 1),
          subtitle: Text(CurrencyFormatter.format(item.price), style: AppTextStyles.caption),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
          onTap: () => onSearch(item.name),
        );
      },
    );
  }
}
