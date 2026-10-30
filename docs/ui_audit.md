# UI Audit Report - AI Gromart Flutter App

**Audit Date:** October 30, 2026  
**Flutter Version:** Flutter 3.38.5 • Dart 3.10.4  
**Opacity Policy:** Since Flutter version >= 3.27, all alpha transparency must use `.withValues(alpha: ...)` instead of deprecated `.withOpacity()`.

---

## 1. Project & Screen Inventory

### Packages & Environment (`pubspec.yaml`)
- **SDK Constraints:** Dart SDK `^3.3.0`, Flutter SDK
- **Key UI Packages:**
  - `carousel_slider: ^5.1.1`
  - `lottie: ^3.3.2`
  - `flutter_svg: ^2.0.9`
  - `google_fonts: ^6.2.1`
  - `animations: ^2.0.11`
  - `flutter_spinkit: ^5.2.1`
  - `loading_animation_widget: ^1.3.0`
  - `gif: ^2.3.0`
  - `otp_text_field: ^1.1.3`
  - `intl_phone_field: ^3.2.0`
  - `gpt_markdown: ^1.1.4`
  - `share_plus: ^12.0.0`
  - `provider: ^6.1.2`
  - `supabase_flutter: ^2.10.1`

### Screens & Widgets Line Count Breakdown

| File Path | Type | Line Count | Status / Notes |
| :--- | :--- | :---: | :--- |
| `lib/main.dart` | App Entry / Theme | 79 (92 total) | Needs full Material 3 Design System token setup |
| `lib/pages/bottomnbar.dart` | Navigation Widget | 79 (86 total) | Standalone bottom bar, no SafeArea, tight tap targets |
| `lib/pages/homepage.dart` | Root Navigation Screen | 110 (118 total) | Contains duplicated bottom nav bar, no SafeArea |
| `lib/pages/product_detail_page.dart` | Screen | 138 (147 total) | Non-scrollable Column, Spacer crash on small screens |
| `lib/pages/product_list_screen.dart` | Shared Widget | 27 (30 total) | Fixed 2-column GridView, rigid 0.75 aspect ratio |
| `lib/pages/welcomepage.dart` | Splash & Welcome Screen | 110 (118 total) | Non-scrollable Column, 800px Lottie asset overflow |
| `lib/pages/login_pages/login.dart` | Screen | 155 (172 total) | Arbitrary MediaQuery text scaling (`size.width / 400`) |
| `lib/pages/login_pages/NameSetupScreen.dart` | Screen | 113 (128 total) | PascalCase name, fixed height buttons, hardcoded colors |
| `lib/pages/login_pages/OtpVerifyScreen.dart` | Screen | 189 (212 total) | Exceeds 180 lines, OTP field overflows padding |
| `lib/screens/chat_screen.dart` | Screen | 182 (195 total) | Exceeds 180 lines, no input SafeArea, low text contrast |
| `lib/widgets/CartItemsList.dart` | Shared Widget | 96 (99 total) | Untruncated product names, unconstrained price |
| `lib/widgets/cartpage.dart` | Screen | 37 (41 total) | Missing empty state |
| `lib/widgets/CartSummarySection.dart` | Feature Section | 465 (503 total) | **Over 500 lines**: must be split into 5-7 sub-widgets |
| `lib/widgets/cart_item_card.dart` | Shared Widget | 112 (119 total) | Deprecated `.withOpacity()`, untruncated name |
| `lib/widgets/CategoryProductsPage.dart` | Screen | 41 (45 total) | Bare text empty state, unconstrained product title |
| `lib/widgets/DashboardScreen.dart` | Container Screen | 127 (143 total) | Hardcoded 250px translation offset, double Scaffold |
| `lib/widgets/foldingorder.dart` | Shared Widget | 115 (126 total) | Deprecated `.withOpacity()`, double padding with parent |
| `lib/widgets/homewidget.dart` | Screen | 307 (328 total) | **Over 300 lines**: must be split into 5-7 sub-widgets |
| `lib/widgets/order.dart` | Screen | 114 (124 total) | Missing empty state, bottom items hidden behind nav bar |
| `lib/widgets/productcart.dart` | Shared Widget | 89 (92 total) | **Critical**: forced 200px height causes card overflow |
| `lib/widgets/profile.dart` | Screen | 103 (109 total) | Header Row overflows horizontally on narrow phones |
| `lib/widgets/searchbar.dart` | Shared Widget | 45 (48 total) | 40px top gap under AppBar, failing text contrast 1.4:1 |
| `lib/widgets/SearchResultsPage.dart` | Screen | 31 (35 total) | Non-scrollable body, cut-off products |
| `lib/widgets/SeeAllCategoriesPage.dart` | Screen | 74 (78 total) | Fixed 3-column GridView, titles clip on large text scale |
| `lib/widgets/side_menu.dart` | Shared Widget | 129 (142 total) | Hardcoded 250px width, logout button has no SafeArea |
| `lib/widgets/tabbar.dart` | Shared Widget | 71 (77 total) | Rigid 45px height overflows when text scale >= 1.3 |

