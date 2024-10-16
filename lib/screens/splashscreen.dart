import 'package:flutter/material.dart';
import 'package:mobile_school_state/constant.dart';
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
    if (token != null) {
      // Si le token existe, alors rediriger vers le tableau de bord
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Dashboard(),
      ));
    } else {
      // Sinon, redirigez vers la page de connexion
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
