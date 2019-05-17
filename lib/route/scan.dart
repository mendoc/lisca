import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:barcode_scan/barcode_scan.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String barcode = "Scanner un QR Code afin d'afficher ce qu'il contient.";
  List<String> noms = <String>[];
  String homeText =
      "Votre liste est vide. Appuyez sur le bouton \"Ajouter\" pour ajouter un nom.";
  String message = "";

  @override
  void initState() {
    super.initState();
    this.message = (this.noms.length > 0) ? "" : this.homeText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des noms"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: noms.length,
            itemBuilder: (context, position) {
              return InkWell(
                onLongPress: () {
                  this.noms.remove(this.noms[position]);
                  setState(() {
                    this.message = (this.noms.length > 0) ? "" : this.homeText;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: Colors.grey.shade300))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 20.0),
                    child: Text(
                      noms[position],
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "Poppins-Light",
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(
                      this.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black.withOpacity(0.5),
                          fontFamily: "Popins-Light",
                          letterSpacing: 1.2),
                    ),
                  ),
                  /*Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    barcode,
                    style: TextStyle(fontSize: 24.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),*/
                ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: scan,
        icon: Icon(Icons.camera),
        backgroundColor: Colors.green,
        label: Text(
          "Ajouter",
          style: TextStyle(fontFamily: "Poppins-Regular"),
        ),
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.noms.add(barcode);
        this.message = (this.noms.length > 0) ? "" : this.homeText;
      }); 
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() => this.barcode = "Pas accès à la caméra.");
      } else {
        setState(() => this.barcode = 'Erreur inconnue: $e');
      }
    } on FormatException {
      setState(() => this.barcode = "Rien n'à afficher.");
    } catch (e) {
      setState(() => this.barcode = 'Oups! Quelque chose à mal tourné: $e');
    }
  }
}
