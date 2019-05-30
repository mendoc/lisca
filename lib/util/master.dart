import 'package:lisca/model/liste.dart';
import 'package:lisca/model/nom.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Liste>> getListes() async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'lisca_database.db'),
  );

  final Database db = await database;

  final List<Map<String, dynamic>> listesMap = await db.query("liste");

  return List.generate(
    listesMap.length,
    (position) {
      return Liste(
          id: listesMap[position]["id"],
          intitule: listesMap[position]["intitule"],
          timestamp: listesMap[position]["timestamp"]);
    },
  );
}

Future<List<Nom>> getNoms(int liste_id) async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'lisca_database.db'),
  );

  final Database db = await database;

  final List<Map<String, dynamic>> nomsMap =
      await db.query("nom", where: "liste = ?", whereArgs: [liste_id]);

  return List.generate(
    nomsMap.length,
    (position) {
      return Nom(
          id: nomsMap[position]["id"],
          nomcomplet: nomsMap[position]["nom"],
          liste: nomsMap[position]["liste"],
          timestamp: nomsMap[position]["timestamp"]);
    },
  );
}

Future<void> saveNom(Nom nom) async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'lisca_database.db'),
  );
  final Database db = await database;

  await db.insert(
    "nom",
    nom.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  print("Enregistrement du nom");
  print(nom.toString());
}

Future<int> deleteNom(int id) async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'lisca_database.db'),
  );
  final db = await database;

  return db.delete("nom", where: "id = ?", whereArgs: [id]);
}

String formatDate(int milli) {
  var dt = DateTime.fromMillisecondsSinceEpoch(milli);
  int jour = dt.day;
  int mois = dt.month;
  int annee = dt.year;
  int heure = dt.hour;
  int minute = dt.minute;

  String mo = mois < 10 ? "0$mois" : mois.toString();
  String mi = (minute < 10) ? "0$minute" : minute.toString();
  String hr = heure < 10 ? "0$heure" : heure.toString();

  return "$jour/$mo/$annee à $hr:$mi";
}
