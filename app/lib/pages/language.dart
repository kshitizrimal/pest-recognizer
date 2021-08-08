import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {

  List labels = ["Change Language", "भाषा परिवर्तन गर्नुहोस्", "भाषा बदलो"];
  int _language;

  String getLabel(){
    if(_language == 1){
      return labels[1];
    } else if(_language == 2) {
      return labels[2];
    }
    return labels[0];
  }

  //Loading counter value on start
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = (prefs.getInt('language'));
    });
  }

  _englishSet() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('language', 0);
    Navigator.pop(context);
  }

  _nepaliSet() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('language', 1);
    Navigator.pop(context);
  }

  _hindiSet() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('language', 2);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _loadCounter();
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
          title: Text(getLabel(), style: TextStyle(color: Colors.white),),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(50,20,50,0),
          child: ListView(
            padding: EdgeInsets.fromLTRB(0,30,0,0),
            children: <Widget> [
              Container(
                height: 60,
                color: Colors.white,
                child: FlatButton(
                  onPressed: _nepaliSet,
                  color: Colors.blueGrey,
                  child: Text(
                    'नेपाली',style: TextStyle(
                    color: Colors.white, fontSize: 25, ),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
              ),
              Container(
                height: 60,
                color: Colors.white,
                child: FlatButton(
                  onPressed: _englishSet,
                  color: Colors.blueGrey,
                  child: Text(
                    'English',style: TextStyle(
                    color: Colors.white, fontSize: 25, ),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
              ),
              Container(
                height: 60,
                color: Colors.white,
                child: FlatButton(
                  onPressed: _hindiSet,
                  color: Colors.blueGrey,
                  child: Text(
                    'हिंदी',style: TextStyle(
                    color: Colors.white, fontSize: 25, ),
                  ),
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
              ),
            ],
          ),
        ),
    );
  }
}
