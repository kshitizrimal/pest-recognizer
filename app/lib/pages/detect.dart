import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:pestrecog/pages/pest_record.dart';


// stateless widget to load main home widget
class Detect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DetectMain();
  }
}

class DetectMain extends StatefulWidget {
  // private camera object: get assigned to global one
  DetectMain();
  @override
  _DetectMainState createState() => new _DetectMainState();
}

class _DetectMainState extends State<DetectMain> {

  File _image;
  double _imageWidth;
  double _imageHeight;
  bool _busy = false;
  var _recognitions;
  var responseLoad;
  int _language;

  List labels = [
    ["Detect Pest!","कीट पत्ता लगाउनुहोस्", "कीट का पता लगाएं"],
    ["Camera", "क्यामेरा", "कैमरा"],
    ["Gallery", "ग्यालरी", "गेलरी"],
    ["Please select an image from camera or gallery",
    "कृपया क्यामेरा वा ग्यालरीबाट छवि चयन गर्नुहोस्",
    "कृपया कैमरा या गैलरी से एक छवि का चयन करें"],
    ["Could not identify","पहिचान गर्न सकेन","पहचान नहीं हो सकी"]
  ];

  void performDB(String predictRecognition) async {

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

    Future<void> insertPest(PestRecord pest) async {
      // Get a reference to the database.
      final Database db = await database;

      await db.insert(
        'pests',
        pest.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    Future<List<PestRecord>> pests() async {
      // Get a reference to the database.
      final Database db = await database;

      // Query the table for all The pests.
      final List<Map<String, dynamic>> maps = await db.query('pests');

      // Convert the List<Map<String, dynamic> into a List<PestRecord>.
      return List.generate(maps.length, (i) {
        return PestRecord(
          id: maps[i]['id'],
          name: maps[i]['name'],
          date: maps[i]['date'],
        );
      });
    }

    DateTime now = DateTime.now();
    String dateFormat = DateFormat('yyyy-MM-dd').format(now);
    var pestRecord = PestRecord(
      name: predictRecognition,
      date: dateFormat,
    );

    // Insert a pest into the database.
    await insertPest(pestRecord);
    print(await pests());
  }

  _loadLang() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = (prefs.getInt('language'));
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
      );
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  // run prediction using TFLite on given image
  Future predict(File image) async {

    var recognitions = await Tflite.runModelOnImage(
        path: image.path,   // required
        imageMean: 0.0,   // defaults to 117.0
        imageStd: 255.0,  // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0.2,   // defaults to 0.1
        asynch: true      // defaults to true
    );
    print("recognition type:");
    print(recognitions.runtimeType);
    print("inside element type:");
    print(recognitions[0].runtimeType);
    print("inside datatypes: \n");
    print(recognitions[0]['confidence'].runtimeType);
    print(recognitions[0]['index'].runtimeType);
    print(recognitions[0]['label'].runtimeType);
    print(recognitions);

    setState(() {
      _recognitions = recognitions;
    });

    if(_recognitions.isNotEmpty) {
      String pLabel = _recognitions[0]['label'].toString().toUpperCase();
      performDB(pLabel);
    }

  }

  // send image to predict method selected from gallery or camera
  sendImage(File image) async {
    if(image == null) return;
    await predict(image);

    // get the width and height of selected image
    FileImage(image).resolve(ImageConfiguration()).addListener((ImageStreamListener((ImageInfo info, bool _){
      setState(() {
        _imageWidth = info.image.width.toDouble();
        _imageHeight = info.image.height.toDouble();
      });
    })));

    print("Image type:");
    print(image.runtimeType);

    setState(() {
      _image = image;
      _busy = false;
    });
  }

  // select image from gallery
  selectFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image == null) return;
    setState(() {
      _busy = true;
    });
    sendImage(image);
  }

  // select image from camera
  selectFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if(image == null) return;
    setState(() {
      _busy = true;
    });
    sendImage(image);
  }

  @override
  void initState() {
    super.initState();
    _loadLang();
    loadModel().then((val) {
      setState(() {});
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

  Widget printValue(rcg) {
    if (rcg == null) {
      return Text('', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700));
    }else if(rcg.isEmpty){
      return Center(
        child: Text(getLabel(4), style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
      );
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(0,0,0,0),
      child: Center(
        child: Text(
          _recognitions[0]['label'].toString().toUpperCase(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  // gets called every time the widget need to re-render or build
  @override
  Widget build(BuildContext context) {

    // get the width and height of current screen the app is running on
    Size size = MediaQuery.of(context).size;

    // initialize two variables that will represent final width and height of the segmentation
    // and image preview on screen
    double finalW;
    double finalH;

    // when the app is first launch usually image width and height will be null
    // therefore for default value screen width and height is given
    if(_imageWidth == null && _imageHeight == null) {
      finalW = size.width;
      finalH = size.height;
    }else {

      // ratio width and ratio height will given ratio to
      // scale up or down the preview image and segmentation
      double ratioW = size.width / _imageWidth;
      double ratioH = size.height / _imageHeight;

      // final width and height after the ratio scaling is applied
      finalW = _imageWidth * ratioW*.6;
      finalH = _imageHeight * ratioH*.3;
    }

    List<Widget> stackChildren = [];

    // when busy load a circular progress indicator
    if(_busy) {
      stackChildren.add(Positioned(
        top: 0,
        left: 0,
        child: Center(child: CircularProgressIndicator(),),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(getLabel(0), style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
            height: 70,
            width: 170,
            color: Colors.redAccent,
            child: FlatButton.icon(
              onPressed: selectFromCamera,
              icon: Icon(Icons.camera_enhance, color: Colors.white, size: 32,),
              color: Colors.redAccent,
              label: Text(
                getLabel(1),style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
          ),
              Container(
            height: 70,
            width: 170,
            color: Colors.redAccent,
            child: FlatButton.icon(
              onPressed: selectFromGallery,
              icon: Icon(Icons.image, color: Colors.white, size: 32,),
              color: Colors.redAccent,
              label: Text(
                getLabel(2),style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
          ),
            ],
          ),
          Padding(
        padding: EdgeInsets.fromLTRB(0,10,0,10),
        child: _image == null ? Center(child: Text(getLabel(3)),): Center(child: Image.file(_image, fit: BoxFit.fill, width: finalW, height: finalH)),
      ),
          Padding(
        padding: EdgeInsets.fromLTRB(0,10,0,30),
        child: printValue(_recognitions),
      ),
        ],
      )

//      Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        mainAxisAlignment: MainAxisAlignment.start,
//      ),
    );
  }
}