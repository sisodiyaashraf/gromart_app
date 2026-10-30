import 'package:flutter/material.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_radius.dart';
import 'package:project_01/core/theme/app_spacing.dart';
import 'package:project_01/core/theme/app_text_styles.dart';
import 'package:project_01/core/widgets/app_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'side_menu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isSideMenuOpen = false;
  String _currentPage = "Home";
  String _userName = "Guest";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.85).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
            .animate(_animationController);

    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      _userName = user?.userMetadata?['name'] ?? "Guest";
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleMenu() {
    setState(() {
      _isSideMenuOpen = !_isSideMenuOpen;
      if (_isSideMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _onMenuSelected(String menuTitle) {
    setState(() {
      _currentPage = menuTitle;
      _isSideMenuOpen = false;
      _animationController.reverse();
    });
  }

  Widget _buildPageContent() {
    if (_currentPage == "Home") {
      return const Center(child: Text("Home Page", style: AppTextStyles.title));
    }

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$_currentPage Page", style: AppTextStyles.headline),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              text: "Back to Home",
              icon: const Icon(Icons.home_rounded, color: Colors.white),
              onPressed: () => _onMenuSelected("Home"),
              width: 180,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double drawerWidth =
        (MediaQuery.sizeOf(context).width * 0.75).clamp(240.0, 300.0);

    return Scaffold(
      backgroundColor: AppColors.navBackground,
      body: Stack(
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: SideMenu(
              onMenuSelected: _onMenuSelected,
              selectedMenu: _currentPage,
              userName: _userName,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(
              _isSideMenuOpen ? drawerWidth : 0,
              0,
              0,
            ),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ClipRRect(
                borderRadius: _isSideMenuOpen ? AppRadius.xlBorder : BorderRadius.zero,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(_currentPage),
                    leading: IconButton(
                      tooltip: "Toggle Menu",
                      icon: const Icon(Icons.dashboard_customize_rounded),
                      onPressed: toggleMenu,
                    ),
                  ),
                  body: _buildPageContent(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
