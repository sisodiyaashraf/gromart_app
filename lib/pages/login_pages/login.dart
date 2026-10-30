import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_radius.dart';
import 'package:project_01/core/theme/app_spacing.dart';
import 'package:project_01/core/theme/app_text_styles.dart';
import 'package:project_01/core/widgets/app_button.dart';
import 'package:project_01/core/widgets/responsive_body.dart';
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

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerifyScreen(
            phone: _completePhone,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ResponsiveBody(
          scrollable: true,
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: Image.asset(
                  "assets/images/robwithcartlogin-removebg-preview.png",
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.shopping_basket_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                "Shop Smart, Live Fresh",
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                "Login to AI Gromart and get your groceries delivered smartly!",
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xl),
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: AppTextStyles.bodySecondary,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.button,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.button,
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),
                initialCountryCode: 'IN',
                disableLengthCheck: true,
                showDropdownIcon: true,
                dropdownIconPosition: IconPosition.trailing,
                flagsButtonPadding: const EdgeInsets.only(left: 12),
                style: AppTextStyles.body,
                onChanged: (phone) {
                  _completePhone = phone.completeNumber;
                  try {
                    _isValid = phone.isValidNumber();
                  } catch (_) {
                    _isValid = false;
                  }
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                text: "Send OTP",
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _sendOtp,
                width: double.infinity,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
