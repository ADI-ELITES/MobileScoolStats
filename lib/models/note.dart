class NoteModel {
  String? niveau;
  String? serie;
  String? codeclas;
  String? matric;
  String? periode;
  String? matiere;
  double? devoir01;
  double? devoir02;
  double? devoir03;
  double? compos;

  NoteModel({
    this.niveau,
    this.serie,
    this.codeclas,
    this.matric,
    this.periode,
    this.matiere,
    this.devoir01,
    this.devoir02,
    this.devoir03,
    this.compos,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      niveau: json['niveau'],
      serie: json['serie'],
      codeclas: json['codeclas'],
      matric: json['matric'],
      periode: json['periode'],
      matiere: json['matiere'],
      devoir01: double.tryParse(json['devoir01']?.toString() ?? ''),
      devoir02: double.tryParse(json['devoir02']?.toString() ?? ''),
      devoir03: double.tryParse(json['devoir03']?.toString() ?? ''),
      compos: double.tryParse(json['compos']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'niveau': niveau,
      'serie': serie,
      'codeclas': codeclas,
      'matric': matric,
      'periode': periode,
      'matiere': matiere,
      'devoir01': devoir01,
      'devoir02': devoir02,
      'devoir03': devoir03,
      'compos': compos,
    };
  }

  @override
  String toString() {
    return "NoteModel{niveau : $niveau, serie : $serie, codeclasse : $codeclas, matric : $matric, periode : $periode, matière : $matiere, devoir1 : $devoir01, devoir2 : $devoir02, devoir3 : $devoir03, devoir4 : $devoir03, compos : $compos}";
  }
}
