import 'package:flutter/material.dart';
import 'package:mobile_school_state/screens/splashscreen.dart';

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
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
          primary: Colors.green.shade900,
          secondary: Colors.greenAccent,
        ),
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      home: const SplashScreen(),
      /*routes: routes,
      initialRoute: '/',*/
    );
  }
}
