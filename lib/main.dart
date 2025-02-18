import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/Home Pages/profiles pages/About Us.dart';
import 'pages/Home Pages/profiles pages/Notifications.dart';
import 'pages/Home Pages/profiles pages/SubscriptionDetailsPage.dart';
import 'pages/Splash_Screen.dart';
import 'screens/AddMenuItemPage.dart';
import 'screens/addmenu.dart';
import 'screens/dashboard_screen.dart';
import 'package:your_project_name/pages/food_list_page.dart';
import 'package:your_project_name/pages/model/food_item.dart';
import 'pages/login pages/login.dart';
import 'pages/login pages/signup.dart';
import 'pages/Home Pages/food pages/todays offer/10off.dart';
import 'pages/Home Pages/food pages/todays offer/15.off.dart';
import 'pages/Home Pages/food pages/todays offer/20 off.dart';
import 'pages/Home Pages/menu.dart';
import 'pages/Home Pages/profiles pages/realtime.dart';
import 'pages/login pages/forgetpassword.dart';
import 'pages/login pages/forgetpassword2.dart';
import 'pages/Home Pages/profiles pages/logout.dart';
import 'pages/Home Pages/logo.dart';
import 'pages/Home Pages/home.dart';
import 'pages/Home Pages/profiles pages/payment.dart';
import 'pages/Home Pages/food pages/Nonevegfood.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override Widget build(BuildContext context)
  {
    return MaterialApp( title: 'DabbaWala',
      theme: ThemeData(
      primarySwatch: Colors.blue, ),
      home: const SplashScreen(),
      routes: {

        'AddMenuItemPage': (context) => AddMenuItemPage(),
        'Menu': (context) => Menu(),
        'login': (context) => login(),
        'DashboardScreen': (context) => DashboardScreen(),
        'signup': (context) => signup(),
        'forgetpassword': (context) => forgetpassword(),
        'forgetpassword2': (context) => forgetpassword2(),
        'FoodDeliveryScreen': (context) => FoodDeliveryScreen(),
        'FoodItemScreen': (context) => FoodListPage(),
        'NotificationsPage': (context) => NotificationsPage(),
        'AboutUsPage': (context) => AboutUsPage(),
        'FoodGoHomePage': (context) => FoodGoHomePage(),
        'SubscriptionDetailsPage': (context) => SubscriptionDetailsPage(),
        'MenuPage': (context) => MenuPage(),
        'logout': (context) => logout(),
        'payment': (context) => payment(),
        'first': (context) => first(),
        'second': (context) => second(),
        'third': (context) => third(),
        'Realtime': (context) => Realtime(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
