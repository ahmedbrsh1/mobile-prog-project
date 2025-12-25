import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// استيراد الصفحات
import 'screens/intro/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/product/product_details_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/cart/success_screen.dart';
import 'screens/profile/wishlist_screen.dart';

// تعريف منبه الثيم (Theme Notifier) للتحكم في الدارك مود من أي مكان
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LazaApp());
}

class LazaApp extends StatelessWidget {
  const LazaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // نستخدم ValueListenableBuilder لمراقبة تغيير الثيم
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Laza',
          
          // إعدادات الثيم الفاتح (Light Theme)
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF9775FA),
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.interTextTheme(),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // إعدادات الثيم الغامق (Dark Theme)
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF9775FA),
            scaffoldBackgroundColor: const Color(0xFF1B1B1B), // لون رمادي غامق احترافي
            textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1B1B1B),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          themeMode: currentMode,

          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/home': (context) => const MainWrapper(),
            '/details': (context) => const ProductDetailsScreen(),
            '/cart': (context) => const CartScreen(),
            '/wishlist': (context) => const WishlistScreen(),
            '/success': (context) => const SuccessScreen(),
          },
        );
      },
    );
  }
}