class EleveModel {
  int? id;
  String? matric;
  String? nom;
  String? prenom;
  String? sexe;
  DateTime? datenais;
  String? phoneeleve;
  String? nompar;
  String? prenpar;
  String? profespar;
  String? phonepar;
  String? sexepar;

  EleveModel({
    this.id,
    this.matric,
    this.nom,
    this.prenom,
    this.sexe,
    this.datenais,
    this.phoneeleve,
    this.nompar,
    this.prenpar,
    this.profespar,
    this.phonepar,
    this.sexepar,
  });

  factory EleveModel.fromJson(Map<String, dynamic> json) {
    return EleveModel(
      id: json['id'],
      matric: json['matric'],
      nom: json['nom'],
      prenom: json['prenom'],
      sexe: json['sexe'],
      datenais: DateTime.parse(json['datenais']),
      phoneeleve: json['phoneeleve'],
      nompar: json['nompar'],
      prenpar: json['prenpar'],
      profespar: json['profespar'],
      phonepar: json['phonepar'],
      sexepar: json['sexepar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matric': matric,
      'nom': nom,
      'prenom': prenom,
      'sexe': sexe,
      'datenais': datenais?.toIso8601String(),
      'phoneeleve': phoneeleve,
      'nompar': nompar,
      'prenpar': prenpar,
      'profespar': profespar,
      'phonepar': phonepar,
      'sexepar': sexepar,
    };
  }

  @override
  String toString() {
    return 'EleveModel{id: $id, matric: $matric, nom: $nom, prenom: $prenom, sexe: $sexe, datenais: $datenais, phoneeleve: $phoneeleve, nompar: $nompar, prenpar: $prenpar, profespar: $profespar, phonepar: $phonepar, sexepar: $sexepar}';
  }
}
