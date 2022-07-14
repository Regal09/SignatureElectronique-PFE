class SignatureModel {
  late String usernom;
  late String userprenom;
  late String timenow;
  late String validation;
  late String contrat;

  SignatureModel(this.usernom, this.userprenom, this.timenow, this.validation,
      this.contrat);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_nom': usernom,
      'user_prenom': userprenom,
      'timenow': timenow,
      'validation': validation,
      'contrat': contrat
    };
    return map;
  }

  SignatureModel.fromMap(Map<String, dynamic> map) {
    usernom = map['user_nom'];
    userprenom = map['user_prenom'];
    timenow = map['timenow'];
    validation = map['validation'];
    contrat = map['contrat'];
  }
}