---

## 2. Issues Grouped by Severity

### A. Crash / RenderFlex Overflow (Highest Priority)

1. **`lib/widgets/productcart.dart` (Lines 12–23, 34–85)**
   - **Issue:** Fixed overall height `SizedBox(width: 150, height: 200)`. Inside the 200px box: Card padding (24px) + fixed image height (120px) + SizedBox (13px) = 157px used. That leaves only 43px for `Expanded(child: Column(...))`. The Column contains product title, weight, spacer, price, and IconButton (total height > 58px).
   - **Result:** Constant RenderFlex overflow on standard devices; severe overflow when text scale is 1.3 or 2.0.
   - **Fix:** Remove rigid outer `SizedBox(height: 200)`, use adaptive aspect ratio or flexible layout sizing to card content, set image to `AspectRatio(aspectRatio: 1.0, child: ...)` or bounded height with BoxFit.cover.

2. **`lib/widgets/productcart.dart` (Lines 52–82)**
   - **Issue:** `Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(price), IconButton(...)])`. Price `Text` is not wrapped in `Flexible` or `Expanded`.
   - **Result:** Horizontal overflow on large font scale (1.3 / 2.0) or longer price/unit text.
   - **Fix:** Wrap price text in `Expanded` or `Flexible` with `maxLines: 1`.

3. **`lib/widgets/profile.dart` (Lines 20–51)**
   - **Issue:** Header `Row(children: [CircleAvatar(radius: 40), SizedBox(16), Column(children: [Text(name), Text(email), Text(phone)])])`. The inner Column is NOT wrapped in `Expanded` or `Flexible`.
   - **Result:** On 320px width screens or text scale >= 1.3, the long email `ashrafsisodya478@email.com` causes a horizontal RenderFlex overflow on the right edge.
   - **Fix:** Wrap the inner `Column` in `Expanded`, specify `overflow: TextOverflow.ellipsis`.

4. **`lib/pages/product_detail_page.dart` (Lines 37–144)**
   - **Issue:** `Scaffold(body: Padding(child: Column(children: [..., Spacer(), SizedBox(child: ElevatedButton(...))])))`. Body is NOT scrollable.
   - **Result:** On small screens (320x568, 360x640), landscape mode, or system font scale 1.3/2.0, `Spacer()` collapses to zero and causes a 100+ px bottom RenderFlex overflow.
   - **Fix:** Wrap content in `SingleChildScrollView(physics: BouncingScrollPhysics(), child: ...)` or use a scrollable Column with bottom pinned bar in `bottomNavigationBar`.

