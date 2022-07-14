import 'package:fluttersignature/Model/SignatureModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DbHelper2 {
  static const String DB_Name = 'testt.db';
  static const String Table_Signature = 'signature';
  static const int Version = 1;

  static const String C_UserNom = 'user_nom';
  static const String C_UserPrenom = 'user_prenom';
  static const String C_Timenow = 'timenow';
  static const String C_Validation = 'validation';
  static const String C_Contrat = 'contrat';

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $Table_Signature ("
        " $C_UserNom TEXT, "
        " $C_UserPrenom TEXT,"
        " $C_Timenow TEXT,"
        " $C_Validation TEXT, "
        " $C_Contrat TEXT "
        ")");
  }

  Future<int> saveData(SignatureModel signature) async {
    var dbClient = await db;
    var res = await dbClient!.insert(Table_Signature, signature.toMap());
    return res;
  }

  Future<SignatureModel?> getSignatureUser(String nom, String prenom) async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT * FROM $Table_Signature WHERE "
        "$C_UserNom = '$nom' AND "
        "$C_UserPrenom = '$prenom'");

    if (res.length > 0) {
      return SignatureModel.fromMap(res.first);
    }

    return null;
  }

  Future fetchSignature(String nom, String prenom) async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT * FROM $Table_Signature WHERE "
        "$C_UserNom = '$nom' AND "
        "$C_UserPrenom = '$prenom'");
    return res;
  }
}
