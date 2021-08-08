import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Classes extends StatefulWidget {
  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {

  int _language;
  List labels = ["Classes", "श्रेणीहरु", "श्रेणियाँ"];

  List<String> categories = ['Rice leaf roller',
    'Rice leaf caterpillar',
    'Paddy stem maggot',
    'Asiatic rice borer',
    'Yellow rice borer',
    'Rice gall midge',
    'Rice stemfly',
    'Brown plant hopper',
    'White backed plant hopper',
    'Small brown plant hopper',
    'Rice water weevil',
    'Rice leafhopper',
    'Grain spreader thrips',
    'Rice shell pest',
    'Grub',
    'Mole cricket',
    'Wireworm',
    'White margined moth',
    'Black cutworm',
    'Large cutworm',
    'Yellow cutworm',
    'Red spider',
    'Corn borer',
    'Army worm',
    'Aphids',
    'Potosiabre vitarsis',
    'Peach borer',
    'English grain aphid',
    'Green bug',
    'Bird cherry-oataphid',
    'Wheat blossom midge',
    'Penthaleus major',
    'Longlegged spider mite',
    'Wheat phloeothrips',
    'Wheat sawfly',
    'Cerodonta denticornis',
    'Beet fly',
    'Flea beetle',
    'Cabbage army worm',
    'Beet army worm',
    'Beet spot flies',
    'Meadow moth',
    'Beet weevil',
    'Sericaorient alismots chulsky',
    'Alfalfa weevil',
    'Flax budworm',
    'Alfalfa plant bug',
    'Tarnished plant bug',
    'Locustoidea',
    'Lytta polita',
    'Legume blister beetle',
    'Blister beetle',
    'Therioaphis maculata buckton',
    'Odontothrips loti',
    'Thrips',
    'Alfalfa seed chalcid',
    'Pieris canidia',
    'Apolygus lucorum',
    'Limacodidae',
    'Viteus vitifoliae',
    'Colomerus vitis',
    'Brevipoalpus lewisi mcgregor',
    'Oides decempunctata',
    'Polyphagotars onemus latus',
    'Pseudococcus comstocki kuwana',
    'Parathrene regalis',
    'Ampelophaga',
    'Lycorma delicatula',
    'Xylotrechus',
    'Cicadella viridis',
    'Miridae',
    'Trialeurodes vaporariorum',
    'Erythroneura apicalis',
    'Papilio xuthus',
    'Panonchus citri mcgregor',
    'Phyllocoptes oleiverus ashmead',
    'Icerya purchasi maskell',
    'Unaspis yanonensis',
    'Ceroplastes rubens',
    'Chrysomphalus aonidum',
    'Parlatoria zizyphus lucus',
    'Nipaecoccus vastalor',
    'Aleurocanthus spiniferus',
    'Tetradacus c bactrocera minax',
    'Dacus dorsalis(hendel)',
    'Bactrocera tsuneonis',
    'Prodenia litura',
    'Adristyrannus',
    'Phyllocnistis citrella stainton',
    'Toxoptera citricidus',
    'Toxoptera aurantii',
    'Aphis citricola vander goot',
    'Scirtothrips dorsalis hood',
    'Dasineura sp',
    'Lawana imitata melichar',
    'Salurnis marginella guerr',
    'Deporaus marginatus pascoe',
    'Chlumetia transversa',
    'Mango flat beak leafhopper',
    'Rhytidodera bowrinii white',
    'Sternochetus frigidus',
    'Cicadellidae'];

  _loadLang() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = (prefs.getInt('language'));
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLang();
  }

  String getLabel(){
    if(_language == 1){
      return labels[1];
    } else if(_language == 2) {
      return labels[2];
    }
    return labels[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
          title: Text(getLabel(), style: TextStyle(color: Colors.white),),
        ),
        body: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,10,10,0),
              child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(padding: EdgeInsets.all(1), child: Card(child: Padding(padding: EdgeInsets.all(15), child: Text((index+1).toString()+" — "+categories[index]),),),);
                  }
              ),
            )
        )
    );
  }
}