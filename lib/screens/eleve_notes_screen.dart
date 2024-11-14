import 'package:flutter/material.dart';
import 'package:mobile_school_state/models/eleve.dart';
import 'package:mobile_school_state/models/matiere.dart';
import 'package:mobile_school_state/models/note.dart';

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

  @override
  void initState() {
    super.initState();
    fetchNoteEleveWithMatiere();
  }

  Future fetchNoteEleveWithMatiere() async {
    // Implémentation pour récupérer les notes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes de ${widget.eleve.nom} (${widget.eleve.matric})"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          constraints: const BoxConstraints(maxWidth: 800),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Center(
                  child: _FormContent(),
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
  const _FormContent({super.key});

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _premierDevoirController =
      TextEditingController();
  final TextEditingController _deuxiemeDevoirController =
      TextEditingController();
  final TextEditingController _troisiemeDevoirController =
      TextEditingController();
  final TextEditingController _composController = TextEditingController();

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
