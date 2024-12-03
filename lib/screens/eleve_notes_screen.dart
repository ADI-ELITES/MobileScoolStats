import 'package:flutter/material.dart';
import 'package:mobile_school_state/constant.dart';
import 'package:mobile_school_state/models/api_response.dart';
import 'package:mobile_school_state/models/classe.dart';
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
  State<EleveNoteScreen> createState() => _EleveNoteScreenState();
}

class _EleveNoteScreenState extends State<EleveNoteScreen> {
  NoteModel? noteEleve;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNote();
  }

  Future<void> fetchNote() async {
    try {
      NoteModel fetchedNote = await getNote();
      setState(() {
        noteEleve = fetchedNote;
        isLoading = false;
      });
    } catch (e) {
      _showError("Erreur : ${e.toString()}");
    }
  }

  Future<NoteModel> getNote() async {
    try {
      ApiResponse response = await getNotes();
      //print(response.data);
      if (response.error == null) {
        List<NoteModel> notes = (response.data as List<NoteModel>)
            .where(
              (note) =>
                  note.matric == widget.eleve.matric &&
                  note.serie == widget.eleve.serie &&
                  note.codeclas == widget.eleve.codeclas,
            )
            .toList();

        return notes.isNotEmpty ? notes.first : NoteModel();
      } else {
        throw Exception(response.error ?? "Erreur inconnue");
      }
    } catch (e) {
      throw Exception("Erreur getnote : ${e.toString()}");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes de ${widget.eleve.nom}"),
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
                        child: _FormContent(
                          note: noteEleve ?? NoteModel(),
                          matiere: widget.matiere,
                          eleve: widget.eleve,
                        ),
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
  final MatiereModel matiere;
  final EleveModel eleve;

  const _FormContent({
    super.key,
    required this.note,
    required this.matiere,
    required this.eleve,
  });

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _premierDevoirController;
  late TextEditingController _deuxiemeDevoirController;
  late TextEditingController _troisiemeDevoirController;
  late TextEditingController _composController;

  ClasseModel? classe;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchClasse();
  }

  void _initializeControllers() {
    _premierDevoirController =
        TextEditingController(text: widget.note.devoir01?.toString() ?? '');
    _deuxiemeDevoirController =
        TextEditingController(text: widget.note.devoir02?.toString() ?? '');
    _troisiemeDevoirController =
        TextEditingController(text: widget.note.devoir03?.toString() ?? '');
    _composController =
        TextEditingController(text: widget.note.compos?.toString() ?? '');
  }

  Future<void> _fetchClasse() async {
    try {
      ClasseModel fetchedClasse = await getEleveClasse(
        widget.note.niveau ?? widget.matiere.niveau,
        widget.note.serie ?? widget.matiere.serie,
        widget.note.codeclas ?? widget.matiere.codeclas,
      );
      //print("classe : $fetchedClasse");

      setState(() {
        classe = fetchedClasse;
      });
    } catch (e) {
      _showError("Erreur : ${e.toString()}");
    }
  }

  Future<ClasseModel> getEleveClasse(niveau, serie, codeclas) async {
    try {
      ApiResponse response = await getClasses();
      if (response.error == null) {
        List<ClasseModel> classes = (response.data as List<ClasseModel>)
            .where(
              (classe) =>
                  classe.niveau == niveau &&
                  classe.serie == serie &&
                  classe.codeclas == codeclas,
            )
            .toList();

        return classes.isNotEmpty
            ? classes.first
            : ClasseModel(
                niveau: niveau,
                serie: serie,
                codeclas: codeclas,
                periode: "NS");
      } else {
        throw Exception(response.error ?? "Erreur inconnue");
      }
    } catch (e) {
      throw Exception("Erreur : ${e.toString()}");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> storeNoteEleve(NoteModel note) async {
    ApiResponse response = await saveEleveNote(note);
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note enregistrée avec succès.")),
      );
    } else if (response.error == unauthorized) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text(unauthorized)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.error ?? "Erreur d'enregistrement.")),
      );
    }
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

  Widget _buildDropdownField(
      TextEditingController controller, String labelText) {
    // Générer les valeurs de 0.01 à 20 avec un écart de 0.25
    final List<double> notes = [0.01];
    for (double i = 0.25; i <= 20; i += 0.25) {
      notes.add(i);
    }

    // Initialiser la valeur par défaut si elle est vide
    double initialValue = double.tryParse(controller.text) ?? 0.01;

    return DropdownButtonFormField<double>(
      value: initialValue,
      onChanged: (value) {
        if (value != null) {
          controller.text = value.toString();
        }
      },
      validator: (value) {
        if (value == null || value < 0 || value > 20) {
          return 'Svp, sélectionner une valeur entre 0 et 20';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      items: notes.map((note) {
        return DropdownMenuItem<double>(
          value: note,
          child: Text(note.toStringAsFixed(2)),
        );
      }).toList(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        constraints: const BoxConstraints(maxWidth: 300),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Classe de ${classe?.niveau} ${classe?.codeclas}",
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Matière : ${widget.matiere.nomatiere}',
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Période : ${classe?.periode}",
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              _gap(),
              _buildDropdownField(
                  _premierDevoirController, 'Note du premier devoir'),
              _gap(),
              _buildDropdownField(
                  _deuxiemeDevoirController, 'Note du deuxième devoir'),
              _gap(),
              _buildDropdownField(
                  _troisiemeDevoirController, 'Note du troisième devoir'),
              _gap(),
              _buildDropdownField(_composController, 'Note de composition'),
              _gap(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Enregistrer la note
                    NoteModel note = NoteModel(
                      niveau: widget.eleve.niveau,
                      serie: widget.eleve.serie,
                      codeclas: widget.eleve.codeclas,
                      matric: widget.eleve.matric,
                      periode: classe?.periode,
                      matiere: widget.matiere.nomatiere,
                      devoir01: double.tryParse(_premierDevoirController.text),
                      devoir02: double.tryParse(_deuxiemeDevoirController.text),
                      devoir03:
                          double.tryParse(_troisiemeDevoirController.text),
                      compos: double.tryParse(_composController.text),
                    );
                    storeNoteEleve(note);
                  } else {
                    _showError('Veuillez corriger les erreurs.');
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /*@override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        constraints: const BoxConstraints(maxWidth: 300),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Classe de ${classe?.niveau} ${classe?.codeclas}",
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Matière : ${widget.matiere.nomatiere}',
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Période : ${classe?.periode}",
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              _gap(),
              _buildTextField(
                  _premierDevoirController, 'Note du premier devoir'),
              _gap(),
              _buildTextField(
                  _deuxiemeDevoirController, 'Note du deuxième devoir'),
              _gap(),
              _buildTextField(
                  _troisiemeDevoirController, 'Note du troisième devoir'),
              _gap(),
              _buildTextField(_composController, 'Note de composition'),
              _gap(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Enregistrer la note
                    NoteModel note = NoteModel(
                      niveau: widget.eleve.niveau,
                      serie: widget.eleve.serie,
                      codeclas: widget.eleve.codeclas,
                      matric: widget.eleve.matric,
                      periode: classe?.periode,
                      matiere: widget.matiere.nomatiere,
                      devoir01: double.tryParse(_premierDevoirController.text),
                      devoir02: double.tryParse(_deuxiemeDevoirController.text),
                      devoir03:
                          double.tryParse(_troisiemeDevoirController.text),
                      compos: double.tryParse(_composController.text),
                    );
                    storeNoteEleve(note);
                  } else {
                    _showError('Veuillez corriger les erreurs.');
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: validateNoteInput,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }*/

  Widget _gap() => const SizedBox(height: 16);
}
