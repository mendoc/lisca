import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model/liste.dart';
import 'route/scan.dart';

void main() async {
  // Open the database and store the reference
  final Future<Database> database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'lisca_database.db'),

    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE liste(id INTEGER PRIMARY KEY AUTOINCREMENT, intitule TEXT, timestamp INTEGER)");
    },
    version: 2,
  );

  Future<void> saveListe(Liste liste) async {
    final Database db = await database;

    await db.insert(
      "liste",
      liste.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("Enregistrement de la liste");
  }

  Future<List<Liste>> getListes() async {
    final Database db = await database;

    final List<Map<String, dynamic>> listesMap = await db.query("liste");

    return List.generate(
      listesMap.length,
      (i) {
        return Liste(
          id: listesMap[i]["id"],
          intitule: listesMap[i]["intitule"],
          timestamp: listesMap[i]["timestamp"],
        );
      },
    );
  }

  saveListe(
    Liste(
        intitule: "Nouvelle liste",
        timestamp: DateTime.now().millisecondsSinceEpoch),
  );

  print(await getListes());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lisca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScanScreen(),
    );
  }
}
