import 'package:flutter/material.dart';
import 'package:fluttersignature/DatabaseHandler/DbHelper2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TousSignatures extends StatefulWidget {
  TousSignatures({Key? key}) : super(key: key);

  @override
  State<TousSignatures> createState() => _TousSignaturesState();
}

class _TousSignaturesState extends State<TousSignatures> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  String userNom = "";
  String userPrenom = "";
  String timenow = "";
  String validation = "";
  String contrat = "";

  var dbHelper2 = DbHelper2();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSignatureData();
    dbHelper2 = DbHelper2();
  }

  Future<void> getSignatureData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      userNom = sp.getString("user_nom")!;
      userPrenom = sp.getString("user_prenom")!;
      //timenow = sp.getString("timenow")!;
      //validation = sp.getString("validation")!;
      //contrat = sp.getString("contrat")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vos signatures'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
            child: Table(
              defaultColumnWidth: FixedColumnWidth(120.0),
              border: TableBorder.all(
                  color: Colors.blue, style: BorderStyle.solid, width: 2),
              children: [
                TableRow(children: [
                  Column(children: [
                    Text('Contrat', style: TextStyle(fontSize: 20.0)),
                  ]),
                  Column(children: [
                    Text('Validation', style: TextStyle(fontSize: 20.0))
                  ]),
                  Column(children: [
                    Text('Date', style: TextStyle(fontSize: 20.0))
                  ]),
                ]),
                TableRow(children: [
                  Column(children: [Text('Contrat 1')]),
                  Column(children: [Text('Premier validation')]),
                  Column(children: [Text('11/07/2022')]),
                ]),
                TableRow(children: [
                  Column(children: [Text('Contrat 2')]),
                  Column(children: [Text('Deuxiéme validation')]),
                  Column(children: [Text('05/07/2022')]),
                ]),
                TableRow(children: [
                  Column(children: [Text('Maintenance_chaudiere')]),
                  Column(children: [Text('Premier validation')]),
                  Column(children: [Text('11/07/2022')]),
                ]),
              ],
            ),
          ),
        ])));
  }
}
