# UI Group A Polish Report - AI Gromart

Date: October 30, 2026
Target Group: Group A (Login/OTP, Bottom Navigation, Side Menu/Drawer)

---

## 1. Raw Flutter Analyze Output

Full command executed: cmd /c flutter analyze

Output:
Analyzing gromart_app...                                        

   info - 'anonKey' is deprecated and shouldn't be used. Use publishableKey instead. anonKey will be removed in a future major version - lib\main.dart:28:5 - deprecated_member_use
   info - The file name 'NameSetupScreen.dart' isn't a lower_case_with_underscores identifier - lib\pages\login_pages\NameSetupScreen.dart:1:1 - file_names
   info - The file name 'OtpVerifyScreen.dart' isn't a lower_case_with_underscores identifier - lib\pages\login_pages\OtpVerifyScreen.dart:1:1 - file_names
   info - 'Share' is deprecated and shouldn't be used. Use SharePlus instead - lib\screens\chat_screen.dart:36:5 - deprecated_member_use
   info - 'share' is deprecated and shouldn't be used. Use SharePlus.instance.share() instead - lib\screens\chat_screen.dart:36:11 - deprecated_member_use
   info - The file name 'CartItemsList.dart' isn't a lower_case_with_underscores identifier - lib\widgets\CartItemsList.dart:1:1 - file_names
   info - The file name 'CartSummarySection.dart' isn't a lower_case_with_underscores identifier - lib\widgets\CartSummarySection.dart:1:1 - file_names
   info - Don't use 'BuildContext's across async gaps - lib\widgets\CartSummarySection.dart:478:42 - use_build_context_synchronously
   info - Don't use 'BuildContext's across async gaps - lib\widgets\CartSummarySection.dart:484:23 - use_build_context_synchronously
   info - The file name 'CategoryProductsPage.dart' isn't a lower_case_with_underscores identifier - lib\widgets\CategoryProductsPage.dart:1:1 - file_names
   info - The file name 'DashboardScreen.dart' isn't a lower_case_with_underscores identifier - lib\widgets\DashboardScreen.dart:1:1 - file_names
   info - The file name 'SearchResultsPage.dart' isn't a lower_case_with_underscores identifier - lib\widgets\SearchResultsPage.dart:1:1 - file_names
   info - The file name 'SeeAllCategoriesPage.dart' isn't a lower_case_with_underscores identifier - lib\widgets\SeeAllCategoriesPage.dart:1:1 - file_names
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\cart_item_card.dart:35:33 - deprecated_member_use
   info - 'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss - lib\widgets\foldingorder.dart:65:35 - deprecated_member_use
   info - 'scale' is deprecated and shouldn't be used. Use scaleByVector3, scaleByVector4, or scaleByDouble instead - lib\widgets\homewidget.dart:148:17 - deprecated_member_use
   info - Unnecessary braces in a string interpolation - service\bot.dart:9:21 - unnecessary_brace_in_string_interps

Total issues found: 17 issues.

Analysis Verification:
- New issues introduced in lib/core: 0
- New issues introduced in Group A files: 0
- Resolved pre-existing issues in Group A: 3 issues resolved
  * Resolved: library_private_types_in_public_api in lib/pages/bottomnbar.dart
  * Resolved: use_build_context_synchronously in lib/pages/login_pages/NameSetupScreen.dart
  * Resolved: use_build_context_synchronously in lib/pages/login_pages/OtpVerifyScreen.dart
- Pre-existing issues preserved for later:
  * File naming conventions on NameSetupScreen.dart, OtpVerifyScreen.dart, and DashboardScreen.dart are intentionally retained per instruction 5 ("Leave file renames and the anonKey change for later, as separate commits").

---

## 2. Explanation of "Failed" Runs

1. Flutter Analyze Non-Zero Exit Code (Exit Code 1):
   - In Flutter tooling, `flutter analyze` exits with return code 1 if any warning, deprecation, or lint issue is detected in the repository.
   - The initial baseline scan found 20 issues across the codebase.
   - None of these were compiler errors, crashes, or runtime bugs; they were lint warnings (e.g., deprecated `anonKey` in `main.dart`, `SharePlus` migration in `chat_screen.dart`, deprecated `withOpacity` in cart widgets, and PascalCase filenames).
   - Because 17 issues remain in files outside Group A (or deferred renames), `flutter analyze` continues to exit with code 1 until those groups are polished.