5. **`lib/pages/product_detail_page.dart` (Lines 100–110)**
   - **Issue:** `Row(children: const [Icon, SizedBox, Text("Available in Stock"), SizedBox, Icon, SizedBox, Text("4.8 Ratings")])`.
   - **Result:** Hardcoded strings in an unconstrained Row overflow horizontally on 320px width or enlarged font scales.
   - **Fix:** Wrap items in `Flexible` or replace with a responsive `Wrap` / Chip layout.

6. **`lib/pages/welcomepage.dart` (Lines 21–25)**
   - **Issue:** `Lottie.asset(..., width: 800, height: 300)`. Fixed width 800 exceeds viewport on all mobile devices.
   - **Fix:** Constrain width to `MediaQuery.sizeOf(context).width * 0.8` or fit inside an `AspectRatio` / `FittedBox`.

7. **`lib/pages/welcomepage.dart` (Lines 59–115)**
   - **Issue:** `WelcomeIntroPage` uses a non-scrollable `Column` with `Spacer()`.
   - **Result:** Bottom overflow on 320x568 screen, landscape, or 2.0 text scale.
   - **Fix:** Wrap Column in `SingleChildScrollView` and place button in `SafeArea`.

8. **`lib/pages/product_list_screen.dart` (Lines 18–23)**
   - **Issue:** `SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75)`.
   - **Result:** On 600px+ tablets, cards stretch excessively wide; on 320px phones or 2.0 text scale, fixed aspect ratio 0.75 clips card content or causes internal overflows.
   - **Fix:** Use `SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 220, childAspectRatio: ...)` to adapt columns responsively.

9. **`lib/widgets/SeeAllCategoriesPage.dart` (Lines 26–31)**
   - **Issue:** `SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.8)`. Grid cell width on 320px screen is only ~91px.
   - **Result:** Category title wraps and overflows cell bounds on font scale >= 1.3.
   - **Fix:** Use `SliverGridDelegateWithMaxCrossAxisExtent` or calculate responsive crossAxisCount.

10. **`lib/widgets/homewidget.dart` (Lines 288–324)**
    - **Issue:** Horizontal categories row has rigid `SizedBox(height: 110)`. Inside, Column has `Container(70x70) + SizedBox(6) + Text(title, fontSize: 14)`.
    - **Result:** When font scale is 1.3 or 2.0, the text exceeds the remaining 34px, triggering vertical RenderFlex overflow.
    - **Fix:** Remove rigid outer height or compute dynamically, add `maxLines: 1` and `TextOverflow.ellipsis`.

11. **`lib/widgets/tabbar.dart` (Lines 23–75)**
    - **Issue:** Outer container has hardcoded `SizedBox(height: 45)`.
    - **Result:** Text scale 1.3/2.0 forces Container content height > 45px, causing vertical RenderFlex overflow.
    - **Fix:** Remove fixed height; allow intrinsic height or use responsive padding tokens.

12. **`lib/pages/login_pages/OtpVerifyScreen.dart` (Lines 154–163)**
    - **Issue:** `OTPTextField(length: 6, width: size.width, fieldWidth: size.width * 0.12)`.
    - **Result:** Parent padding is `size.width * 0.06` on both sides (12% total margin). Passing `width: size.width` forces the field to extend past the screen padding, causing horizontal overflow/clipping.
    - **Fix:** Pass available width (`size.width * 0.88`) or let `OTPTextField` expand within its padded container.

13. **`lib/widgets/SearchResultsPage.dart` (Lines 23–33)**
    - **Issue:** `ProductList` (which specifies `physics: NeverScrollableScrollPhysics()` and `shrinkWrap: true`) is placed directly as `Scaffold.body` without a scrollable parent.
    - **Result:** User cannot scroll the search results page. Products beyond viewport are cut off.
    - **Fix:** Wrap `ProductList` in `SingleChildScrollView` or remove `NeverScrollableScrollPhysics` when `ProductList` is a standalone page.

