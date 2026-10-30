import 'dart:async';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_spacing.dart';
import 'package:project_01/core/theme/app_text_styles.dart';
import 'package:project_01/core/widgets/app_button.dart';
import 'package:project_01/core/widgets/responsive_body.dart';
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
      if (!mounted) return;
      if (res.user != null) {
        final hasName = res.user!.userMetadata?['name'] != null;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => hasName ? const Homewidget() : const NameSetupScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    try {
      await Supabase.instance.client.auth.signInWithOtp(phone: widget.phone);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP Resent!")));
      _startTimer();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Verify OTP")),
      body: SafeArea(
        child: ResponsiveBody(
          scrollable: true,
          padding: AppSpacing.screenPadding,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              final double fieldWidth = ((maxWidth - 40) / 6).clamp(38.0, 48.0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  const Text("OTP sent to", style: AppTextStyles.bodySecondary, textAlign: TextAlign.center),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.phone,
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Center(
                    child: SizedBox(
                      width: maxWidth,
                      child: OTPTextField(
                        length: 6,
                        width: maxWidth,
                        fieldWidth: fieldWidth,
                        style: AppTextStyles.headline,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onChanged: (pin) => setState(() => _otpCode = pin),
                        onCompleted: (pin) => setState(() => _otpCode = pin),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  AppButton(
                    text: "Verify",
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _verifyOtp,
                    width: double.infinity,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Center(
                    child: TextButton(
                      onPressed: _secondsRemaining == 0 ? _resendOtp : null,
                      style: TextButton.styleFrom(minimumSize: const Size(120, 48)),
                      child: Text(
                        _secondsRemaining == 0 ? "Resend OTP" : "Resend OTP (${_secondsRemaining}s)",
                        style: AppTextStyles.subtitle.copyWith(
                          color: _secondsRemaining == 0 ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
