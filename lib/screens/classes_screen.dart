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
                padding: const EdgeInsets.all(12.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 50.0,
                  crossAxisSpacing: 50.0,
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
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              "${classes[index].niveau} ${classes[index].codeclas}",
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.05, // Ajuste la taille du texte
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
