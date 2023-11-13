import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:newecommerce/repositories/user_repository.dart';
import 'package:http/src/response.dart' as mreponse;

import 'constants.dart';
import 'getxcontroller/getusercontroller.dart';
import 'httpbeans/beancustomercreation.dart';
import 'httpbeans/commune.dart';
import 'models/user.dart';
import 'newpage.dart';
import 'package:http/http.dart' as https;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class EcranCreationCompte extends StatefulWidget {
  const EcranCreationCompte({Key? key, required this.client}) : super(key: key);
  final https.Client client;

  @override
  State<EcranCreationCompte> createState() => _NewCreationState();
}

class _NewCreationState extends State<EcranCreationCompte> {

  // LINK :
  // https://api.flutter.dev/flutter/material/AlertDialog-class.html

  // A t t r i b u t e s  :
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  late bool _isLoading;
  // Initial value :
  var dropdownvalue = "Koumassi";
  String defaultGenre = "M";
  final lesGenres = ["M", "F"];
  final _userRepository = UserRepository();
  late BuildContext dialogContext;
  bool flagSendData = false;
  //
  final UserGetController _userController = Get.put(UserGetController());
  late https.Client client;
  //
  String? getToken = "";



  // M E T H O D S
  @override
  void initState() {
    super.initState();

    client = widget.client!;
    /*Future.delayed(const Duration(milliseconds: 1000), () {
    });*/
  }


