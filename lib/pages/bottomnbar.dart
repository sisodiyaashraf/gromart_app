import 'package:flutter/material.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_radius.dart';
import 'package:project_01/core/theme/app_spacing.dart';
import 'package:project_01/core/theme/app_text_styles.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _selectedIndex = 0;

  final List<IconData> _icons = const [
    Icons.home_rounded,
    Icons.shopping_basket_rounded,
    Icons.assignment_rounded,
    Icons.person_rounded,
  ];

  final List<String> _labels = const ["Home", "Cart", "Orders", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Selected: ${_labels[_selectedIndex]}",
          style: AppTextStyles.headline,
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.navBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              final isSelected = _selectedIndex == index;
              return Tooltip(
                message: _labels[index],
                child: Semantics(
                  button: true,
                  selected: isSelected,
                  label: _labels[index],
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: AppRadius.roundBorder,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _icons[index],
                              size: 22,
                              color: isSelected ? AppColors.textPrimary : Colors.white,
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: AppSpacing.xs),
                              Flexible(
                                child: Text(
                                  _labels[index],
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
