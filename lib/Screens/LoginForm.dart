import 'package:flutter/material.dart';
import 'package:fluttersignature/Comm/comHelper.dart';
import 'package:fluttersignature/Comm/genLoginSignupHeader.dart';
import 'package:fluttersignature/Comm/genTextFormField.dart';
import 'package:fluttersignature/DatabaseHandler/DbHelper.dart';
import 'package:fluttersignature/Model/UserModel.dart';
import 'package:fluttersignature/Screens/HomeForm.dart';
import 'package:fluttersignature/Screens/SignupForm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final _formkey = new GlobalKey<FormState>();

  final _conUserTel = TextEditingController();
  final _conPassword = TextEditingController();

  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
  }

//----------------Login---------------
  login() async {
    String tel = _conUserTel.text;
    String password = _conPassword.text;

    if (tel.isEmpty || password.isEmpty) {
      showAlertDialogEchec(context);
    } else {
      await dbHelper.getLoginUser(tel, password).then((userData) {
        //mkfjzeoifoizehf
        print("Votre Numero de tel :" + userData.tel);
        if (tel == userData.tel && password == userData.password) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeForm()),
                (Route<dynamic> route) => false);
          });
        } else {
          print("Les informations sont pas correctes");
        }

        //mkfjzeoifoizehf
      }).catchError((error) {
        print(error);
        print("y a des erruers");
        showAlertDialogEchec(context);
      });

      /*if (dbHelper.getLoginUser(tel, passwd) != null) {
        print("sucess" + tel);
      } else {
        print("true");
      }*/
    }
  }

  Future setSP(UserModel user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("user_nom", user.usernom);
    sp.setString("user_prenom", user.userprenom);
    sp.setString("tel", user.tel);
    sp.setString("password", user.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.0),
              genLoginSignupHeader('Connecter'),
              //Telephone -----------------------------------------------------------
              getTextFormField(
                  controller: _conUserTel,
                  hintName: 'N°Téléphone',
                  inputType: TextInputType.phone,
                  icon: Icons.person),
              SizedBox(height: 5.0),
              //Password ----------------------------------------------------------
              getTextFormField(
                  controller: _conPassword,
                  hintName: 'Password',
                  icon: Icons.lock,
                  isObscureText: true),
              // Button Login -----------------------------------------------------
              Container(
                margin: EdgeInsets.all(30.0),
                width: double.infinity,
                child: FlatButton(
                  child: Text(
                    'Se connecter',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: login,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Créer votre compte'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text('S\'inscrire'),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SignupForm()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
