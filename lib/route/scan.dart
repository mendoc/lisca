import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:lisca/model/liste.dart';
import 'package:lisca/model/nom.dart';

import 'package:lisca/util/master.dart';

class ScanScreen extends StatefulWidget {
  final Liste liste;

  ScanScreen({Key key, @required this.liste}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState(this.liste);
}

class _ScanScreenState extends State<ScanScreen> {
  String barcode = "Scanner un QR Code afin d'afficher ce qu'il contient.";
  String message =
      "Votre liste est vide. Appuyez sur le bouton \"Ajouter\" pour ajouter un nom.";

  Future<List<Nom>> nomsE;
  List<Nom> noms;
  Liste liste;

  _ScanScreenState(this.liste);

  @override
  void initState() {
    super.initState();

    getNoms(this.liste.id).then((tousLesNoms) async {
      this.noms = tousLesNoms;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.liste.intitule,
          style: TextStyle(fontFamily: "Poppins-Regular"),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: noms.length,
            itemBuilder: (context, position) {
              return InkWell(
                onLongPress: () {
                  Nom nom = this.noms.elementAt(position);
                  deleteNom(nom.id);
                  this.noms.remove(nom);
                  setState(() {});
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
                      noms.elementAt(position).nomcomplet,
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
                  child: Visibility(
                    visible: this.noms.length <= 0,
                    child: Text(
                      this.message + this.liste.id.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black.withOpacity(0.5),
                          fontFamily: "WorkSans",
                          letterSpacing: 1.2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: scan,
        icon: Icon(Icons.camera),
        backgroundColor: Colors.blue,
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
      if (barcode != null) {
        Nom nom = Nom(
          nomcomplet: barcode,
          liste: this.liste.id,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
        saveNom(nom);
        setState(() {
          this.noms.add(nom);
        });
      }
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
