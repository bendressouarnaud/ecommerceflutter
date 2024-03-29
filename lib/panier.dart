

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:newecommerce/httpbeans/beanactif.dart';
import 'package:newecommerce/models/achat.dart';
import 'package:newecommerce/repositories/achat_repository.dart';
import 'package:newecommerce/repositories/user_repository.dart';

import 'constants.dart';
import 'enums/enum_modepaiement.dart';
import 'getxcontroller/getachatcontroller.dart';
import 'httpbeans/beanarticlestatusresponse.dart';
import 'httpbeans/beanreponsepanier.dart';
import 'httpbeans/responsebooking.dart';
import 'models/user.dart';
import 'newpage.dart';
import 'package:http/http.dart' as https;



class Paniercran extends StatefulWidget {

  // Attribute
  final https.Client client;


  // METHODS :
  const Paniercran({Key? key, required this.client}) : super(key: key);

  @override
  State<Paniercran> createState() => _NewPanier();
}


class _NewPanier extends State<Paniercran> {

  // A T T R I B U T E S /
  //final _achatRepository = AchatRepository();
  final AchatGetController _achatController = Get.put(AchatGetController());
  final AchatRepository _achatRepository = AchatRepository();
  final UserRepository _userRepository = UserRepository();
  Modepaiement? _modepaiement = Modepaiement.livraison;
  int choixpaiement = 0;
  late BuildContext dialogContextPaiement;
  late BuildContext dialogContextWaiting;
  bool flagSendData = false;
  bool flagDeleteData = false;
  User? usr;
  late https.Client client;
  late BuildContext dialogContext;
  int total = 0;
  int occurence = 0;
  late List<BeanActif> listeAchat;



  // M e t h o d  :
  // Format AMOUNT
  String formatPrice(int price){
    MoneyFormatter fmf = MoneyFormatter(
        amount: price.toDouble()
    );
    //
    return fmf.output.withoutFractionDigits;
  }


  // Delete ACHAT
  void deleteAchat(int idart) async{
    await _achatController.deleteAchatByIdart(idart).then((value) {
      if(value > 0){
        // Notify :
        flagDeleteData = false;

        // Refresh :
        refreshArticle();
      }
    });
  }


  // 10 - 4
  void recursifPrix(int total,int seuil, int occurence){
    if(total >= seuil) {
      total = total - seuil;
      this.total = total;
      if (total >= 0) {
        occurence++;
        this.occurence = occurence;
      }
      else {
        recursifPrix(total, seuil, occurence);
      }
    }
  }


  // Process the GLOBAL AMOUNT to PAY
  int processAmount(List<Beanreponsepanier> liste){
    int prixTotalArticle = 0;
    if(_achatController.taskData.isNotEmpty) {
      for (Beanreponsepanier br in liste) {
        // Get the TOTAL of specific ARTICLE booked :
        var nbreArt = _achatController.taskData.map((element) =>
        element.idart ==
            br.idart ? 1 : 0).reduce((value, element) => value + element);
        // Now, apply logic :
        if ((br.reduction > 0) && (br.modepourcentage == 1)) {
          // Pourcentage :
          prixTotalArticle +=
          (br.prix - ((br.prix * br.reduction) / 100)) as int;
        }
        else if ((br.reduction > 0) && (br.modepourcentage == 0)) {
          // Nombre article :
          total = 0;
          occurence = 0;
          recursifPrix(nbreArt, br.reduction, 0);
          prixTotalArticle += (occurence * br.prixpromo) + (total * br.prix);
        }
        else {
          prixTotalArticle += nbreArt * br.prix;
        }
      }
    }
    return prixTotalArticle;
  }


