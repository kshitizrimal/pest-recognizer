import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {};

  List labels = [
    ["Pest Recognizer", "कीट पहिचानकर्ता", "कीट पहचानकर्ता"],
    ["Detect", "पत्ता लगाउनुहोस्", "पता लगाना"],
    ["Classes", "श्रेणीहरु", "श्रेणियाँ"],
    ["Change Language", "भाषा परिवर्तन गर्नुहोस्", "भाषा बदलो"],
    ["Past Records", "विगतका रेकर्डहरू", "पिछले रिकॉर्ड"]];
  int _language;

  _loadLang() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('language') == null){
      prefs.setInt('language', 1);
    }
    setState(() {
      _language = (prefs.getInt('language'));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLang();
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
      if(choice == 3){
        return labels[3][1];
      }
      if(choice == 4){
        return labels[4][1];
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
      if(choice == 3){
        return labels[3][2];
      }
      if(choice == 4){
        return labels[4][2];
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

    if(choice == 3){
      return labels[3][0];
    }
    if(choice == 4){
      return labels[4][0];
    }
    return 'null';
  }

  @override
  Widget build(BuildContext context) {
    _loadLang();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.cyan,
          title: Text(getLabel(0), style: TextStyle(color: Colors.black, fontSize: 25)),
          centerTitle: true,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: <Widget>[
          Container(
            height: 60,
            color: Colors.white,
            child: FlatButton.icon(
              onPressed: () async{
                Navigator.pushNamed(context, '/detect');
              },
              icon: Icon(Icons.camera_alt, color: Colors.black, size: 32),
              color: Colors.yellow[600],
              label: Text(
                getLabel(1),style: TextStyle(
                  color: Colors.black, fontSize: 25, ),
              ),
            ),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          ),
          Container(
            height: 70,
            color: Colors.white,
            child: FlatButton.icon(
              onPressed: () async{
                Navigator.pushNamed(context, '/past');
              },
              icon: Icon(Icons.calendar_today, color: Colors.white, size: 32,),
              color: Colors.teal,
              label: Text(
                getLabel(4),style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          ),
          Container(
            height: 70,
            color: Colors.white,
            child: FlatButton.icon(
              onPressed: () async{
                Navigator.pushNamed(context, '/classes');
              },
              icon: Icon(Icons.bookmark, color: Colors.white, size: 32,),
              color: Colors.teal,
              label: Text(
                getLabel(2),style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          ),
          Container(
            height: 70,
            color: Colors.white,
            child: FlatButton.icon(
              onPressed: () async{
                Navigator.pushNamed(context, '/language');
              },
              icon: Icon(Icons.translate, color: Colors.white, size: 32,),
              color: Colors.teal,
              label: Text(
                getLabel(3),style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          ),
        ],
      )
    );
  }
}