14. **`lib/widgets/CartSummarySection.dart` (Lines 309–498)**
    - **Issue:** The summary sheet Column contains promo chip, promo text field, offers button, price breakdown rows, and checkout button, but is not scrollable.
    - **Result:** When virtual keyboard opens to enter a promo code on smaller phones or text scale is 1.3/2.0, bottom RenderFlex overflow occurs.
    - **Fix:** Wrap Column in `SingleChildScrollView` with `viewInsets` padding.

---

### B. Layout Gaps & Obscured Content

1. **`lib/pages/homepage.dart` (Lines 34–115) & `lib/pages/bottomnbar.dart` (Lines 32–84)**
   - **Issue:** Custom bottom navigation bar lacks `SafeArea(bottom: true)`.
   - **Result:** Navigation icons/labels collide with Android gesture bar or iOS home indicator.
   - **Fix:** Wrap bottom navigation container in `SafeArea`.

2. **`lib/widgets/homewidget.dart` (Lines 216–218)**
   - **Issue:** `SingleChildScrollView` has no bottom padding after `ProductList`.
   - **Result:** Last row of products is hidden behind the floating bottom navigation bar.
   - **Fix:** Add bottom padding (e.g. `SizedBox(height: 100)` or token-based bottom navigation inset).

3. **`lib/widgets/order.dart` (Lines 21–36) & `lib/widgets/profile.dart` (Lines 14–106)**
   - **Issue:** `ListView.builder` / `ListView` lacks bottom padding.
   - **Result:** Final order card and Logout tile are partially covered by bottom navigation bar.
   - **Fix:** Add `padding: EdgeInsets.only(bottom: 100)` to the scroll view.

4. **`lib/widgets/searchbar.dart` (Line 17)**
   - **Issue:** `margin: const EdgeInsets.only(top: 40, left: 20, right: 20)`.
   - **Result:** Combined with `homewidget.dart` AppBar height 90, creates an awkward 130px empty gap above the search field.
   - **Fix:** Reduce top margin to design token `AppSpacing.md` (16px) or `AppSpacing.sm` (8px).

5. **`lib/widgets/homewidget.dart` (Line 155)**
   - **Issue:** Hardcoded `toolbarHeight: 90` on AppBar.
   - **Result:** Disproportionate empty space in the header area.
   - **Fix:** Standardize AppBar height to default (56px) or compact 64px with proper vertical alignment.

6. **`lib/widgets/foldingorder.dart` (Line 59) & `lib/widgets/order.dart` (Line 27)**
   - **Issue:** Double padding: `order.dart` applies `Padding(all: 8.0)` and `foldingorder.dart` applies `margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8)`.
   - **Result:** Gutter is 24px horizontally and 16px vertically, creating uneven whitespace.
   - **Fix:** Remove redundant outer Padding in `order.dart`.

7. **`lib/screens/chat_screen.dart` (Lines 162–190)**
   - **Issue:** Chat input row Container has no `SafeArea(bottom: true)`.
   - **Result:** Text input and send button sit flush on the hardware edge and overlap system navigation.
   - **Fix:** Wrap chat input Container in `SafeArea(top: false, child: ...)`.

8. **`lib/widgets/side_menu.dart` (Lines 130–137)**
   - **Issue:** Logout `ListTile` at bottom of drawer Column has no `SafeArea(bottom: true)`.
   - **Result:** Logout button is obscured by system gesture bar.
   - **Fix:** Wrap bottom actions in `SafeArea`.

9. **`lib/widgets/DashboardScreen.dart` (Lines 117–121) & `lib/widgets/homewidget.dart` (Line 147)**
   - **Issue:** Hardcoded translation `Matrix4.translationValues(250, 0, 0)` and `220`.
   - **Result:** Leaves only 70-100px of visible screen on small devices (320px width), while on tablets it is too small.
   - **Fix:** Make drawer offset proportional (e.g. `size.width * 0.75` capped at max 280px).

