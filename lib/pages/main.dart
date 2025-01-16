import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Home Pages/food pages/food iteam page/bangda.dart';
import 'Home Pages/food pages/food iteam page/butterchicken.dart';
import 'Home Pages/food pages/food iteam page/chicken non.dart';
import 'Home Pages/food pages/food iteam page/chickennoodles.dart';
import 'Home Pages/food pages/food iteam page/fishcurry.dart';
import 'Home Pages/food pages/food iteam page/fried fish.dart';
import 'login pages/login.dart';
import 'login pages/signup.dart';
import 'Home Pages/food pages/todays offer/10off.dart';
import 'Home Pages/food pages/todays offer/15.off.dart';
import 'Home Pages/food pages/todays offer/20 off.dart';
import 'Home Pages/menu.dart';
import 'Home Pages/profiles pages/realtime.dart';
import 'login pages/forgetpassword.dart';
import 'login pages/forgetpassword2.dart';
import 'Home Pages/profiles pages/logout.dart';
import 'Home Pages/logo.dart';
import 'Home Pages/home.dart';
import 'Home Pages/profile.dart';
import 'Home Pages/profiles pages/passwordupdate.dart';
import 'Home Pages/profiles pages/updatenext.dart';
import 'Home Pages/profiles pages/payment.dart';
import 'Home Pages/profiles pages/card.dart';
import 'Home Pages/subscription.dart';
import 'Home Pages/food pages/vegfood.dart';
import 'Home Pages/food pages/Nonevegfood.dart';
import 'Home Pages/food pages/food iteam page/chicken.dart';
import 'Home Pages/food pages/food iteam page/vegnoodle.dart';
import 'Home Pages/food pages/food iteam page/panner.dart';
import 'Home Pages/food pages/food iteam page/sahipanner.dart';
import 'Home Pages/food pages/food iteam page/dalmasala.dart';
import 'Home Pages/food pages/food iteam page/biryani.dart';
import 'Home Pages/food pages/food iteam page/Aloo.dart';
import 'Home Pages/menu pages/sunday.dart';
import 'Home Pages/menu pages/monday.dart';
import 'Home Pages/menu pages/tuesday.dart';
import 'Home Pages/menu pages/wednesday.dart';
import 'Home Pages/menu pages/thursday.dart';
import 'Home Pages/menu pages/friday.dart';
import 'Home Pages/menu pages/saturday.dart';

void main() async { WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp()); }

class MyApp extends StatelessWidget {
  @override Widget build(BuildContext context)
  {
    return MaterialApp( title: 'DabbaWala',
      theme: ThemeData(
      primarySwatch: Colors.blue, ),
      home: login(),
      routes: {
        'login': (context) => login( ),
        'signup': (context) => signup(),
        'forgetpassword': (context) => forgetpassword(),
        'forgetpassword2': (context) => forgetpassword2(),
        'FoodDeliveryScreen': (context) => FoodDeliveryScreen(),
        'vegfoodpage': (context) => vegfoodpage(),
        'nonveg': (context) => nonveg(),
        'butterchicken': (context) => butterchicken(),
        'fish': (context) => fish(),
        'bangda': (context) => bangda(),
        'chickennoodles': (context) => chickennoodles(),
        'fishcurry': (context) => fishcurry(),
        'chickennon': (context) => chickennon(),
        'FoodGoHomePage': (context) => FoodGoHomePage(),
        'sub': (context) => sub(),
        'MenuPage': (context) => MenuPage(),
        'logout': (context) => logout(),
        'ProfilePage': (context) => ProfilePage(),
        'payment': (context) => payment(),
        'card': (context) => card(),
        'restPage': (context) => restPage(),
        'updatepage': (context) => updatepage(),
        'chicken': (context) => chicken(),
        'vegnoodle': (context) => vegnoodle(),
        'panner': (context) => panner(),
        'sahipanner': (context) => sahipanner(),
        'dal': (context) => dal(),
        'biryani': (context) => biryani(),
        'aloopage': (context) => aloopage(),
        'sunday': (context) => sunday(),
        'monday': (context) => monday(),
        'tuesday': (context) => tuesday(),
        'wednesday': (context) => wednesday(),
        'thursday': (context) => thursday(),
        'friday': (context) => friday(),
        'saturday': (context) => saturday(),
        'first': (context) => first(),
        'second': (context) => second(),
        'third': (context) => third(),
        'realtime': (context) => realtime(),


      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class customerDao {
}








