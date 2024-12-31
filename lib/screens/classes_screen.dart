import 'package:flutter/material.dart';
import 'package:mobile_school_state/screens/detail_matiere_screen.dart';
import '../constant.dart';
import '../models/api_response.dart';
import '../models/classe.dart';
import '../services/api_service.dart';

class ClasseScreen extends StatefulWidget {
  const ClasseScreen({super.key});

  @override
  State<ClasseScreen> createState() => _ClasseScreenState();
}

class _ClasseScreenState extends State<ClasseScreen> {
  List<ClasseModel> classes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClasses();
  }

  // Méthode pour récupérer les classes :
  Future<void> fetchClasses() async {
    ApiResponse response = await getClasses();
    if (response.error == null) {
      setState(() {
        classes = response.data as List<ClasseModel>;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shadowColor: Theme.of(context).colorScheme.onSecondary,
        title: const Text(
          'SCOLARIS.1',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: classes.isEmpty
          ? const Center(
              child: Text('Aucune classe trouvée'),
            )
          : RefreshIndicator(
              onRefresh: fetchClasses,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 20.0,
                  children: List.generate(
                    classes.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          // Action à effectuer lorsqu'on clique sur une classe
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailMatiereScreen(classe: classes[index]),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2.0,
                          color: Theme.of(context).colorScheme.secondary,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Image avec bordure arrondie
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                ),
                                child: Image.asset(
                                  'assets/salle_classe_1.jpg',
                                  width: double.infinity,
                                ),
                              ),
                              const SizedBox(
                                height: 14.0,
                              ),
                              Text(
                                "${classes[index].niveau} ${classes[index].codeclas}",
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.05, // Ajuste la taille du texte
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        // child: Container(
                        //   padding: const EdgeInsets.all(2.0),
                        //   decoration: BoxDecoration(
                        //     color: Theme.of(context).colorScheme.primary,
                        //     borderRadius: BorderRadius.circular(8.0),
                        //   ),
                        //   child: Center(
                        //     child: Text(
                        //       "${classes[index].niveau} ${classes[index].codeclas}",
                        //       style: TextStyle(
                        //         fontSize: MediaQuery.of(context).size.width *
                        //             0.03, // Ajuste la taille du texte
                        //         color: Theme.of(context).colorScheme.onPrimary,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        // ),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
