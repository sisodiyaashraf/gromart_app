import 'package:flutter/material.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_spacing.dart';
import 'package:project_01/core/theme/app_text_styles.dart';
import 'package:project_01/pages/login_pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'homewidget.dart';

class MenuItemModel {
  final String title;
  final IconData icon;

  MenuItemModel({required this.title, required this.icon});

  static List<MenuItemModel> menuItems = [
    MenuItemModel(title: "Home", icon: Icons.home_rounded),
    MenuItemModel(title: "Search", icon: Icons.search_rounded),
    MenuItemModel(title: "Favorites", icon: Icons.favorite_rounded),
    MenuItemModel(title: "Profile", icon: Icons.person_rounded),
    MenuItemModel(title: "History", icon: Icons.history_rounded),
  ];
}

class SideMenu extends StatefulWidget {
  final Function(String menuTitle)? onMenuSelected;
  final String selectedMenu;
  final String userName;

  const SideMenu({
    super.key,
    this.onMenuSelected,
    required this.selectedMenu,
    required this.userName,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late String _selectedMenu;

  @override
  void initState() {
    super.initState();
    _selectedMenu = widget.selectedMenu;
  }

  void onMenuPress(MenuItemModel menu) {
    setState(() => _selectedMenu = menu.title);
    widget.onMenuSelected?.call(menu.title);
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const PhoneLoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = (MediaQuery.sizeOf(context).width * 0.75).clamp(240.0, 300.0);

    return Container(
      width: drawerWidth,
      color: AppColors.navBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0x1FFFFFFF))),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: "Back to Home",
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Homewidget()),
                      (_) => false,
                    );
                  },
                ),
                const SizedBox(width: AppSpacing.xs),
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: AppColors.textPrimary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    widget.userName,
                    style: AppTextStyles.subtitle.copyWith(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: MenuItemModel.menuItems.map((menu) {
                final isSelected = _selectedMenu == menu.title;
                return ListTile(
                  minLeadingWidth: 24,
                  minVerticalPadding: 14,
                  leading: Icon(
                    menu.icon,
                    color: isSelected ? AppColors.accent : Colors.white,
                  ),
                  title: Text(
                    menu.title,
                    style: AppTextStyles.body.copyWith(
                      color: isSelected ? AppColors.accent : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () => onMenuPress(menu),
                );
              }).toList(),
            ),
          ),
          SafeArea(
            top: false,
            child: ListTile(
              minLeadingWidth: 24,
              minVerticalPadding: 14,
              leading: const Icon(Icons.logout_rounded, color: AppColors.error),
              title: Text(
                "Logout",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: _logout,
            ),
          ),
        ],
      ),
    );
  }
}
