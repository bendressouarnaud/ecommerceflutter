import 'dart:async';
import 'dart:convert';

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
import 'httpbeans/beancustomerauth.dart';
import 'httpbeans/beancustomercreation.dart';
import 'httpbeans/commune.dart';
import 'models/user.dart';
import 'newpage.dart';
import 'package:http/http.dart' as https;


class AuthentificationEcran extends StatefulWidget {
  const AuthentificationEcran({Key? key, required this.client}) : super(key: key);
  final https.Client client;

  @override
  State<AuthentificationEcran> createState() => _NewAuth();
}

class _NewAuth extends State<AuthentificationEcran> {

  // LINK :
  // https://api.flutter.dev/flutter/material/AlertDialog-class.html

  // A t t r i b u t e s  :
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
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



  // M E T H O D S
  @override
  void initState() {
    super.initState();

    client = widget.client!;
  }


  // Process :
  bool checkField(){
    if(emailController.text.isEmpty || pwdController.text.isEmpty){
      return true;
    }
    return false;
  }


  // Send Account DATA :
  Future<void> authenicatemobilecustomer() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/authenicatemobilecustomer');
    var response = await client.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "mail": emailController.text,
          "pwd": pwdController.text,
          "fcmtoken": ""
        }));

    // Checks :
    if(response.statusCode == 200){
      //List<dynamic> body = jsonDecode(response.body);
      BeanCustomerAuth bn = BeanCustomerAuth.fromJson(json.decode(response.body));
      if(bn != null){
        if(bn.flag != 0){
          // Save it :
          _userController.addData(bn.clt);
        }
        else{
          Fluttertoast.showToast(
              msg: "Veuillez vérifier vos paramètres !",
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                    child: Text("Authentification",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )
                    ),
                  ) ,
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email...',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: pwdController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mot de passe...',
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
                            onPressed: () {},
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
                                authenicatemobilecustomer();

                                // Run TIMER :
                                Timer.periodic(
                                  const Duration(seconds: 1),
                                      (timer) {
                                    // Update user about remaining time
                                    if(!flagSendData){
                                      Navigator.pop(dialogContext);
                                      timer.cancel();

                                      // Kill ACTIVITY :
                                      if(_userController.userData.isNotEmpty){
                                        if(Navigator.canPop(context)){
                                          Navigator.pop(context);
                                        }
                                      }
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
        )
    );
  }
}