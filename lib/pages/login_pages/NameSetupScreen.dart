import 'package:flutter/material.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_spacing.dart';
import 'package:project_01/core/theme/app_text_styles.dart';
import 'package:project_01/core/widgets/app_button.dart';
import 'package:project_01/core/widgets/responsive_body.dart';
import 'package:project_01/widgets/homewidget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NameSetupScreen extends StatefulWidget {
  const NameSetupScreen({super.key});

  @override
  State<NameSetupScreen> createState() => _NameSetupScreenState();
}

class _NameSetupScreenState extends State<NameSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'name': name}),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Homewidget()),
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Setup Your Name"),
      ),
      body: SafeArea(
        child: ResponsiveBody(
          scrollable: true,
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                "Enter your name to personalize your account",
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _nameController,
                style: AppTextStyles.body,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.edit_outlined, color: AppColors.primary),
                  labelText: "Your Name",
                  hintText: "Enter full name",
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                text: "Save",
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _saveName,
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
