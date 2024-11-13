import 'package:flutter/material.dart';
import 'package:mobile_school_state/constant.dart';
import 'package:mobile_school_state/screens/classes_screen.dart';
import 'package:mobile_school_state/screens/dashboard.dart';
import 'package:mobile_school_state/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  // Méthode de vérification du token :
  void _checkToken() async {
    String? token = await getToken();
    //print("Token actuel : $token");

    if (token != null) {
      bool tokenIsValid = await isTokenStillValid();

      if (tokenIsValid) {
        // Si le token est valide, rediriger vers l'écran des classes
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ClasseScreen()),
        );
      } else {
        // Si le token n'est plus valide, rediriger vers la page de connexion
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      }
    } else {
      // Si le token n'existe pas, rediriger vers la page de connexion
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(), // Afficher le loader pendant la vérification
      ),
    );
  }
}
