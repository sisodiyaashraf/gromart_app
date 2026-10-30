import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_spacing.dart';
import 'package:project_01/models/categories.dart';
import 'package:project_01/models/product.dart';
import 'package:project_01/widgets/SearchResultsPage.dart';
import 'package:project_01/widgets/home_banner.dart';
import 'package:project_01/widgets/home_categories.dart';
import 'package:project_01/widgets/home_header.dart';
import 'package:project_01/widgets/home_product_section.dart';
import 'package:project_01/widgets/home_search.dart';
import 'package:project_01/widgets/side_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homewidget extends StatefulWidget {
  const Homewidget({super.key});

  @override
  State<Homewidget> createState() => _HomewidgetState();
}

class _HomewidgetState extends State<Homewidget> with TickerProviderStateMixin {
  final List<CategoryModel> categories = CategoryModel.getCategories();
  final List<ProductModel> product = ProductModel.getProducts();

  final List<String> imgList = const [
    "assets/images/sale.png",
    "assets/images/Screenshot3.png",
    "assets/images/Screenshot2.png",
    "assets/images/Screenshot41.png",
    "assets/images/Screenshot3.png",
  ];

  GifController? _gifController;
  Timer? _gifTimer;
  bool _isMenuOpen = false;
  String _searchQuery = "";
  String _userName = "Guest";

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
    _loadUser();

    _gifTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted && _gifController != null) {
        _gifController!.reset();
        _gifController!.forward();
      }
    });
  }

  Future<void> _loadUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && mounted) {
      setState(() {
        _userName = user.userMetadata?['name'] ?? "Guest";
      });
    }
  }

  @override
  void dispose() {
    _gifTimer?.cancel();
    _gifController?.dispose();
    super.dispose();
  }

  void _navigateToSearch(String query) {
    if (query.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsPage(query: query, products: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = (MediaQuery.sizeOf(context).width * 0.75).clamp(240.0, 300.0);
    final double bottomInset = AppSpacing.bottomNavInset(context, navBarHeight: 72.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isMenuOpen ? 0 : -drawerWidth,
            top: 0,
            bottom: 0,
            child: SideMenu(
              onMenuSelected: (_) => setState(() => _isMenuOpen = false),
              selectedMenu: '',
              userName: _userName,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_isMenuOpen ? drawerWidth : 0, 0, 0),
            child: AbsorbPointer(
              absorbing: _isMenuOpen,
              child: Scaffold(
                backgroundColor: AppColors.background,
                appBar: HomeHeader(
                  userName: _userName,
                  onMenuPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
                  gifController: _gifController,
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeSearch(
                        onSearch: _navigateToSearch,
                        onTyping: (q) => setState(() => _searchQuery = q),
                        searchQuery: _searchQuery,
                        products: product,
                      ),
                      HomeBanner(imgList: imgList),
                      HomeCategories(categories: categories),
                      HomeProductSection(products: product),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
