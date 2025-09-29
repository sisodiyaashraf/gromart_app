import 'package:flutter/material.dart';
import 'package:project_01/pages/login_pages/OtpVerifyScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signInWithOtp(
        phone: _phoneController.text.trim(),
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerifyScreen(
              phone: _phoneController.text.trim(),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // 👈 Screen size
    final textScale = size.width / 400; // 👈 Scale text based on width

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.05), // dynamic padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.05),

                // Grocery bot image (responsive)
                Image.asset(
                  "assets/images/robwithcartlogin-removebg-preview.png",
                  height: size.height * 0.35,
                  width: size.width * 0.8,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: size.height * 0.03),

                // Tagline
                Text(
                  "Shop Smart, Live Fresh",
                  style: TextStyle(
                    fontSize: 22 * textScale,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.01),
                Text(
                  "Login to AI Gromart and get your groceries delivered smartly!",
                  style: TextStyle(
                    fontSize: 16 * textScale,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: size.height * 0.05),

                // Phone number input
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(fontSize: 16 * textScale),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelText: "Enter Phone Number",
                    labelStyle: TextStyle(fontSize: 14 * textScale),
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // Send OTP button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 32, 219, 126),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Send OTP",
                            style: TextStyle(
                              fontSize: 18 * textScale,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
