import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:your_project_name/pages/Home%20Pages/profile.dart';
import 'pages/Home Pages/profiles pages/About Us.dart';
import 'pages/Home Pages/profiles pages/Notifications.dart';
import 'pages/Home Pages/profiles pages/SubscriptionDetailsPage.dart';
import 'pages/Home Pages/profiles pages/address.dart';
import 'pages/Home Pages/profiles pages/subpay.dart';
import 'pages/Splash_Screen.dart';
import 'screens/AddMenuItemPage.dart';
import 'screens/addmenu.dart';
import 'screens/dabbawala_list_screen.dart';
import 'screens/dabbawala_panel.dart';
import 'screens/dashboard_screen.dart';
import 'package:your_project_name/pages/food_list_page.dart';
import 'package:your_project_name/pages/model/food_item.dart';
import 'pages/login pages/login.dart';
import 'pages/login pages/signup.dart';
import 'pages/Home Pages/menu.dart';
import 'pages/Home Pages/profiles pages/realtime.dart';
import 'pages/login pages/forgetpassword.dart';
import 'pages/login pages/forgetpassword2.dart';
import 'pages/Home Pages/profiles pages/logout.dart';
import 'pages/Home Pages/logo.dart';
import 'pages/Home Pages/home.dart';

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
       'DabbawalaPanelPage': (context) => DabbawalaPanelPage(),
        'DashboardScreen': (context) => DashboardScreen(),
        'signup': (context) => signup(),
        'forgetpassword': (context) => forgetpassword(),
        'forgetpassword2': (context) => forgetpassword2(),
        'FoodDeliveryScreen': (context) => FoodDeliveryScreen(),
        'ProfilePage': (context) => ProfilePage(),
        'FoodItemScreen': (context) => FoodListPage(),
        'NotificationsPage': (context) => NotificationsPage(),
        'AboutUsPage': (context) => AboutUsPage(),
        'FoodGoHomePage': (context) => FoodGoHomePage(),
        'SubscriptionDetailsPage': (context) => SubscriptionDetailsPage(),
        'MenuPage': (context) => MenuPage(),
        'logout': (context) => logout(),
        'Subpay': (context) => Subpay(),
        'Realtime': (context) => Realtime(),
        'AddressPage': (context) => AddressPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