10. **`lib/widgets/homewidget.dart` (Lines 131, 151) & `lib/widgets/DashboardScreen.dart` (Lines 100, 126)**
    - **Issue:** Double `Scaffold` nesting. A parent `Scaffold` wraps a child `Scaffold`.
    - **Result:** Competing window insets, double status bar handling, and keyboard resize quirks.
    - **Fix:** Flatten to a single `Scaffold` with custom drawer or stack structure.

11. **`lib/pages/login_pages/login.dart` & `OtpVerifyScreen.dart`**
    - **Issue:** `final textScale = size.width / 400;` used to scale font sizes dynamically (`22 * textScale`, `16 * textScale`).
    - **Result:** Font balloons to huge sizes on tablets/web and shrinks below 12pt on narrow phones.
    - **Fix:** Remove hardcoded MediaQuery math; use standard Typography tokens from `AppTextStyles`.

---

### C. Visibility, Contrast & Touch Targets

1. **`lib/widgets/searchbar.dart` (Line 35)**
   - **Issue:** `hintStyle: TextStyle(color: Color(0xffDDDADA))` on white background.
   - **Result:** Contrast ratio is 1.4:1 (fails WCAG AA 4.5:1 requirement). Hint text is invisible in bright sunlight.
   - **Fix:** Change hint color to `AppColors.textSecondary` / `Colors.grey.shade600` (contrast ratio > 4.5:1).

2. **`lib/screens/chat_screen.dart` (Lines 90–106)**
   - **Issue:** User bubble has background `Color(0xFF4CAF50)` with `Colors.white` text.
   - **Result:** Contrast ratio is ~2.8:1 (fails WCAG AA 4.5:1 requirement).
   - **Fix:** Use darker brand green `Color(0xFF00796B)` or `Color(0xFF1B5E20)` or adjust text color.

3. **`lib/widgets/productcart.dart` (Lines 47–50)**
   - **Issue:** `Text("weight ...", style: TextStyle(color: Colors.grey, fontSize: 12))` on pastel tinted card backgrounds.
   - **Result:** Low contrast (< 3.0:1) on light pastel backgrounds.
   - **Fix:** Use `AppColors.textSecondary` with verified contrast >= 4.5:1.

4. **`lib/widgets/productcart.dart` (Lines 63–80)**
   - **Issue:** `IconButton` with `constraints: const BoxConstraints()` and `padding: EdgeInsets.zero`.
   - **Result:** Touch target is 24x24 px (fails minimum 48x48 px standard). Hard to tap for mobile users.
   - **Fix:** Set minimum interactive tap target to 48x48 px using `constraints: BoxConstraints(minWidth: 48, minHeight: 48)`.

5. **`lib/pages/product_detail_page.dart` (Lines 58–83)**
   - **Issue:** Quantity `-` and `+` `IconButton` widgets have no `tooltip` or semantic labels.
   - **Fix:** Add `tooltip: "Decrease quantity"` and `tooltip: "Increase quantity"`.

6. **`lib/screens/chat_screen.dart` (Lines 179–187)**
   - **Issue:** Send `IconButton` has no `tooltip`.
   - **Fix:** Add `tooltip: "Send message"`.

7. **`lib/widgets/homewidget.dart` (Lines 167–188)**
   - **Issue:** Animated GIF robot action button is wrapped in bare `GestureDetector` without tooltip or semantic label.
   - **Fix:** Wrap with `Semantics(label: "Open Gromart AI Assistant", ...)` or `Tooltip`.

8. **`lib/widgets/order.dart` (Lines 96–123)**
   - **Issue:** Status chip text `Colors.black54` on `Colors.orange.shade100` has low contrast (~3.2:1).
   - **Fix:** Use darker text token with compliant contrast.

---

### D. Inconsistencies Across Screens

