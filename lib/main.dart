import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz/firebase_options.dart';
import 'package:quiz/pages/Choices.dart';
import 'package:quiz/pages/homePage.dart';
import 'package:quiz/pages/login.dart';
import 'package:quiz/pages/signup.dart';
import 'package:quiz/pages/welcome.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized(); // Ensure
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      path: 'assets/translations', // Path to your translation files
      fallbackLocale: Locale('en'),
     
        child: MyApp(),
      
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context
          .localizationDelegates, // Localization delegates for EasyLocalization
      supportedLocales:
          context.supportedLocales, // Supported locales for EasyLocalization
      locale: context.locale, // Use the selected locale from EasyLocalization

      initialRoute: "/",
      routes: {
        "/": (context) =>  Welcome(),
        "/login": (context) => Login(),
        "/signup": (context) => Signup(),
        "/choices": (context) => ChoicesPage(),
        '/home': (context) => HomePage(user: FirebaseAuth.instance.currentUser),
      },
    );
  }
}
