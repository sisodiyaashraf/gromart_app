import 'dart:async';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:project_01/pages/login_pages/NameSetupScreen.dart';
import 'package:project_01/widgets/homewidget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String phone;
  const OtpVerifyScreen({super.key, required this.phone});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  String _otpCode = "";
  bool _isLoading = false;

  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _secondsRemaining = 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter 6-digit OTP")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final res = await Supabase.instance.client.auth.verifyOTP(
        phone: widget.phone,
        token: _otpCode,
        type: OtpType.sms,
      );

      final user = res.user;
      if (user != null) {
        final hasName = user.userMetadata?['name'] != null;

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  hasName ? const Homewidget() : const NameSetupScreen(),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _resendOtp() async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(phone: widget.phone);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Resent!")),
      );
      _startTimer(); // restart countdown after resend
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error resending OTP: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScale = size.width / 400;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Verify OTP"),
        backgroundColor: const Color.fromARGB(255, 32, 219, 126),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.05),

                // Header
                Text(
                  "OTP sent to",
                  style: TextStyle(
                    fontSize: 18 * textScale,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.phone,
                  style: TextStyle(
                    fontSize: 20 * textScale,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: size.height * 0.04),

                /// OTP FIELD
                OTPTextField(
                  length: 6,
                  width: size.width,
                  fieldWidth: size.width * 0.12,
                  style: TextStyle(fontSize: 20 * textScale),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onChanged: (pin) => setState(() => _otpCode = pin),
                  onCompleted: (pin) => setState(() => _otpCode = pin),
                ),

                SizedBox(height: size.height * 0.05),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOtp,
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
                            "Verify",
                            style: TextStyle(
                              fontSize: 18 * textScale,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                SizedBox(height: size.height * 0.02),

                // Resend Button
                TextButton(
                  onPressed: _secondsRemaining == 0 ? _resendOtp : null,
                  child: Text(
                    _secondsRemaining == 0
                        ? "Resend OTP"
                        : "Resend OTP (${_secondsRemaining}s)",
                    style: TextStyle(fontSize: 16 * textScale),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
