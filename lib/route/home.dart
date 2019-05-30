import 'package:flutter/material.dart';
import 'package:lisca/model/liste.dart';
import 'package:lisca/route/scan.dart';
import 'package:lisca/util/master.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Liste>> listes;

  @override
  void initState() {
    super.initState();
    listes = getListes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Toutes les listes",
          style: TextStyle(fontFamily: "Poppins-Regular"),
        ),
      ),
      body: FutureBuilder<List<Liste>>(
        future: this.listes,
        builder: (context, snap) {
          if (snap.data == null) {
            return Container(
              child: Text("Aucune liste enregistrée"),
            );
          } else {
            return ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: (context, position) {
                var liste = snap.data.elementAt(position);
                String date = formatDate(liste.timestamp);
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ScanScreen(
                              liste: liste,
                            ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.withOpacity(0.3)))),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                liste.intitule,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(.6),
                                    fontSize: 18.0,
                                    fontFamily: "WorkSans"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                date,
                                style: TextStyle(
                                    fontFamily: "WorkSans", fontSize: 11.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
