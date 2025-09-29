# project_01

A new Flutter project.
# AI Gromart – Smart Grocery Shopping App

AI Gromart is a Flutter-based **grocery shopping application** powered by **Supabase authentication**, **Provider state management**, and an **AI chatbot (Gemini)**.  
The app helps users shop smarter, live fresher, and get their groceries delivered with ease.

---

## Features

- **Phone Number OTP Authentication**  
  Secure login using Supabase OTP (SMS-based verification).

- **Personalized Profiles**  
  Users can set up their name and profile information after logging in.

- **AI Chatbot (Gemini Integration)**  
  In-app chatbot that helps users with product queries, smart grocery suggestions, and customer support.

- **Cart & Orders (Provider)**  
  Cart, order history, and promo code logic handled with `provider` for reactive state management.

- **Beautiful Onboarding**  
  Includes animated Lottie splash screens and a welcoming intro page.

- **Clean & Modern UI**  
  Minimal design with friendly illustrations for login, OTP, and shopping experience.

---

## Screenshots

| Splash Screen | Login | OTP Verify | Name Setup | Chatbot |
|---------------|-------|------------|------------|---------|
| ![Splash](assets/screenshots/splash.png) | ![Login](assets/screenshots/login.png) | ![OTP](assets/screenshots/otp.png) | ![Name](assets/screenshots/name.png) | ![Chatbot](assets/screenshots/chatbot.png) |

---

## Tech Stack

- **Frontend:** [Flutter](https://flutter.dev/)  
- **Backend & Auth:** [Supabase](https://supabase.com/)  
- **State Management:** [Provider](https://pub.dev/packages/provider)  
- **AI Chatbot:** [Google Gemini](https://ai.google.dev/) integrated in `ChatProvider`  
- **Animations:** [Lottie](https://lottiefiles.com/)  

---

## Project Structure

lib/
├── main.dart # App entry point
├── pages/
│ ├── login_pages/
│ │ ├── PhoneLoginScreen.dart
│ │ ├── OtpVerifyScreen.dart
│ │ └── NameSetupScreen.dart
│ ├── homepage.dart
│ ├── Welcomepage.dart
│ └── chatbot.dart
├── provider/
│ ├── cart_provider.dart
│ ├── orders_provider.dart
│ ├── promo_code_provider.dart
│ └── chat_provider.dart # Gemini AI integration
└── widgets/
└── homewidget.dart


---

## Authentication & Flow

1. **User enters phone number** → Supabase sends OTP.  
2. **User enters OTP** → Verified with Supabase.  
3. **First-time login?** → Redirected to **Name Setup Screen**.  
4. **Returning user** → Redirected to **Homepage**.  
5. **User interacts with Chatbot** → Gemini answers queries & suggests groceries.  
6. **Cart & Orders** → Managed via Provider.  

---

## Getting Started

### Prerequisites
- Install [Flutter SDK](https://docs.flutter.dev/get-started/install)  
- Create a [Supabase Project](https://supabase.com/) and enable **Phone OTP Auth**  
- Get **Gemini API Key** from [Google AI Studio](https://aistudio.google.com/)  
- Add your `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `GEMINI_API_KEY` to the Flutter project

### Installation
```bash
git clone https://github.com/your-username/ai-gromart.git
cd ai-gromart
flutter pub get
flutter run

### Roadmap

 Supabase OTP Authentication

 Name setup after first login

 Provider for Cart, Orders & Promo codes

 Gemini Chatbot integration

 Payment Gateway Integration

 Push Notifications for orders

 Multi-language support

Contributing

Contributions are welcome!
Please fork the repository and create a pull request with improvements.

License

This project is licensed under the MIT License.

Author

Developed with by Ashraf

