import 'package:budget_tracker_app/home_screen.dart';
import 'package:budget_tracker_app/providers/authentication_state.dart';
import 'package:budget_tracker_app/providers/items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import 'styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.orange));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final themeData = ThemeData(
      brightness: Brightness.light,
      primaryColor: Styles.kPrimaryColor,
      backgroundColor: Styles.kLightColor,
      textTheme: Theme.of(context).textTheme.copyWith(
            headline1: const TextStyle(
              color: Styles.kDarkColor,
              fontSize: 30.0,
              letterSpacing: 0.5,
              height: 1.2,
            ),
            headline2: const TextStyle(color: Styles.kPrimaryColor),
            headline3: const TextStyle(color: Colors.grey),
          ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Styles.kSecondaryColor,
        primary: Styles.kPrimaryColor,
      ),
      fontFamily: 'Poppins',
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationState()),
        ChangeNotifierProvider(create: (_) => Items()),
      ],
      child: MaterialApp(
        // debugShowCheckedModeBanner: false,
        title: 'Budget Tracker App',
        theme: themeData,
        darkTheme: themeData.copyWith(
          brightness: Brightness.dark,
          backgroundColor: Styles.kDarkThemeColor,
          canvasColor: Styles.kDarkPrimaryColor,
          textTheme: Theme.of(context).textTheme.copyWith(
                headline1: const TextStyle(
                  color: Styles.kSecondaryColor,
                  fontSize: 30.0,
                  letterSpacing: 0.5,
                  height: 1.2,
                ),
                headline2: const TextStyle(color: Styles.kSecondaryColor),
                headline3: TextStyle(
                  color: Styles.kSecondaryColor.withOpacity(0.8),
                ),
                headline4: const TextStyle(color: Styles.kSecondaryColor),
              ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Styles.kSecondaryColor,
          ),
          snackBarTheme: const SnackBarThemeData(
            contentTextStyle: TextStyle(color: Styles.kSecondaryColor),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
