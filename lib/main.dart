import 'package:flutter/material.dart';
import 'package:project_01/pages/login_pages/login.dart';
import 'package:project_01/widgets/homewidget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ✅ Your Providers
import 'package:project_01/pages/cart_provider.dart';
import 'package:project_01/pages/orders_provider.dart';
import 'package:project_01/provider/chat_provider.dart';
import 'package:project_01/provider/promo_code_provider.dart';

// ✅ Your Screens

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase
  await Supabase.initialize(
    url:
        "https://oxqbgaxemoqaspzfmwyp.supabase.co", // Replace with your Supabase URL
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94cWJnYXhlbW9xYXNwemZtd3lwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTkwNDIzNjIsImV4cCI6MjA3NDYxODM2Mn0.g4JDE7eDSkRXWiktQCq-V-PiOT3h7Nb8c0nQIS3-SJc", // Replace with your Supabase public anon key
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => PromoCodeProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<bool> checkIfLoggedIn() async {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null; // true if logged in
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Grocery AI Assistant",
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: FutureBuilder<bool>(
        future: checkIfLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            return const Homewidget(); // ✅ Already logged in
          } else {
            return const PhoneLoginScreen(); // ✅ Go to login
          }
        },
      ),
    );
  }
}