2. PowerShell Profile Loading Notice (PSSecurityException):
   - Every PowerShell execution printed a notice:
     "File ... Microsoft.PowerShell_profile.ps1 cannot be loaded because running scripts is disabled on this system."
   - This occurs because Windows ExecutionPolicy restricts unsigned PowerShell profile scripts on this machine.
   - This notice is purely environment-level profile loading and did not terminate or prevent the underlying commands from executing with exit code 0.

3. Regarding the "Failed Command on OtpVerifyScreen.dart":
   - There was NO failed compilation or script error on `OtpVerifyScreen.dart`.
   - The failure was the Dart analyzer flag on `OtpVerifyScreen.dart:86:28` (`use_build_context_synchronously`), where `ScaffoldMessenger.of(context)` was called across an `await` boundary without verifying `mounted`.
   - In Group A, this has been completely resolved by adding `if (!mounted) return;` safeguards before every context interaction.

---

## 3. Git Status and Diff Statistics

### Command: git status --short
 M lib/core/theme/app_colors.dart
 M lib/core/theme/app_spacing.dart
 M lib/pages/bottomnbar.dart
 M lib/pages/homepage.dart
 M lib/pages/login_pages/NameSetupScreen.dart
 M lib/pages/login_pages/OtpVerifyScreen.dart
 M lib/pages/login_pages/login.dart
 M lib/widgets/DashboardScreen.dart
 M lib/widgets/side_menu.dart

### Command: git diff --stat
 lib/core/theme/app_colors.dart             |  37 +++---
 lib/core/theme/app_spacing.dart            |   6 +-
 lib/pages/bottomnbar.dart                  | 126 ++++++++++--------
 lib/pages/homepage.dart                    | 176 ++++++++++++++-----------
 lib/pages/login_pages/NameSetupScreen.dart | 136 +++++++++----------
 lib/pages/login_pages/OtpVerifyScreen.dart | 200 +++++++++++-----------------
 lib/pages/login_pages/login.dart           | 205 +++++++++++++----------------
 lib/widgets/DashboardScreen.dart           |  63 +++++----
 lib/widgets/side_menu.dart                 | 113 +++++++++-------
 9 files changed, 516 insertions(+), 546 deletions(-)

---

## 4. Verification: Logic and Navigation Preservation

The following diff inspection confirms that Supabase authentication calls, state management, validation checks, and navigation destinations are 100% preserved.

### lib/pages/login_pages/login.dart
- Supabase Call:
  await Supabase.instance.client.auth.signInWithOtp(phone: _completePhone);
  (Preserved exactly without change)
- Validation:
  if (!_isValid || _completePhone.isEmpty) ... snackBar "Please enter a valid phone number"
  (Preserved exactly without change)
- Navigation Flow:
  Navigator.push(context, MaterialPageRoute(builder: (context) => OtpVerifyScreen(phone: _completePhone)));
  (Preserved exactly without change; added `if (!mounted) return;` safety check)

### lib/pages/login_pages/NameSetupScreen.dart
- Supabase Call:
  await Supabase.instance.client.auth.updateUser(UserAttributes(data: {'name': name}));
  (Preserved exactly without change)
- Validation:
  if (name.isEmpty) ... snackBar "Please enter your name"
  (Preserved exactly without change)
- Navigation Flow:
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Homewidget()));
  (Preserved exactly without change; added `if (!mounted) return;` safety check)

### lib/pages/login_pages/OtpVerifyScreen.dart
- Supabase Verify Call:
  await Supabase.instance.client.auth.verifyOTP(phone: widget.phone, token: _otpCode, type: OtpType.sms);
  (Preserved exactly without change)
- Supabase Resend Call:
  await Supabase.instance.client.auth.signInWithOtp(phone: widget.phone);
  (Preserved exactly without change)
- Verification Branching:
  if (res.user != null) {
    final hasName = res.user!.userMetadata?['name'] != null;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => hasName ? const Homewidget() : const NameSetupScreen()));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
  }
  (Preserved exactly without change; added `if (!mounted) return;` safety check)
- Countdown Timer:
  30-second Timer.periodic with cancel on dispose
  (Preserved exactly without change)

---

## 5. Visual Changes Per File (10 Lines Each)

