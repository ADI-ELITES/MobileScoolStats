class MatiereModel {
  String? niveau;
  String? serie;
  String? codeclas;
  String? nomatiere;
  String? nomprof;

  MatiereModel({
    this.niveau,
    this.serie,
    this.codeclas,
    this.nomatiere,
    this.nomprof,
  });

  factory MatiereModel.fromJson(Map<String, dynamic> json) {
    return MatiereModel(
      niveau: json['niveau'],
      serie: json['serie'],
      codeclas: json['codeclas'],
      nomatiere: json['nomatiere'],
      nomprof: json['nomprof'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'niveau': niveau,
      'serie': serie,
      'codeclas': codeclas,
      'nomatiere': nomatiere,
      'nomprof': nomprof,
    };
  }

  @override
  String toString() {
    return 'MatiereModel{niveau: $niveau, serie: $serie, codeclas: $codeclas, nomatiere: $nomatiere, nomprof: $nomprof}';
  }
}
