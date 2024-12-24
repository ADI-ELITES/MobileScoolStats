import 'package:flutter/material.dart';
import 'package:mobile_school_state/constant.dart';
import 'package:mobile_school_state/models/api_response.dart';
import 'package:mobile_school_state/models/classe.dart';
import 'package:mobile_school_state/models/matiere.dart';
import 'package:mobile_school_state/screens/eleves_screen.dart';
import 'package:mobile_school_state/services/api_service.dart';

class DetailMatiereScreen extends StatefulWidget {
  final ClasseModel classe;
  const DetailMatiereScreen({super.key, required this.classe});

  @override
  State<DetailMatiereScreen> createState() => _DetailMatiereScreenState();
}

class _DetailMatiereScreenState extends State<DetailMatiereScreen> {
  List<MatiereModel> matieres = [];
  bool isLoading = true;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    fetchMatiereWithClasse();
  }

  @override
  void dispose() {
    _isActive = false;
    super.dispose();
  }

  Future fetchMatiereWithClasse() async {
    ApiResponse response = await getMatieresFromClasse(widget.classe);
    if (_isActive && mounted) {
      if (response.error == null) {
        setState(() {
          matieres = (response.data as List<MatiereModel>)
              .where((matiere) =>
                  matiere.niveau == widget.classe.niveau &&
                  matiere.serie == widget.classe.serie &&
                  matiere.codeclas == widget.classe.codeclas)
              .toList();
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          " Matière de la ${widget.classe.niveau} (${widget.classe.codeclas})",
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: matieres.isEmpty
          ? const Center(
              child: Text("Aucune matière trouvée."),
            )
          : RefreshIndicator(
              onRefresh: fetchMatiereWithClasse,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                        child: Text('${matieres[index].codeclas}')),
                    title: Text('${matieres[index].nomatiere}'),
                    subtitle: Text('${matieres[index].serie}'),
                    trailing: TextButton.icon(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary, //Colors.blue[200],
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EleveScreen(
                              matiere: matieres[index],
                            ),
                          ),
                        );
                      },
                      //child: Text('Ajouter notes'),
                      icon: const Icon(Icons.wc),
                      label: const Text('Elèves'),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  endIndent: 10,
                  indent: 10,
                ),
                itemCount: matieres.length,
              ),
            ),
    );
  }
}
