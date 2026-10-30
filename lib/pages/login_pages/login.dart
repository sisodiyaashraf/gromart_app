import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:project_01/pages/login_pages/OtpVerifyScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  String _completePhone = '';
  bool _isLoading = false;
  bool _isValid = false;

  Future<void> _sendOtp() async {
    if (!_isValid || _completePhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signInWithOtp(
        phone: _completePhone,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerifyScreen(
              phone: _completePhone,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = size.width / 400;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.05),
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

                // Phone number input with country code picker & flag
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(fontSize: 14 * textScale),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 32, 219, 126),
                        width: 2,
                      ),
                    ),
                  ),
                  initialCountryCode: 'IN', // Default to India
                  disableLengthCheck: true,
                  showDropdownIcon: true,
                  dropdownIconPosition: IconPosition.trailing,
                  flagsButtonPadding: const EdgeInsets.only(left: 12),
                  style: TextStyle(fontSize: 16 * textScale),
                  onChanged: (phone) {
                    _completePhone = phone.completeNumber;
                    try {
                      _isValid = phone.isValidNumber();
                    } catch (_) {
                      _isValid = false;
                    }
                  },
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