### 1. lib/pages/login_pages/login.dart
1. Removed `size.width / 400` multipliers, replacing arbitrary font math with `AppTextStyles`.
2. Constrained hero image with `BoxConstraints(maxHeight: 220)` so it cannot crowd inputs.
3. Added `errorBuilder` to `Image.asset` displaying a fallback basket icon on asset failure.
4. Set headline and subtitle text to responsive tokens with ellipsis overflow safety.
5. Replaced hardcoded mint border with `AppColors.primary` (`#2E7D32`) on focused phone field.
6. Unified button height to standard 48px minimum touch target using `AppButton`.
7. Converted button spinner to standard non-shifting circular progress indicator.
8. Wrapped entire screen inside `ResponsiveBody` with max 600px width constraint on tablets.
9. Added `scrollable: true` with `BouncingScrollPhysics` to avoid overflow in landscape.
10. Applied `AppSpacing.screenPadding` (16px) consistently across the viewport.

### 2. lib/pages/login_pages/NameSetupScreen.dart
1. Removed hardcoded mint AppBar background (`#20DB7E`), applying unified theme AppBar.
2. Centered avatar illustration inside a circular `AppColors.primaryLight` container.
3. Updated icon to `Icons.person_rounded` in `AppColors.primary` for consistent visual hierarchy.
4. Replaced arbitrary text styling with `AppTextStyles.title` and `AppTextStyles.body`.
5. Replaced hardcoded `height: 50` button with standard `AppButton` token styling.
6. Wrapped body in `ResponsiveBody` ensuring tablet viewports remain centered and compact.
7. Replaced `size.width * 0.06` padding with standard `AppSpacing.screenPadding`.
8. Added prefix icon `Icons.edit_outlined` in `AppColors.primary` inside the name text field.
9. Implemented clean `TextEditingController.dispose()` to prevent memory leaks.
10. Added `maxLines: 2` and `TextOverflow.ellipsis` to header text for accessibility font scaling.

### 3. lib/pages/login_pages/OtpVerifyScreen.dart
1. Removed arbitrary `size.width / 400` scaling, preventing ballooned fonts on tablets.
2. Formatted phone number header with `AppTextStyles.title` and single-line ellipsis.
3. Dynamically calculated OTP field box widths (`fieldWidth` clamped 38-48px) using LayoutBuilder.
4. Eliminated horizontal boundary overflow on 320px screens where the 6 OTP boxes previously clipped.
5. Standardized "Verify" button with `AppButton` guaranteeing a 48px touch target height.
6. Replaced raw resend text button with styled `TextButton` meeting 48x48px tap area.
7. Applied `AppColors.primary` to resend action when active, and `AppColors.textSecondary` when disabled.
8. Wrapped content in `ResponsiveBody` with scroll physics to prevent keyboard-related layout crashes.
9. Standardized vertical gaps using `AppSpacing.xl` and `AppSpacing.xxl` tokens.
10. Reduced total file length from 212 lines to 159 lines, conforming to line limits.

### 4. lib/pages/bottomnbar.dart
1. Wrapped bottom navigation container in `SafeArea(bottom: true)` to clear system gesture bars.
2. Replaced `Colors.black87` with `AppColors.navBackground` (`#212529`) matching brand palette.
3. Guaranteed minimum 48x48px interactive touch target area on each navigation tab item.
4. Added `Tooltip` and `Semantics` labels to every navigation item for accessibility.
5. Wrapped tab labels in `Flexible` with `TextOverflow.ellipsis` to prevent overflow at 2.0x font scale.
6. Unified pill selection indicator using `AppRadius.roundBorder` with 250ms animation curve.
7. Updated icons to rounded Material equivalents (`Icons.home_rounded`, etc.) for visual consistency.
8. Replaced private type in public API (`_CustomBottomNavState` -> `State<CustomBottomNav>`).
9. Standardized vertical and horizontal padding using `AppSpacing.sm`.
10. Selected tab displays high-contrast dark text on white pill; unselected tabs display crisp white.

