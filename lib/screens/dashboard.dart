import 'package:flutter/material.dart';
import 'package:mobile_school_state/services/api_service.dart';
import '../models/eleve.dart';
import '../models/api_response.dart';
import '../constant.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


class Dashboard extends StatefulWidget {
  //final bool isDark; // Accepte isDark en tant que paramètre
  const Dashboard({
    super.key,
    /*required this.isDark*/
  }); // Modifie le constructeur

  static String routeName = "/dashboard";

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<EleveModel> eleves = [];
  bool isLoading = true;
  //late bool isDark;

  @override
  void initState() {
    super.initState();
    fetchEleves();
  }

  // Méthode pour récupérer les élèves :
  Future<void> fetchEleves() async {
    ApiResponse response = await getEleves();
    if (response.error == null) {
      setState(() {
        eleves = response.data as List<EleveModel>;
        isLoading = false; // Stopper l'indicateur de chargement
      });
    } else if (response.error == unauthorized) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(unauthorized)));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.error ?? "tout est vide")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              title: const Text('élèves'),
            ),
            backgroundColor: Colors.white,
            body: const Center(
              child: Text('Récupération des données'),
            ),
          )
        : eleves.isEmpty
            ? const Center(
                child: Text('Aucun élève trouvé'),
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Liste des élèves'),
                ),
                //backgroundColor: Colors.white,
                body: RefreshIndicator(
                  backgroundColor: Colors.white,
                  onRefresh: fetchEleves,
                  child: ListView.builder(
                    itemCount: eleves.length,
                    itemBuilder: (context, index) {
                      EleveModel eleve = eleves[index];
                      return ListTile(
                        title: Text('${eleve.nom} ${eleve.prenom}'),
                        subtitle: Text(
                            'Matricule: ${eleve.matric} - Sexe: ${eleve.sexe}'),
                        trailing: IconButton(
                          onPressed: () async {
                            // URL du PDF pour cet élève
                            String pdfUrl =
                                '${baseURL}/pdfs/${eleve.nom}_generate.pdf';

                            // Téléchargez et partagez le fichier PDF
                            await _downloadAndSharePdf(pdfUrl, eleve.nom ?? "");
                          },
                          icon: const Icon(Icons.send_outlined),
                        ),
                      );
                    },
                  ),
                ),
              );
  }
}


Future<void> _downloadAndSharePdf(String url, String nomEleve) async {
    try {
      // Utiliser Dio pour télécharger le PDF
      var dio = Dio();

      // Obtenez le chemin du répertoire temporaire
      var dir = await getTemporaryDirectory();
      String filePath = '${dir.path}/$nomEleve.pdf';

      // Téléchargez le fichier PDF
      await dio.download(url, filePath);

      // Partager le fichier PDF
      await Share.shareXFiles([XFile(filePath)], text: 'Document pour $nomEleve');
    } catch (e) {
      print('Erreur lors du téléchargement ou du partage : $e');
    }
  }