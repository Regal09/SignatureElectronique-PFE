import 'package:flutter/material.dart';
import 'package:fluttersignature/Comm/comHelper.dart';
import 'package:fluttersignature/Comm/genTextFormField.dart';
import 'package:fluttersignature/DatabaseHandler/DbHelper.dart';
import 'package:fluttersignature/Model/UserModel.dart';
import 'package:fluttersignature/Screens/LoginForm.dart';
import 'package:toast/toast.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formkey = new GlobalKey<FormState>();

  final _conUserNom = TextEditingController();
  final _conUserPrenom = TextEditingController();
  final _conUserTel = TextEditingController();
  final _conPassword = TextEditingController();

  var dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

  Registre() async {
    String unom = _conUserNom.text;
    String uprenom = _conUserPrenom.text;
    String tel = _conUserTel.text;
    String passwd = _conPassword.text;

    if (_formkey.currentState!.validate()) {
      print(unom);
      _formkey.currentState!.save();
      UserModel um = UserModel(unom, uprenom, tel, passwd);
      await dbHelper.saveData(um).then((userData) {
        print("Réussir l'inscription");

        //showAlertDialogSucces(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginForm()));
      }).catchError((error) {
        print(error);
        showAlertDialogEchec(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 130.0),
                Text(
                  'Inscription',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 30.0),
                ),
                SizedBox(height: 10.0),
                //Nom -----------------------------------------------------------
                getTextFormField(
                    controller: _conUserNom,
                    hintName: 'Nom',
                    inputType: TextInputType.name,
                    icon: Icons.person),
                SizedBox(height: 5.0),
                //Prenom -----------------------------------------------------------
                getTextFormField(
                    controller: _conUserPrenom,
                    hintName: 'Prenom',
                    inputType: TextInputType.name,
                    icon: Icons.person_outline),

                SizedBox(height: 5.0),
                //Telephone -----------------------------------------------------------
                getTextFormField(
                    controller: _conUserTel,
                    hintName: 'N°Téléphone',
                    inputType: TextInputType.phone,
                    icon: Icons.phone),
                SizedBox(height: 5.0),

                //Password ----------------------------------------------------------
                getTextFormField(
                    controller: _conPassword,
                    hintName: 'Password',
                    icon: Icons.lock,
                    isObscureText: true),

                // Button Register -----------------------------------------------------
                Container(
                  margin: EdgeInsets.fromLTRB(30, 40, 30, 10),
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      'S\'inscrire',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: Registre,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                //Does not have an account
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Vous avez déjà un compte'),
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text('Se connecter'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => LoginForm()),
                              (Route<dynamic> route) => false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
