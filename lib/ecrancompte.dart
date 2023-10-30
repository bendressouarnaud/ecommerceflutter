import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:newecommerce/beanproduit.dart';
import 'package:newecommerce/blocs/user_bloc.dart';
import 'package:newecommerce/skeleton.dart';
import 'package:shimmer/shimmer.dart';
import 'carouselcustom.dart';
import 'constants.dart';
import 'package:http/http.dart';

import 'ecrancreationcompte.dart';
import 'getxcontroller/getusercontroller.dart';
import 'httpbeans/beanarticledetail.dart';
import 'models/user.dart';

class EcranCompte extends StatefulWidget {
  const EcranCompte({Key? key}) : super(key: key);

  @override
  State<EcranCompte> createState() => _NewEcranState();
}

class _NewEcranState extends State<EcranCompte> with WidgetsBindingObserver {
  // A t t r i b u t e s  :
  late Future<List<Produit>> futureProduit;
  late Future<List<Beanarticledetail>> futureBeanarticle;
  late bool _isLoading;
  int callNumber = 0;
  int currentPageIndex = 0;
  //final UserBloc userBloc = UserBloc();
  int idcli = 12;
  String selection = "";
  //
  final UserGetController _userController = Get.put(UserGetController());



  // M e t h o d  :
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 400), () {
      _userController.refreshMainInterface();
    });
    super.initState();
  }


  @override
  void dispose(){
    //WidgetsBinding.instance.removeObserver(this);
    //userBloc.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      /*var snackBar = const SnackBar(content: Text('RESUME'));
      // Step 3
      ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
    }
    else if(state == AppLifecycleState.inactive){
      /*var snackBar = const SnackBar(content: Text('INACTIVE'));
      // Step 3
      ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
    }else if(state == AppLifecycleState.paused){
      /*var snackBar = const SnackBar(content: Text('PAUSE'));
      // Step 3
      ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
    }
  }

  //
  Future _buttonTapped() async {
    Map results =  await Navigator.of(context).push(MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return const EcranCreationCompte();
      },
    ));

    if (results != null && results.containsKey('selection')) {
      selection = results['selection'];
      if(selection == "1"){
        //userBloc.getCurrentUser();
        /*Fluttertoast.showToast(
            msg: "This is Center Short Toast",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );*/
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        /*appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Gouabo", textAlign: TextAlign.start, ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
          ),
          actions: [
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black,)
            ),
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.search, color: Colors.black)
            )
          ],
        ),*/
        body: Container(
          color: Colors.brown[50],
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 7, left: 7),
                color: Colors.black,
                child: Row(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text ("Bonjour\nGérer vos données",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )
                      ) ,
                    ),
                    Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            onPressed: () {
                              //_buttonTapped();
                              // Insertt DATA :
                              /*idcli++;
                              var usr = User(idcli: idcli, commune: 1, genre: 1, nom: "nom",
                                  prenom: "prenom", email: "email", numero: "numero", adresse: "adresse",
                                  fcmtoken: "fcmtoken", pwd: "pwd");
                              userBloc.addUser(usr);
                              userBloc.getCurrentUser();*/

                              /*Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder:
                                      (context) =>
                                          const EcranCreationCompte()
                                  ));*/

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder:
                                      (context) =>
                                  const EcranCreationCompte()
                                  ));

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange[400]
                            ),
                            child: GetBuilder<UserGetController>(
                              builder: (_) {
                                return Text (_userController.userData.isEmpty ? "CONNECTEZ-VOUS" : "MON COMPTE",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )
                                );
                              },
                            )

                          ),
                        )
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 7, left: 7),
                margin: const EdgeInsets.only(top: 10),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text("MON COMPTE",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(right: 7, left: 7),
                child: const Row(
                  children: [
                    Icon(
                      Icons.emoji_people,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Parrainage"),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      )
                    ),
                  ]
                ),
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(right: 7, left: 7),
                child: const Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Filleul"),
                      Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 24.0,
                            ),
                          )
                      ),
                    ]
                ),
              ),
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(right: 7, left: 7),
                child: const Row(
                    children: [
                      Icon(
                        Icons.card_giftcard,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Bonus"),
                      Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 24.0,
                            ),
                          )
                      ),
                    ]
                ),
              )
            ],
          ),
        )
    );
  }
}
