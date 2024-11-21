import 'package:flutter/material.dart';
import 'package:mobile_school_state/constant.dart';
import 'package:mobile_school_state/models/api_response.dart';
import 'package:mobile_school_state/models/eleve.dart';
import 'package:mobile_school_state/models/matiere.dart';
import 'package:mobile_school_state/screens/eleve_notes_screen.dart';
import '../services/api_service.dart';

class EleveScreen extends StatefulWidget {
  final MatiereModel matiere;
  const EleveScreen({super.key, required this.matiere});

  @override
  State<EleveScreen> createState() => _EleveScreenState();
}

class _EleveScreenState extends State<EleveScreen> {
  List<EleveModel> eleves = [];
  bool isLoading = true;

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
        eleves = (response.data as List<EleveModel>)
            .where((eleve) =>
                eleve.niveau == widget.matiere.niveau &&
                eleve.serie == widget.matiere.serie &&
                eleve.codeclas == widget.matiere.codeclas)
            .toList();
        // Trier les élèves par ordre croissant de la première lettre du nom
        eleves.sort((a, b) => a.nom!.compareTo(b.nom!));
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
        title: Text(
          "Elèves de la ${widget.matiere.niveau}-${widget.matiere.codeclas}/${widget.matiere.nomatiere}",
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      ),
      body: eleves.isEmpty
          ? const Center(
              child: Text("Aucun élèves trouvés."),
            )
          : RefreshIndicator(
              onRefresh: fetchEleves,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                          '${eleves[index].nom!.substring(0, 1).toUpperCase()}'),
                    ),
                    title: Text('${eleves[index].nom!.toUpperCase()}'),
                    subtitle: Text(
                        '${eleves[index].prenom!.toUpperCase()} (${eleves[index].matric})'),
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
                            builder: (context) => EleveNoteScreen(
                                eleve: eleves[index], matiere: widget.matiere),
                          ),
                        );
                      },
                      label: const Text('Notes'),
                      icon: const Icon(Icons.app_registration_rounded),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  endIndent: 10,
                  indent: 10,
                ),
                itemCount: eleves.length,
              ),
            ),
    );
  }
}
