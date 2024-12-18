import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ------ STRINGS ------
const String baseURL = "http://192.168.6.35:8000";
const String elevesURL = '$baseURL/api/eleves/';
const String loginURL = '$baseURL/api/login';
const String logoutURL = '$baseURL/api/logout';
const String userURL = '$baseURL/api/user';

const String classeURL = '$baseURL/api/classes';
const String matieresURL = '$baseURL/api/matieres';
const String matieresClassesURL = '$classeURL/matieres';
const String notesURL = '$baseURL/api/notes';
const String noteEleveURL = '$baseURL/api/notes/eleve/';
const String storeNoteURL = '$notesURL/store';
const String enseignantURL = '$baseURL/api/enseignants/';
const String validateTokenURL = '$baseURL/api/token/validate';

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

Future<bool> isTokenStillValid() async {
  String? token = await getToken();
  if (token == null) return false;

  final response = await http.get(
    Uri.parse(validateTokenURL),
    headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['valid'];
  } else {
    return false; // Token est invalide ou expiré
  }
}
