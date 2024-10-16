import 'package:shared_preferences/shared_preferences.dart';

// ------ STRINGS ------
const String baseURL = "http://192.168.88.27:8000/api";
const String elevesURL = '$baseURL/eleves/';
const String loginURL = '$baseURL/login';
const String logoutURL = '$baseURL/logout';
const String userURL = '$baseURL/user';

// ----- Errors -----
const String serverError = 'Erreur du serveur';
const String unauthorized = 'Non autorisé';
const String somethingWentWrong = 'Something went wrong, try again!';

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
}
