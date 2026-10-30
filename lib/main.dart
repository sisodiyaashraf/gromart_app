import 'package:flutter/material.dart';
import 'package:project_01/core/theme/app_theme.dart';
import 'package:project_01/pages/login_pages/login.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_01/provider/address_provider.dart';
import 'package:project_01/provider/delivery_provider.dart';

// ✅ Your Providers
import 'package:project_01/pages/cart_provider.dart';
import 'package:project_01/pages/orders_provider.dart';
import 'package:project_01/provider/chat_provider.dart';
import 'package:project_01/provider/promo_code_provider.dart';

// ✅ Your Screens
import 'package:project_01/widgets/homewidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => PromoCodeProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Grocery AI Assistant",
      theme: AppTheme.lightTheme,
      home: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          // 🔄 Show loading indicator while waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final session = snapshot.data?.session;

          if (session != null) {
            return const Homewidget(); // ✅ Logged in
          } else {
            return const PhoneLoginScreen(); // ✅ Not logged in
          }
        },
      ),
    );
  }
}
