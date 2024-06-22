import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:perper/Screens/login.dart';
import 'package:reactive_theme/reactive_theme.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51O9PQmBry202g6u5k2wrbGr0PskrPsUUVHq9N9w7yvAYhpmodctj2BeGtUJZjPEmdjcH7TL03VOPUJFZOtTxjFeI00hQtTNbmk';

  final savedThemeMode =
      await ReactiveMode.getSavedThemeMode() ?? ThemeMode.system;
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final ThemeMode savedThemeMode;

  MyApp({required this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return ReactiveThemer(
          savedThemeMode: savedThemeMode,
          builder: (reactiveMode) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  brightness: Brightness.light, seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  brightness: Brightness.dark, seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            themeMode: reactiveMode,
            home: LoginScreen(),
          ),
        );
      },
    );
  }
}
