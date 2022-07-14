import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:qr_flutter/qr_flutter.dart';

class CreateSignature extends StatefulWidget {
  CreateSignature({Key? key}) : super(key: key);

  @override
  State<CreateSignature> createState() => _CreateSignatureState();
}

class _CreateSignatureState extends State<CreateSignature> {
  String data = "";

  fetchFileData() async {
    String responseText;
    responseText =
        await rootBundle.loadString('contrats/Maintenance_chaudiere.xml');

    setState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    fetchFileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create signature'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80.0),
              Text(
                'Votre Contrat',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 30.0),
              ),
              SizedBox(height: 80.0),
              Container(
                child: QrImage(
                  data: data,
                  size: 300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
