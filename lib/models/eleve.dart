class EleveModel {
  //int? id;
  String? niveau;
  String? serie;
  String? codeclas;
  String? matric;
  String? nom;
  String? prenom;
  String? sexe;
  /*DateTime? datenais;
  String? phoneeleve;
  String? nompar;
  String? prenpar;
  String? profespar;
  String? phonepar;
  String? sexepar;*/

  EleveModel({
    //this.id,
    this.niveau,
    this.serie,
    this.codeclas,
    this.matric,
    this.nom,
    this.prenom,
    this.sexe,
    /*this.datenais,
    this.phoneeleve,
    this.nompar,
    this.prenpar,
    this.profespar,
    this.phonepar,
    this.sexepar,*/
  });

  factory EleveModel.fromJson(Map<String, dynamic> json) {
    return EleveModel(
      niveau: json['niveau'],
      serie: json['serie'],
      codeclas: json['codeclas'],
      matric: json['matric'],
      nom: json['nom'],
      prenom: json['prenom'],
      sexe: json['sexe'],
      /*datenais: DateTime.parse(json['datenais']),
      phoneeleve: json['phoneeleve'],
      nompar: json['nompar'],
      prenpar: json['prenpar'],
      profespar: json['profespar'],
      phonepar: json['phonepar'],
      sexepar: json['sexepar'],*/
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'niveau': niveau,
      'serie': serie,
      'codeclas': codeclas,
      'matric': matric,
      'nom': nom,
      'prenom': prenom,
      'sexe': sexe,
      /*'datenais': datenais?.toIso8601String(),
      'phoneeleve': phoneeleve,
      'nompar': nompar,
      'prenpar': prenpar,
      'profespar': profespar,
      'phonepar': phonepar,
      'sexepar': sexepar,*/
    };
  }

  @override
  String toString() {
    return 'EleveModel{matric: $matric, nom: $nom, prenom: $prenom, sexe: $sexe, matric: $matric, codeclasse: $codeclas}';
  }
}
