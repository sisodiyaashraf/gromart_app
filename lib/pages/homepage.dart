import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_radius.dart';
import 'package:project_01/core/theme/app_spacing.dart';
import 'package:project_01/core/theme/app_text_styles.dart';
import 'package:project_01/widgets/cartpage.dart';
import 'package:project_01/widgets/homewidget.dart';
import 'package:project_01/widgets/order.dart';
import 'package:project_01/widgets/profile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Homewidget(),
    CartPage(),
    OrdersPage(),
    ProfilePage(),
  ];

  final List<String> _labels = const ["Home", "Cart", "Orders", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.navBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_labels.length, (index) {
              final isSelected = _selectedIndex == index;

              Widget iconWidget;
              if (index == 1) {
                iconWidget = SvgPicture.asset(
                  "assets/icons/conversation-svgrepo-com.svg",
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.textPrimary : Colors.white,
                    BlendMode.srcIn,
                  ),
                );
              } else if (index == 2) {
                iconWidget = SvgPicture.asset(
                  "assets/icons/NO959h01.svg",
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.textPrimary : Colors.white,
                    BlendMode.srcIn,
                  ),
                );
              } else if (index == 0) {
                iconWidget = Icon(
                  Icons.home_rounded,
                  size: 22,
                  color: isSelected ? AppColors.textPrimary : Colors.white,
                );
              } else {
                iconWidget = Icon(
                  Icons.person_rounded,
                  size: 22,
                  color: isSelected ? AppColors.textPrimary : Colors.white,
                );
              }

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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: AppRadius.roundBorder,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            iconWidget,
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
