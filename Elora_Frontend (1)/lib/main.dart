import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/my_plants_page.dart';
import 'package:flutter_application_1/pages/my_profile.dart';
import 'package:flutter_application_1/pages/watering_page.dart';
import 'pages/login_page.dart';
import 'pages/create_account_page.dart';
import 'pages/home_page.dart';
import 'pages/market_page.dart';
import 'pages/main_navigation_page.dart';
import 'pages/admin_page.dart';

import 'pages/plant_detalies_page.dart';

import 'pages/cart_page.dart';
import 'pages/my_orders_page.dart';
import 'favorites_page.dart';
import 'notifications_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'about_page.dart';
import 'policy_page.dart';

import 'pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const PlantApp(), // Wrap your app
  );
}

class PlantApp extends StatelessWidget {
  const PlantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/create': (context) => const CreateAccountPage(),
        '/main_nav': (context) => const MainNavigationPage(),
        '/home': (context) => const HomePage(),
        '/market': (context) => const MarketPage(),

        '/cart': (context) => const CartPage(),
        '/orders': (context) => const MyOrdersPage(),
        '/favorites': (context) => const FavoritesPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/profile': (context) => ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/about': (context) => const AboutPage(),
        '/policy': (context) => const PolicyPage(),
        '/watering': (context) => const WateringPage(),
        '/myplants': (context) => const MyPlantsPage(),
        '/myprofile': (context) => const MyProfilePage(),
        '/admin': (context) => const AdminPage(),
      },
    );
  }
}