  // Display DIALOG Box :
  void displayAlert(int idart) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return AlertDialog(
            title: const Text('Information'),
            content: const Text("Confirmer la suppression de cet article ?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('NON'),
              ),
              TextButton(
                onPressed: () {

                  // Send DATA :
                  flagDeleteData = true;
                  deleteAchat(idart);

                  // Run TIMER :
                  Timer.periodic(
                    const Duration(seconds: 1),
                        (timer) {
                      // Update user about remaining time
                      if(!flagDeleteData){
                        Navigator.pop(dialogContext);
                        timer.cancel();

                        // if PANIER is empty, then CLOSE the INTERFACE :
                        if(_achatController.taskData.isEmpty){
                          // Kill ACTIVITY :
                          if(Navigator.canPop(context)){
                            Navigator.pop(context);
                          }
                        }
                        else{
                          setState(() {
                          });
                        }
                      }
                    },
                  );

                },
                child: const Text('OUI'),
              ),
            ]
          );
        }
    );
  }

  // Refresh :
  void refreshArticle(){
    _achatRepository.findAllLive().then((value) => {
      listeAchat = value
    });
  }


  @override
  void initState(){

    client = widget.client;

    // Pick User Id :
    _userRepository.getConnectedUser().then((value) {
      if (value != null) {
        usr = value;
      }
    });

    // Refresh :
    refreshArticle();

    /*if(usr!=null) {
      Fluttertoast.showToast(
          msg: "User : ${usr!.idcli}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }*/

    super.initState();
  }

  // Get Products :
  Future<List<Beanreponsepanier>> getArticlesStatus() async {

    Set<int> setIdart = _achatController.taskData.map((element) => element.idart).toSet();
    List<int> finalListe = [];
    setIdart.forEach((element) => finalListe.add(element));

    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getarticledetailspanier');

    var response = await client.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "articleid": finalListe
        }));

    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      List<Beanreponsepanier> posts = body
          .map(
            (dynamic item) => Beanreponsepanier.fromJson(item),
      )
          .toList();
      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  // Call to Process PAYMENT :
  sendbooking() async {
    // _achatController.listePanier
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/sendbooking');
    var response = await client.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "liste": listeAchat,
          "idcli": usr!.idcli,
          "choixpaiement": choixpaiement
        }));

    // Checks :
    if(response.statusCode == 200){
      //List<dynamic> body = jsonDecode(response.body);
      ResponseBooking rg = ResponseBooking.fromJson(json.decode(response.body));
      if(rg != null){
        if(rg.etat == 1){
          int ligne = _achatController.closeLiveAchat();
          flagSendData = false;
        }
        else{
          Fluttertoast.showToast(
              msg: "Erreur apparue !",
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
      //flagSendData = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Panier", textAlign: TextAlign.start, ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
          ),
        ),
        body: FutureBuilder(
            future: Future.wait([getArticlesStatus()]),
            builder: (BuildContext contextMain, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                List<Beanreponsepanier> liste =  snapshot.data[0];
                return GetBuilder<AchatGetController>(
                    builder: (_){
                      return Stack(
                        children: [
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 50,
                              child: Container(
                                color: bottombararticle,
                                width: MediaQuery.of(contextMain).size.width,
                                padding: const EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      if(usr != null){
                                        showDialog(
                                          //barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext ctP) {
                                              dialogContextPaiement = ctP;
                                              return AlertDialog(
                                                  title: const Text('Mode de paiement',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  content: Container(
                                                    height: 130,
                                                    child: Column(
                                                      children: [
                                                        GetBuilder<AchatGetController>(
                                                            builder: (_) {
                                                              return ListTile(
                                                                title: const Text('À la livraison'),
                                                                leading: Radio(
                                                                  value: 0,
                                                                  groupValue: choixpaiement,
                                                                  onChanged: (int? v) {
                                                                    choixpaiement = v!;
                                                                    _achatController.setFlag(choixpaiement);
                                                                  },
                                                                ),
                                                              );
                                                            }
                                                        ),
                                                        GetBuilder<AchatGetController>(
                                                            builder: (_) {
                                                              return ListTile(
                                                                enabled: false,
                                                                title: const Text('Mobile Money'),
                                                                leading: Radio(
                                                                  value: 1,
                                                                  groupValue: choixpaiement,
                                                                  onChanged: (int? v) {
                                                                    choixpaiement = v!;
                                                                    _achatController.setFlag(choixpaiement);
                                                                  },
                                                                ),
                                                              );
                                                            }
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(dialogContextPaiement,'Cancel'),//Navigator.pop(context, 'Cancel'),
                                                      child: const Text('Annuler'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {

                                                        // Close the previous :
                                                        Navigator.pop(dialogContextPaiement, 'OK');

                                                        showDialog(
                                                          //barrierDismissible: false,
                                                            context: contextMain,
                                                            builder: (BuildContext ctI) {
                                                              dialogContextWaiting = ctI;
                                                              return const AlertDialog(
                                                                  title: Text('Information'),
                                                                  content: Text("Veuillez patienter ...")
                                                              );
                                                            }
                                                        );

                                                        // Send DATA :
                                                        flagSendData = true;
                                                        sendbooking();

                                                        var cpt = 0;

                                                        // Run TIMER :
                                                        Timer.periodic(
                                                          const Duration(seconds: 1),
                                                              (timer) {
                                                            // Update user about remaining time
                                                            if((++cpt > 5) || !flagSendData){
                                                              Navigator.pop(dialogContextWaiting);
                                                              timer.cancel();
                                                              if(cpt > 5){
                                                                Fluttertoast.showToast(
                                                                    msg: "Impossible de traiter l'opération !",
                                                                    toastLength: Toast.LENGTH_SHORT,
                                                                    gravity: ToastGravity.CENTER,
                                                                    timeInSecForIosWeb: 1,
                                                                    backgroundColor: Colors.red,
                                                                    textColor: Colors.white,
                                                                    fontSize: 16.0
                                                                );
                                                                /*var snackBar = const SnackBar(content: Text('Impossible de traiter l\'opération !'));
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                                                              }

                                                              // Kill ACTIVITY :
                                                              if(Navigator.canPop(contextMain)){
                                                                Navigator.pop(contextMain);
                                                              }
                                                            }
                                                          },
                                                        );

                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ]
                                              );
                                            }
                                        );
                                      }
                                      else{
                                        Fluttertoast.showToast(
                                            msg: "Veuillez créer votre compte !",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 3,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      }
                                    },
                                    child: const Text('PAYER',
                                      style: TextStyle(
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                      ),
                                    ),
                                  ),
                                ),
                              )
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              bottom: 50,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                physics: const ScrollPhysics(),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child: const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text("RÉSUMÉ DU PANIER",
                                          style: TextStyle(
                                              color: Colors.grey
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          const Text("Sous-total",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Expanded(
                                              child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text('${formatPrice( processAmount(liste) )} FCFA',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  )
                                              )
                                          )
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: liste.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              // Display
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(2),
                                              width: MediaQuery.of(context).size.width,
                                              height: 170,
                                              color: cardviewsousproduit,  // Colors.blueGrey
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Container(
                                                          width: 110,
                                                          height: 110,
                                                          //color: Colors.green,
                                                          margin: EdgeInsets.only(left: 5, top: 1),
                                                          child: CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl: "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${liste[index].lienweb}?alt=media",
                                                            imageBuilder: (context, imageProvider) => Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(8.0),
                                                                image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.fill,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child: Container(
                                                            padding: const EdgeInsets.only(left: 10),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  //color: Colors.blueGrey[100],
                                                                  alignment: Alignment.topLeft,
                                                                  height: 25,
                                                                  child: Text(
                                                                      liste[index].libelle.toLowerCase().length > 25 ?
                                                                      "${liste[index].libelle.substring(0,20)} ..." :
                                                                      liste[index].libelle,
                                                                      style: const TextStyle(
                                                                        fontSize: 18,

                                                                      )
                                                                  ),
                                                                ),
                                                                Container(
                                                                  //color: Colors.blue[100],
                                                                  alignment: Alignment.topLeft,
                                                                  height: 25,
                                                                  child: Text('${ formatPrice(
                                                                      ((liste[index].reduction > 0) && (liste[index].modepourcentage == 1)) ?
                                                                  (liste[index].prix-
                                                                      ((liste[index].prix * liste[index].reduction)/100)).toInt() :
                                                                  liste[index].prix)} FCFA',
                                                                      style: const TextStyle(
                                                                          fontSize: 18,
                                                                          fontWeight: FontWeight.bold
                                                                      )
                                                                  ),
                                                                ),
                                                                Container(
                                                                  //color: Colors.red[100],
                                                                  height: 25,
                                                                  margin: const EdgeInsets.only(top: 10),
                                                                  child: ((liste[index].reduction > 0) && (liste[index].modepourcentage == 1)) ? Row(
                                                                    children: [
                                                                      Text('${formatPrice(liste[index].prix)} FCFA',
                                                                          style: const TextStyle(
                                                                              decoration: TextDecoration.lineThrough
                                                                          )
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      Text('-${liste[index].reduction}%',
                                                                          style: const TextStyle(
                                                                              color: promotioncolor,
                                                                              fontWeight: FontWeight.bold
                                                                          )
                                                                      )
                                                                    ],
                                                                  ) :
                                                                  ((liste[index].reduction > 0) && (liste[index].modepourcentage == 0)) ?
                                                                  Text('${liste[index].reduction} article(s) à partir de ${formatPrice(liste[index].prixpromo)} F',
                                                                      style: const TextStyle(
                                                                          color: promotioncolor,
                                                                          fontWeight: FontWeight.bold
                                                                      )
                                                                  ) :
                                                                  Container(height: 25,),
                                                                ),
                                                                Container(
                                                                  //color: Colors.amber[100],
                                                                  alignment: Alignment.topLeft,
                                                                  height: 25,
                                                                  child: Text('${liste[index].restant} article(s) restant(s)',
                                                                      style: const TextStyle(
                                                                          color: Colors.grey
                                                                      )
                                                                  ),
                                                                ),
                                                                Container(
                                                                  //color: Colors.deepOrange[100],
                                                                  alignment: Alignment.topLeft,
                                                                  height: 25,
                                                                  child: const Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons.star_outline
                                                                      ),
                                                                      Icon(
                                                                          Icons.star_outline
                                                                      ),
                                                                      Icon(
                                                                          Icons.star_outline
                                                                      ),
                                                                      Icon(
                                                                          Icons.star_outline
                                                                      ),
                                                                      Icon(
                                                                          Icons.star_outline
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 30,
                                                    //color: Colors.black12,
                                                    padding: const EdgeInsets.only(left: 5, right: 5),
                                                    child: Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: (){
                                                            displayAlert(liste[index].idart);
                                                          },
                                                          child: const Icon(
                                                            Icons.delete_outline,
                                                            color: Colors.deepOrange,
                                                            size: 30,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        GestureDetector(
                                                          onTap: (){
                                                            // Delete ALL the ARTICLE command :
                                                            displayAlert(liste[index].idart);
                                                          },
                                                          child: const Text('SUPPR.',
                                                            style: TextStyle(
                                                              color: Colors.deepOrange,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Align(
                                                              alignment: Alignment.topRight,
                                                              child: Text('${ _achatController.taskData.isNotEmpty ? _achatController.taskData.map((element) => element.idart ==
                                                                  liste[index].idart ? 1 : 0).reduce((value, element) => value + element) : 0}',
                                                                style: const TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    )
                                  ],
                                ),
                              )
                          )
                        ],
                      );
                    }
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