### 5. lib/pages/homepage.dart
1. Removed duplicate `@override` annotation on state creation.
2. Wrapped bottom navigation in `SafeArea(bottom: true)` clearing system gesture indicators.
3. Ensured 48x48px tap target bounds on every navigation item (`minWidth: 48, minHeight: 48`).
4. Replaced hardcoded black87 background with `AppColors.navBackground` (`#212529`).
5. Wrapped selected labels in `Flexible` with `maxLines: 1` and `TextOverflow.ellipsis`.
6. Preserved SVG asset icons for Cart and Orders tabs while applying active/inactive color filters.
7. Added tooltips and semantic labels to all 4 navigation tabs.
8. Reduced horizontal and vertical margins using `AppSpacing.sm` and `AppSpacing.xs`.
9. Selected tab text uses `AppTextStyles.caption` with bold weight for high legibility.
10. Prevented tab label text wrapping from causing vertical layout expansion.

### 6. lib/widgets/side_menu.dart
1. Replaced hardcoded `width: 250` with responsive drawer width (`0.75 * width`, clamped 240-300px).
2. Replaced hardcoded `Colors.blueGrey[900]` with `AppColors.navBackground` (`#212529`).
3. Replaced `Colors.greenAccent` with `AppColors.accent` (`#20DB7E`, mint) with verified contrast.
4. Wrapped bottom "Logout" ListTile in `SafeArea(bottom: true)` to avoid system navigation collision.
5. Guaranteed minimum 48px height touch target on all menu items (`minVerticalPadding: 14`).
6. Added tooltip `"Back to Home"` to drawer header back button.
7. Constrained user name text with `maxLines: 1` and `TextOverflow.ellipsis`.
8. Added subtle divider border beneath header using `.withValues(alpha:)`.
9. Updated icons to rounded Material equivalents for a polished interface.
10. Logout icon and text use `AppColors.error` (`#D32F2F`) for clear destructive state hierarchy.

### 7. lib/widgets/DashboardScreen.dart
1. Replaced hardcoded 250px translation offset with responsive drawer width calculation.
2. Translation offset scales proportionally to screen size (`0.75 * width`, clamped 240-300px).
3. Added tooltip `"Toggle Menu"` to AppBar dashboard leading button.
4. Replaced hardcoded `Colors.black87` scaffold background with `AppColors.navBackground`.
5. Updated main content scale transition factor from `0.8` to `0.85` for a smoother perspective effect.
6. Replaced `ElevatedButton.icon` with standard `AppButton` with 48px minimum touch height.
7. Applied `AppTextStyles.headline` and `AppTextStyles.title` to dynamic dashboard page contents.
8. Added `AppSpacing.screenPadding` to page content container to prevent edge clipping.
9. Standardized corner radius on content card using `AppRadius.xlBorder`.
10. Ensured layout adjusts smoothly without overflow across phone and tablet screens.

---

## 6. Manual Test Plan for Group A

1. Ultra-Narrow Phone Viewport (320x568 - iPhone SE 1st gen):
   - Open Phone Login Screen: verify phone input, flag dropdown, and "Send OTP" button fit without horizontal scrolling.
   - Open OTP Screen: verify all 6 pin boxes render side-by-side without overflowing the right edge.
   - Open Homepage: verify 4 bottom navigation tabs fit without clipping or overflow bars.
   - Open Side Menu: verify drawer width is clamped to 240px and user name truncates cleanly.

2. Standard Phone Viewport (411x891 - Pixel 7):
   - Check bottom navigation: verify bar sits comfortably above the Android gesture navigation bar.
   - Check Name Setup Screen: verify avatar icon, input field, and "Save" button are centered.
   - Check keyboard interaction on Login and OTP: verify inputs pan above the virtual keyboard without layout warnings.

3. Tablet Viewport (600x960 and 800x1280):
   - Open Login Screen: verify `ResponsiveBody` constrains form width to 600px rather than stretching edge-to-edge.
   - Open Side Menu: verify drawer does not exceed 300px max clamp width.
   - Verify bottom navigation bar scales cleanly with centered items.

4. Landscape Mode (568x320 and 891x411):
   - Open Login and OTP: rotate device; verify `ResponsiveBody` enables smooth vertical scrolling (`BouncingScrollPhysics`).
   - Trigger keyboard in landscape: verify no RenderFlex bottom overflow occurs.

5. Accessibility & Large Text Scaling (1.3x and 2.0x system font size):
   - Set system text scale to 1.3x and 2.0x.
   - Check bottom navigation bar: verify selected tab label truncates cleanly with ellipsis rather than wrapping or overflowing.
   - Check "Send OTP", "Verify", and "Save" buttons: verify text scales appropriately without breaking button boundaries.
