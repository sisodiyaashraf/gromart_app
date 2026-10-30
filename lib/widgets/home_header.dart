import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:project_01/core/theme/app_colors.dart';
import 'package:project_01/core/theme/app_text_styles.dart';
import 'package:project_01/screens/chat_screen.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final VoidCallback onMenuPressed;
  final GifController? gifController;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onMenuPressed,
    this.gifController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        tooltip: "Open menu",
        icon: const Icon(Icons.sort_rounded, color: AppColors.textPrimary),
        onPressed: onMenuPressed,
      ),
      title: Text(
        "Welcome, $userName 👋",
        style: AppTextStyles.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Tooltip(
            message: "Chat with AI Assistant",
            child: Semantics(
              button: true,
              label: "Chat with AI Assistant",
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChatScreen()),
                  );
                },
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: gifController == null
                        ? const Icon(Icons.smart_toy_rounded, color: AppColors.primary, size: 28)
                        : Gif(
                            controller: gifController!,
                            autostart: Autostart.no,
                            image: const AssetImage("assets/images/robot.gif"),
                            height: 38,
                            width: 38,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
