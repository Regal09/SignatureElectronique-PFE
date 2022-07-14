class UserModel {
  late String usernom;
  late String userprenom;
  late String tel;
  late String password;

  UserModel(this.usernom, this.userprenom, this.tel, this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'user_nom': usernom,
      'user_prenom': userprenom,
      'tel': tel,
      'password': password
    };
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    usernom = map['user_nom'];
    userprenom = map['user_prenom'];
    tel = map['tel'];
    password = map['password'];
  }
}
