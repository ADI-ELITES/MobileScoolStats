class ClasseModel {
  //int? id;
  String? niveau;
  String? serie;
  String? codeclas;
  String? periode;
  String? proftitul;

  ClasseModel({
    //this.id,
    this.niveau,
    this.serie,
    this.codeclas,
    this.periode,
    this.proftitul,
  });

  factory ClasseModel.fromJson(Map<String, dynamic> json) {
    return ClasseModel(
      //id: json["id"],
      niveau: json["niveau"],
      serie: json["serie"],
      codeclas: json["codeclas"],
      periode: json["periode"],
      proftitul: json["proftitul"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'niveau': niveau,
      'serie': serie,
      'codeclas': codeclas,
      'periode': periode,
      'proftitul': proftitul,
    };
  }

  @override
  String toString() {
    return 'ClasseModel{niveau: $niveau, serie: $serie, codeclas: $codeclas, periode: $periode, proftitul: $proftitul}';
  }
}