1. **Currency Symbol Fragmentation:**
   - `CartItemsList.dart` (Lines 57, 88): `\$` (USD).
   - `cart_item_card.dart` (Line 108): `\$`.
   - `CartSummarySection.dart` (Lines 424–440): `\$`.
   - `order.dart` (Lines 56, 73): `\$`.
   - `productcart.dart` (Line 56): `\$`.
   - `product_detail_page.dart` (Line 43): **No currency symbol at all** (`12.00 unit / weight`).
   - `models/order.dart`: mentions `₹` in comments and test data.
   - **Fix:** Centralize currency formatting in a single helper (`AppFormatters.currency(amount)` or standard symbol `₹`).

2. **Brand Green Palette Inconsistency:**
   - `Color.fromARGB(255, 32, 219, 126)`: used in Login, NameSetup, OtpVerify.
   - `Color(0xFF008C73)`: used in WelcomeIntroPage.
   - `Color(0xFF4CAF50)`: used in ChatScreen.
   - `Colors.green`: used in MainApp, Homewidget, Cart, Orders, Detail.
   - `Color.fromARGB(255, 92, 236, 97)`: used in Welcomepage splash.
   - **Fix:** Define single unified brand palette in `AppColors`: `primary`, `primaryLight`, `primaryDark`.

3. **Inconsistent Border Radii:**
   - 8px: `order.dart` reorder button.
   - 10px: `product_detail_page.dart` button.
   - 12px: `login.dart`, `NameSetupScreen.dart`, `CartItemsList.dart`.
   - 13px: `homewidget.dart` carousel.
   - 14px: `CartSummarySection.dart` checkout button.
   - 15px: `searchbar.dart`.
   - 16px: `cart_item_card.dart`, `foldingorder.dart`, `productcart.dart`.
   - 20px: `chat_screen.dart`, `tabbar.dart`, `homewidget.dart` category images.
   - 24px: `CartSummarySection.dart` modal.
   - 30px: `bottomnbar.dart`, `homepage.dart` navigation bar.
   - **Fix:** Consolidate to `AppRadius` tokens: `sm (8)`, `md (12)`, `lg (16)`, `xl (24)`, `round (999)`.

4. **Inconsistent AppBar Themes:**
   - `profile.dart`: `backgroundColor: Colors.green`, white title.
   - `product_detail_page.dart`: `backgroundColor: Colors.white`, elevation 0, black title.
   - `order.dart`: `backgroundColor: Colors.white`, elevation 0, black title.
   - `NameSetupScreen.dart`: `backgroundColor: Color.fromARGB(255, 32, 219, 126)`.
   - **Fix:** Unify via `AppBarTheme` in `AppTheme.lightTheme`.

5. **Product Name Truncation Discrepancies:**
   - `productcart.dart`: `maxLines: 1`. (Rule requires 2 lines for product names).
   - `CartItemsList.dart`: no maxLines.
   - `cart_item_card.dart`: no maxLines.
   - `order.dart`: no maxLines.
   - **Fix:** Standardize product titles to `maxLines: 2, overflow: TextOverflow.ellipsis` and prices to `maxLines: 1`.

---

### E. Minor Issues & Code Quality Violations

1. **Files Exceeding 180 Lines:**
   - `lib/widgets/CartSummarySection.dart`: 465 lines (503 total). Must be split into 5-7 feature files (e.g. `promo_input.dart`, `promo_sheet.dart`, `price_breakdown.dart`, `checkout_button.dart`).
   - `lib/widgets/homewidget.dart`: 307 lines (328 total). Must be split into 5-7 feature files (`home_header.dart`, `home_search_bar.dart`, `home_banner.dart`, `home_categories.dart`, `home_product_section.dart`).
   - `lib/pages/login_pages/OtpVerifyScreen.dart`: 189 lines (212 total).
   - `lib/screens/chat_screen.dart`: 182 lines (195 total).

