import 'package:flutter/material.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_radius.dart';
import 'package:project_01/core/theme/app_spacing.dart';
import 'package:project_01/core/theme/app_text_styles.dart';

class CustomTabs extends StatefulWidget {
  const CustomTabs({super.key});

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _tabs = const [
    {"icon": Icons.flash_on_rounded, "label": "Flash sales"},
    {"label": "For you"},
    {"label": "Popular"},
    {"label": "New"},
    {"label": "Trending"},
  ];

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final double scale = textScaler.scale(14) / 14;
    final double barHeight = (44.0 + (scale * 8.0)).clamp(48.0, 64.0);

    return SizedBox(
      height: barHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final tab = _tabs[index];
            final bool isSelected = _selectedIndex == index;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                borderRadius: AppRadius.roundBorder,
                onTap: () => setState(() => _selectedIndex = index),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceDim,
                      borderRadius: AppRadius.roundBorder,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (tab["icon"] != null) ...[
                          Icon(
                            tab["icon"] as IconData,
                            size: 18,
                            color: isSelected ? Colors.white : AppColors.warning,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                        ],
                        Text(
                          tab["label"] as String,
                          style: AppTextStyles.subtitle.copyWith(
                            fontSize: 13,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
