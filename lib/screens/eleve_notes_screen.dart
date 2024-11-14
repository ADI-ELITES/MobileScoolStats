import 'package:flutter/material.dart';
import 'package:mobile_school_state/constant.dart';
import 'package:mobile_school_state/models/api_response.dart';
import 'package:mobile_school_state/models/eleve.dart';
import 'package:mobile_school_state/models/matiere.dart';
import 'package:mobile_school_state/models/note.dart';
import 'package:mobile_school_state/services/api_service.dart';

class EleveNoteScreen extends StatefulWidget {
  final EleveModel eleve;
  final MatiereModel matiere;

  const EleveNoteScreen({
    super.key,
    required this.eleve,
    required this.matiere,
  });

  @override
  State<StatefulWidget> createState() => _EleveNoteScreenState();
}

class _EleveNoteScreenState extends State<EleveNoteScreen> {
  late NoteModel noteEleve;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNoteEleveWithMatiere();
  }

  Future fetchNoteEleveWithMatiere() async {
    // Implémentation pour récupérer les notes
     ApiResponse response = await getNoteFromEleve(widget.eleve, widget.matiere);
    if (response.error == null) {
      setState(() {
        noteEleve = response.data as NoteModel;
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
        title: Text("Notes de ${widget.eleve.nom} (${widget.eleve.matric})"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Center(
                  child: _FormContent(note: noteEleve),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  final NoteModel note;

  const _FormContent({super.key, required this.note});

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _premierDevoirController;
  late TextEditingController _deuxiemeDevoirController;
  late TextEditingController _troisiemeDevoirController;
  late TextEditingController _composController;

  @override
  void initState() {
    super.initState();

    // Initialisation des contrôleurs avec les valeurs des notes
    _premierDevoirController = TextEditingController(
        text: widget.note.devoir01?.toString() ?? '');
    _deuxiemeDevoirController = TextEditingController(
        text: widget.note.devoir02?.toString() ?? '');
    _troisiemeDevoirController = TextEditingController(
        text: widget.note.devoir03?.toString() ?? '');
    _composController =
        TextEditingController(text: widget.note.compos?.toString() ?? '');
  }

  @override
  void dispose() {
    _premierDevoirController.dispose();
    _deuxiemeDevoirController.dispose();
    _troisiemeDevoirController.dispose();
    _composController.dispose();
    super.dispose();
  }

  String? validateNoteInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Svp, entrer un nombre entre 0 et 20';
    }
    final double? note = double.tryParse(value);
    if (note == null || note < 0 || note > 20) {
      return 'Svp, entrer une valeur entre 0 et 20';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _premierDevoirController,
              keyboardType: TextInputType.number,
              validator: validateNoteInput,
              decoration: const InputDecoration(
                labelText: 'Note du premier devoir',
                hintText: 'Entrer un entier entre 0 et 20',
                prefixIcon: Icon(Icons.first_page),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _deuxiemeDevoirController,
              keyboardType: TextInputType.number,
              validator: validateNoteInput,
              decoration: const InputDecoration(
                labelText: 'Note du deuxième devoir',
                hintText: 'Entrer un entier entre 0 et 20',
                prefixIcon: Icon(Icons.first_page),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _troisiemeDevoirController,
              keyboardType: TextInputType.number,
              validator: validateNoteInput,
              decoration: const InputDecoration(
                labelText: 'Note du troisième devoir',
                hintText: 'Entrer un entier entre 0 et 20',
                prefixIcon: Icon(Icons.first_page),
                border: OutlineInputBorder(),
              ),
            ),
            _gap(),
            TextFormField(
              controller: _composController,
              keyboardType: TextInputType.number,
              validator: validateNoteInput,
              decoration: const InputDecoration(
                labelText: 'Note de composition',
                hintText: 'Entrer un entier entre 0 et 20',
                prefixIcon: Icon(Icons.first_page),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