2. **Deprecated APIs:**
   - `cart_item_card.dart` line 35: `Colors.black.withOpacity(0.05)`.
   - `foldingorder.dart` line 65: `Colors.black.withOpacity(0.05)`.
   - `homewidget.dart` line 148: `Matrix4..scale()`.
   - `chat_screen.dart` line 36: `Share.share()` (should use `SharePlus.instance.share()`).
   - `main.dart` line 27: `anonKey` deprecated in Supabase (use `publishableKey`).

3. **Lint & Code Style Issues:**
   - Async gap `BuildContext` usage (`use_build_context_synchronously`) in `NameSetupScreen.dart:40`, `OtpVerifyScreen.dart:86`, `CartSummarySection.dart:478, 484`.
   - Non-standard PascalCase file names: `NameSetupScreen.dart`, `OtpVerifyScreen.dart`, `CartItemsList.dart`, `CartSummarySection.dart`, `CategoryProductsPage.dart`, `DashboardScreen.dart`, `SearchResultsPage.dart`, `SeeAllCategoriesPage.dart`.
   - Rebuild loop danger: `WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom())` in `chat_screen.dart` called unconditionally inside `build()`.
   - Duplicate `@override` in `homepage.dart` lines 11-12.

4. **Missing States:**
   - Empty cart state missing in `cartpage.dart`.
   - Empty orders state missing in `order.dart`.
   - Empty chat state missing in `chat_screen.dart`.
   - Raw unstyled empty text in `SearchResultsPage.dart` and `CategoryProductsPage.dart`.
   - Missing `errorBuilder` on all `Image.asset` calls (`productcart.dart`, `product_detail_page.dart`, `CartItemsList.dart`, `cart_item_card.dart`, `order.dart`, `welcomepage.dart`).

---

## 3. Plan for Stage 1 & Stage 2 Execution

### Stage 1: Design System
1. Create `lib/core/theme/`:
   - `app_colors.dart`: Consolidated palette preserving brand identity.
   - `app_spacing.dart`: 4 / 8 / 12 / 16 / 24 / 32 scale; screen padding 16.
   - `app_radius.dart`: 8 / 12 / 16 / 24 / round.
   - `app_text_styles.dart`: Standardized typography scale with compliant contrast.
   - `app_theme.dart`: Material 3 `ThemeData` with component themes for AppBar, ElevatedButton, OutlinedButton, TextButton, InputDecoration, Card, Chip, NavigationBar/BottomNavigationBar, SnackBar, Dialog.
2. Create `lib/core/widgets/`:
   - `app_button.dart`: Standardized primary and secondary buttons with 48px touch targets.
   - `app_card.dart`: Unified elevation, border radius, and padding.
   - `empty_state.dart`: Clean illustration/icon + message + optional action.
   - `error_state.dart`: Standard error presentation.
   - `loading_view.dart`: Centered consistent spinner.
   - `responsive_body.dart`: Max width 600 on tablet, 1100 on desktop, LayoutBuilder breakpoints (<600, 600-900, >900).
3. Apply in `lib/main.dart`.

### Stage 2: Grouped Screen Execution (One group at a time, stopping for approval)
- **Group A:** Login / OTP screen (`login.dart`, `NameSetupScreen.dart`, `OtpVerifyScreen.dart`), Bottom Navigation (`bottomnbar.dart`, `homepage.dart`), Side Menu / Drawer (`side_menu.dart`, `DashboardScreen.dart`).
- **Group B:** Home screen (`homewidget.dart` decomposed into modular widgets, search bar, carousel banner, categories row, custom tabs).
- **Group C:** Product list and detail (`product_list_screen.dart`, `productcart.dart`, `product_detail_page.dart`).
- **Group D:** Cart screen and CartSummarySection (`cartpage.dart`, `CartItemsList.dart`, `cart_item_card.dart`, `CartSummarySection.dart` decomposed into modular widgets).
- **Group E:** Orders list and order detail (`order.dart`, `foldingorder.dart`).
- **Group F:** Chat screen (`chat_screen.dart`).
- **Group G:** Address management and delivery widgets (`profile.dart`, delivery integration).
