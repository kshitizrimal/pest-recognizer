import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pestrecog/pages/pest_record.dart';

class PastRecord extends StatefulWidget {
  @override
  _PastRecordState createState() => _PastRecordState();
}

class _PastRecordState extends State<PastRecord> {

  List labels = [["Past Records", "विगतका रेकर्डहरू", "पिछले रिकॉर्ड"],
                ["No Records Found!", "कुनै रेकर्ड भेटिएन", "कोई रिकॉर्ड नहीं मिला"],
                ["Delete!", "मेटाउन", "हटाएं"]];
  int _language;
  List _pests;

  _loadLang() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('language') == null){
      prefs.setInt('language', 1);
    }
    setState(() {
      _language = (prefs.getInt('language'));
    });
  }

  String getLabel(int choice){
    if(_language == 1){
      if(choice == 0){
        return labels[0][1];
      }
      if(choice == 1){
        return labels[1][1];
      }
      if(choice == 2){
        return labels[2][1];
      }
    } else if(_language == 2) {
      if(choice == 0){
        return labels[0][2];
      }
      if(choice == 1){
        return labels[1][2];
      }
      if(choice == 2){
        return labels[2][2];
      }
    }

    if(choice == 0){
      return labels[0][0];
    }

    if(choice == 1){
      return labels[1][0];
    }
    if(choice == 2){
      return labels[2][0];
    }
    return 'null';
  }

  void performDBRead() async {
    var databasesPath = await getDatabasesPath();
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'pest_record_v2.db'),
      // When the database is first created, create a table to store pests.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE pests(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, date TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    Future<List<PestRecord>> pests() async {
      // Get a reference to the database.
      final Database db = await database;

      // Query the table for all The pests.
      final List<Map<String, dynamic>> maps = await db.query('pests');

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return PestRecord(
          id: maps[i]['id'],
          name: maps[i]['name'],
          date: maps[i]['date'],
        );
      });
    }

    List pestTemp = await pests();

    setState(() {
      _pests = pestTemp;
    });

  }

  void performDBDelete(int id) async {
    var databasesPath = await getDatabasesPath();
    final database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'pest_record_v2.db'),
      // When the database is first created, create a table to store pests.
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE pests(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, date TEXT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    Future<void> deletePest(id) async {
      // Get a reference to the database.
      final db = await database;

      // Remove the Pest from the database.
      await db.delete(
        'pests',
        // Use a `where` clause to delete a specific pest.
        where: "id = ?",
        // Pass the pest's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    }

    Future<List<PestRecord>> pests() async {
      // Get a reference to the database.
      final Database db = await database;

      // Query the table for all The pests.
      final List<Map<String, dynamic>> maps = await db.query('pests');

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return PestRecord(
          id: maps[i]['id'],
          name: maps[i]['name'],
          date: maps[i]['date'],
        );
      });
    }

    deletePest(id);

    List pestTemp = await pests();

    setState(() {
      _pests = pestTemp;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLang();
    performDBRead();
  }

  Widget cardPrint() {

    if(_pests == null || _pests.isEmpty){
      return Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0,50,0,0),
          child: Center(child: Text(getLabel(1), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green[900]))),
        ),
      );
    }

    List<PestRecord> pests = _pests;
//    print(_pests);
    return getTextWidgets(pests);
  }

  Widget getTextWidgets(List<PestRecord> pests)
  {
    List<Widget> list = List<Widget>();
    for(var i = 0; i < pests.length; i++){
      list.add(Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ListTile(
                title: Text(pests[i].name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 25,),),
                subtitle: Text(pests[i].date, style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w500, fontSize: 18,),),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(getLabel(2), style: TextStyle(color: Colors.red, fontWeight: FontWeight.w300, fontSize: 18,),),
                  onPressed: (){performDBDelete(pests[i].id);},
                )
              ],
            )
          ],
        ),
      ));
    }
    return new Column(children: list);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(getLabel(0), style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20,0,20,0),
        child: ListView(
          padding: EdgeInsets.fromLTRB(0,10,0,0),
          children: <Widget> [
            cardPrint()
          ],
        ),
      ),
    );
  }
}



