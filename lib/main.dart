import 'package:flutter/material.dart';
import 'package:mobile_school_state/screens/splashscreen.dart';
import 'routes.dart';

void main() {
  runApp(const MainApp(isDark: false)); // Ajout du paramètre isDark
}

class MainApp extends StatelessWidget {
  final bool isDark;

  const MainApp({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SchoolState',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.brown,
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      home: SplashScreen(),
      /*routes: routes,
      initialRoute: '/',*/
    );
  }
}
