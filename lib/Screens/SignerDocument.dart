import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttersignature/DatabaseHandler/DbHelper2.dart';
import 'package:fluttersignature/Model/SignatureModel.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class SignerDocument extends StatefulWidget {
  SignerDocument({Key? key}) : super(key: key);

  @override
  State<SignerDocument> createState() => _SignerDocumentState();
}

class _SignerDocumentState extends State<SignerDocument> {
  final String timenow =
      DateFormat('yyyy-MM-dd KK:mm:ss a').format(DateTime.now());
  var dbHelper2 = DbHelper2();

  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  String userNom = "";
  String userPrenom = "";
  String tel = "";
  String password = "";

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    dbHelper2 = DbHelper2();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      userNom = sp.getString("user_nom")!;
      userPrenom = sp.getString("user_prenom")!;
      tel = sp.getString("tel")!;
      password = sp.getString("password")!;
    });
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Etat de Signature : ${SignaFunction(result!.code, userPrenom, userNom, timenow)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 20.0),
                    )
                  : Text(
                      'Scanner votre code QR',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 20.0),
                    ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  String SignaFunction(String code, String prenom, String nom, String timenow) {
    const start = "<validation2>";
    const end = "</validation2>";
    final startindex = code.indexOf("<validation2>");
    final endindex = code.indexOf("</validation2>");

    const start2 = "<validation4>";
    const end2 = "</validation4>";
    final startindex2 = code.indexOf("<validation4>");
    final endindex2 = code.indexOf("</validation4>");

    const start3 = "<internal_validation>";
    const end3 = "</internal_validation>";
    final startindex3 = code.indexOf("<internal_validation>");
    final endindex3 = code.indexOf("</internal_validation>");

    final signature =
        """<Nom>$nom</Nom><Prenom>$prenom</Prenom><Date>$timenow</Date>""";
    final excep = code.substring(0, startindex + 13);
    final excepp = code.substring(endindex, code.length);

    final excep2 = code.substring(0, startindex2 + 13);
    final excepp2 = code.substring(endindex2, code.length);

    final excep3 = code.substring(0, startindex3 + 21);
    final excepp3 = code.substring(endindex3, code.length);

    final startIndex = code.indexOf(start);
    final endIndex = code.indexOf(end, startIndex + start.length);

    final startIndex2 = code.indexOf(start2);
    final endIndex2 = code.indexOf(end2, startIndex2 + start2.length);

    final startIndex3 = code.indexOf(start3);
    final endIndex3 = code.indexOf(end3, startIndex3 + start3.length);

    if (code.substring(startIndex + start.length, endIndex) == " ") {
      print("La place est vide");
      if (code.contains("<validation2>")) {
        String res = excep + signature + excepp;
        print(res);
        print('Signature réussi');
        //start push in db
        final String validation = "premier vaidation";
        final String contrat = "Maintenance_chaudiere";
        SignatureModel sm =
            SignatureModel(nom, prenom, timenow, validation, contrat);

        dbHelper2.saveData(sm).then((sigantureData) {
          print(sm.usernom + sm.validation);

          //showAlertDialogSucces(context);
          //Navigator.push(context, MaterialPageRoute(builder: (_) => LoginForm()));
        }).catchError((error) {
          print(error);
          //showAlertDialogEchec(context);
        });

        return "Premiére validation par $nom";
      }
    } else if (code.substring(startIndex + start.length, endIndex) != " ") {
      if (code.substring(startIndex2 + start2.length, endIndex2) == " ") {
        if (code.contains("<validation4>")) {
          String res = excep2 + signature + excepp2;
          print(res);
          print('Signature réussi');
          return "Deuxiéme validation par $nom";
        }
      } else if (code.substring(startIndex2 + start2.length, endIndex2) !=
          " ") {
        if (code.contains("<internal_validation>")) {
          String res = excep3 + signature + excepp3;
          print(res);
          print('Signature réussi');
          return "Derniére validation par $nom";
        }
      }
    }

    return "Signature réussi";
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