  // Get VILLE :
  Future<List<Commune>> communeLoading() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getmobileAllCommunes');
    mreponse.Response response = await client.get(url);
    if(response.statusCode == 200){
      _isLoading = true;
      List<dynamic> body = jsonDecode(response.body);
      List<Commune> posts = body
          .map(
            (dynamic item) => Commune.fromJson(item),
      )
          .toList();

      // Update COMMUNE :
      codeController = TextEditingController(text: _userController.userData.isNotEmpty ? _userController.userData[0].codeinvitation : '');
      nomController = TextEditingController(text: _userController.userData.isNotEmpty ? _userController.userData[0].nom : '');
      prenomController = TextEditingController(text: _userController.userData.isNotEmpty ? _userController.userData[0].prenom : '');
      emailController = TextEditingController(text: _userController.userData.isNotEmpty ? _userController.userData[0].email : '');
      numeroController = TextEditingController(text: _userController.userData.isNotEmpty ? _userController.userData[0].numero : '');
      adresseController = TextEditingController(text: _userController.userData.isNotEmpty ? _userController.userData[0].adresse : '');
      defaultGenre = _userController.userData.isNotEmpty ? (_userController.userData[0].genre==1 ? "M" : "F") : "M";
      dropdownvalue = _userController.userData.isNotEmpty ? posts.where((e) => e.idcom==_userController.userData[0].commune).first.libelle :
        posts[0].libelle;
      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  // Process :
  bool checkField(){
    if(nomController.text.isEmpty || prenomController.text.isEmpty || emailController.text.isEmpty || adresseController.text.isEmpty){
      return true;
    }
    return false;
  }

  //
  void generateTokenSuscription(int commune, int genre) async {
    await FirebaseMessaging.instance.subscribeToTopic("gouabocross");
    getToken = await FirebaseMessaging.instance.getToken();

    sendAccountRequest(commune, genre);
  }

  // Send Account DATA :
  Future<void> sendAccountRequest(int commune, int genre) async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/managecustomer');
    var response = await client.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idcli": _userController.userData.isNotEmpty ? _userController.userData[0].idcli : 0,
          "nom": nomController.text,
          "prenom": prenomController.text,
          "email": emailController.text,
          "numero": numeroController.text,
          "commune": commune,
          "adresse": adresseController.text,
          "genre": genre,
          "fcmtoken": _userController.userData.isEmpty ? getToken : "",
          "pwd": "",
          "codeinvitation": codeController.text,
        }));

    // Checks :
    if(response.statusCode == 200){
      //List<dynamic> body = jsonDecode(response.body);
      BeanCustomerCreation bn = BeanCustomerCreation.fromJson(json.decode(response.body));
      if(bn != null){
        if(bn.leFlag == 2){
          _userController.addData(bn.leUser);
          /*await _userRepository.insertUser(bn.leUser);
          // Call this :
          _userRepository.getCurrentUser();*/
        }
        else{
          Fluttertoast.showToast(
              msg: "Erreur apparue",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      }

      // Set FLAG :
      flagSendData = false;
    }

    /*if (response.statusCode == 201) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Post created successfully!"),
      ));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to create post!"),
      ));
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Future.wait([communeLoading()]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            List<Commune> pt =  snapshot.data[0];
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 60, left: 10),
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.brown,
                          size: 80.0,
                        ),
                      ) ,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 10),
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Compte",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )
                        ),
                      ) ,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5, top: 10),
                            child: TextField(
                              controller: nomController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nom...',
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 10, top: 10),
                            child: TextField(
                              controller: prenomController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Prénom...',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email...',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: numeroController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Numéro...',
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: DropdownMenu<String>(
                              // Initial Value
                              initialSelection: pt.first.libelle,
                              onSelected: (String? value) {
                                // This is called when the user selects an item.
                                /*setState(() {
                                dropdownvalue = value!;
                              });*/
                                dropdownvalue = value!;
                              },
                              dropdownMenuEntries: pt.map((commune) => commune.libelle).toList()
                                  .map<DropdownMenuEntry<String>>((String value) {
                                return DropdownMenuEntry<String>(value: value, label: value);
                              }).toList(),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: adresseController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Adresse...',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 10),
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: Text("Genre",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            )
                        ),
                      ) ,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 10, left: 10),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: DropdownMenu<String>(
                            // Initial Value
                            initialSelection: defaultGenre,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              defaultGenre = value!;
                            },
                            dropdownMenuEntries: lesGenres.map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(value: value, label: value);
                            }).toList(),
                          ) ,
                        )
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        enabled: _userController.userData.isNotEmpty ?
                          _userController.userData[0].codeinvitation.isNotEmpty ? false : true : true,
                        controller: codeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Code Invitation (Facultatif)...',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey)
                                ),
                                label: const Text("Retour",
                                    style: TextStyle(
                                        color: Colors.white
                                    )),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.brown)
                                ),
                                label: const Text("Enregistrer",
                                  style: TextStyle(
                                    color: Colors.white
                                    )
                                  ),
                                onPressed: () {
                                  if(checkField()){
                                    Fluttertoast.showToast(
                                        msg: "Veuillez renseigner les champs !",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                  else{
                                    // Get 'COMMUNE' id
                                    var idComm = pt.where((d) => d.libelle==dropdownvalue).first.idcom;
                                    // Get 'Genre' id :
                                    var idGenr = defaultGenre == "M" ? 1 : 0;
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          dialogContext = context;
                                          return const AlertDialog(
                                            title: Text('Information'),
                                            content: Text("Veuillez patienter ..."),
                                            /*actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ]*/
                                          );
                                        }
                                    );

                                    // Send DATA :
                                    flagSendData = true;
                                    if(defaultTargetPlatform == TargetPlatform.android){
                                      generateTokenSuscription(idComm, idGenr); // FOr TOKEN
                                    }
                                    else{
                                      // Currently not running FCM for iphone
                                      sendAccountRequest(idComm, idGenr);
                                    }

                                    // Run TIMER :
                                    Timer.periodic(
                                      const Duration(seconds: 1),
                                          (timer) {
                                        // Update user about remaining time
                                        if(!flagSendData){
                                          Navigator.pop(dialogContext);
                                          timer.cancel();

                                          // Kill ACTIVITY :
                                          if(Navigator.canPop(context)){
                                            Navigator.pop(context);
                                            //Navigator.of(context).pop({'selection': '1'});
                                          }
                                          /*else{
                                          SystemNavigator.pop();
                                        }*/
                                        }
                                      },
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.save,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        )

                        /*MaterialButton(
                        onPressed: () => {},
                        child: Text('REGISTER'),
                      )*/,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          else{
            return ListView.separated(
              shrinkWrap: true,
              itemCount: 7,
              itemBuilder: (context, index) => const NewsCardSkelton(),
              separatorBuilder: (context, index) =>
              const SizedBox(height: defaultPadding),
            );
          }
        }
      )
    );
  }
}