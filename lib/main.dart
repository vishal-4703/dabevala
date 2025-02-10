import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/Home Pages/profiles pages/Notifications.dart';
import 'pages/Home Pages/profiles pages/SubscriptionDetailsPage.dart';
import 'screens/AddMenuItemPage.dart';
import 'screens/addmenu.dart';
import 'screens/dashboard_screen.dart';
import 'package:your_project_name/pages/food_list_page.dart';
import 'package:your_project_name/pages/model/food_item.dart';
import 'pages/Home Pages/food pages/food iteam page/bangda.dart';
import 'pages/Home Pages/food pages/food iteam page/butterchicken.dart';
import 'pages/Home Pages/food pages/food iteam page/chicken non.dart';
import 'pages/Home Pages/food pages/food iteam page/chickennoodles.dart';
import 'pages/Home Pages/food pages/food iteam page/fishcurry.dart';
import 'pages/Home Pages/food pages/food iteam page/fried fish.dart';
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
import 'pages/Home Pages/profile.dart';
import 'pages/Home Pages/profiles pages/passwordupdate.dart';
import 'pages/Home Pages/profiles pages/updatenext.dart';
import 'pages/Home Pages/profiles pages/payment.dart';
import 'pages/Home Pages/subscription.dart';
import 'pages/Home Pages/food pages/Nonevegfood.dart';
import 'pages/Home Pages/food pages/food iteam page/chicken.dart';
import 'pages/Home Pages/food pages/food iteam page/vegnoodle.dart';
import 'pages/Home Pages/food pages/food iteam page/panner.dart';
import 'pages/Home Pages/food pages/food iteam page/sahipanner.dart';
import 'pages/Home Pages/food pages/food iteam page/dalmasala.dart';
import 'pages/Home Pages/food pages/food iteam page/biryani.dart';

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
      home: login(),
      routes: {
        'AddMenuItemPage': (context) => AddMenuItemPage(),
        'Menu': (context) => Menu(),
        'login': (context) => login(),
        'DashboardScreen': (context) => DashboardScreen(),
        'signup': (context) => signup(),
        'forgetpassword': (context) => forgetpassword(),
        'forgetpassword2': (context) => forgetpassword2(),
        'FoodDeliveryScreen': (context) => FoodDeliveryScreen(),
        //'FoodItemScreen': (context) => FoodListPage(),
        'nonveg': (context) => nonveg(),
        'butterchicken': (context) => butterchicken(),
        'fish': (context) => fish(),
        'bangda': (context) => bangda(),
        'chickennoodles': (context) => chickennoodles(),
        'fishcurry': (context) => fishcurry(),
        'chickennon': (context) => chickennon(),
        'FoodGoHomePage': (context) => FoodGoHomePage(),
        'sub': (context) => sub(),
        'SubscriptionDetailsPage': (context) => SubscriptionDetailsPage(),
        'MenuPage': (context) => MenuPage(),
        'logout': (context) => logout(),
        'ProfilePage': (context) => ProfilePage(),
        'payment': (context) => payment(),
        'restPage': (context) => restPage(),
        'updatepage': (context) => updatepage(),
        'chicken': (context) => chicken(),
        'vegnoodle': (context) => vegnoodle(),
        'panner': (context) => panner(),
        'NotificationsPage': (context) => NotificationsPage(),
        'dal': (context) => dal(),
        'biryani': (context) => biryani(),
        'first': (context) => first(),
        'second': (context) => second(),
        'third': (context) => third(),
        'realtime': (context) => Realtime(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
