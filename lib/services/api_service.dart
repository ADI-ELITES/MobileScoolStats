import 'dart:convert';
import '../models/eleve.dart';
import '../constant.dart';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

//  Récupération des élèves après authentification
Future<ApiResponse> getEleves() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Récupérer le token stocké
    String? token = await getToken();
    if (token == null) {
      apiResponse.error = unauthorized;
      return apiResponse;
    }

    final response = await http.get(
      Uri.parse(elevesURL),
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    switch (response.statusCode) {
      // Décodez la réponse JSON
      case 200:
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        // Supposons que la liste des élèves se trouve sous la clé 'data'
        List<dynamic> elevesJson =
            jsonData['data']; // Changez 'data' si la clé est différente

        // Convertissez la liste en objets EleveModel
        apiResponse.data =
            elevesJson.map((eleve) => EleveModel.fromJson(eleve)).toList();
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e);
    apiResponse.error = "$serverError : lors de la récupération des données";
  }
  return apiResponse;
}

//  Authentification d'un user
Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Envoyer une requête POST avec l'email et le mot de passe
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
        'password': password,
      },
    );
    print(response.statusCode);

    switch (response.statusCode) {
      case 200:
        // Si la réponse est 200, on suppose que le token est renvoyé
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String token = responseData['token'];

        // Stocker le token dans SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        apiResponse.data = token;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Méthode pour obtenir l'utilisateur courant
Future<ApiResponse> getUser(String token) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    // Récupérer le token stocké
    String? token = await getToken();
    if (token == null) {
      apiResponse.error = unauthorized;
      return apiResponse;
    }

    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(serverError);
    }
  } catch (e) {
    throw Exception(somethingWentWrong);
  }
}

//  Génération du pdf d'un élève
Future<ApiResponse> generateElevePdf(int eleveId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('$elevesURL/$eleveId/generate'),
      headers: {
        "Accept": "application/json",
        //'Authorization': 'Bearer $token', // Ajoutez le token si nécessaire
      },
    );

    switch (response.statusCode) {
      case 200:
        // Supposons que l'API renvoie un lien vers le PDF
        apiResponse.data = jsonDecode(response.body)['pdf_url'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//  Génération des détails d'un élève
Future<ApiResponse> getEleveDetails(int eleveId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.get(
      Uri.parse('$elevesURL/$eleveId'),
      headers: {
        "Accept": "application/json",
        //'Authorization': 'Bearer $token', // Ajoutez le token si nécessaire
      },
    );

    switch (response.statusCode) {
      case 200:
        // Décoder la réponse et la convertir en objet EleveModel
        apiResponse.data = EleveModel.fromJson(jsonDecode(response.body));
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
