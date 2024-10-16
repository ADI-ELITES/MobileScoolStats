import 'package:flutter/cupertino.dart';
import 'package:mobile_school_state/screens/dashboard.dart';
import 'package:mobile_school_state/screens/login.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const SignInPage(),
  Dashboard.routeName : (context) => const Dashboard(),
  /*Dashboard.routeName: (context) {
    // Vous pouvez obtenir 'isDark' depuis le contexte ou d'autres moyens
    final bool isDark =
        ModalRoute.of(context)!.settings.arguments as bool? ?? false;

    return Dashboard(isDark: isDark); // Passez la valeur de isDark
  },*/
};
