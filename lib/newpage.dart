import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:newecommerce/beanproduit.dart';
import 'package:newecommerce/getxcontroller/getusercontroller.dart';
import 'package:newecommerce/panier.dart';
import 'package:newecommerce/recherche.dart';
import 'package:newecommerce/skeleton.dart';
import 'package:shimmer/shimmer.dart';
import 'carouselcustom.dart';
import 'constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as https;
import 'package:http/src/response.dart' as mreponse;

import 'ecrancommande.dart';
import 'ecrancompte.dart';
import 'getxcontroller/getachatcontroller.dart';
import 'httpbeans/beanarticledetail.dart';
import 'package:badges/badges.dart' as badges;

import 'main.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;



class NewsPage extends StatefulWidget {
  final https.Client client;
  const NewsPage({Key? key, required this.client}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // A t t r i b u t e s  :
  late Future<List<Produit>> futureProduit;
  late Future<List<Beanarticledetail>> futureBeanarticle;
  late bool _isLoading;
  int callNumber = 0;
  int currentPageIndex = 0;
  final AchatGetController _achatController = Get.put(AchatGetController());
  final UserGetController _userController = Get.put(UserGetController());
  //
  late https.Client client;


  // M e t h o d  :
  /*void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  }*/

  @override
  void initState() {
    _isLoading = true;
    client = widget.client;
    Future.delayed(const Duration(milliseconds: 1200), () {
      _achatController.refreshMainInterface();
    });

    //FirebaseMessaging.onMessage.listen(showFlutterNotification);
    if(defaultTargetPlatform == TargetPlatform.android) {
      initFire();
    }

    // Init FireBase :
    super.initState();
  }

  void initFire() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    //print('User granted permission: ${settings.authorizationStatus}');


    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {

        //
        //print('Taille DONNEES: ${message.data}');
        showFlutterNotification(message, "Notification Commande", "");

        /*if(message.data.isNotEmpty){
          Fluttertoast.showToast(
              msg: "Donnée : ${ message.data['viande'] }",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }*/

      });
    }

  }

  // Get Products :
  Future<List<Produit>> produitLoading() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getmobileAllProduits');
    mreponse.Response response = await client.get(url);
    if(response.statusCode == 200){
      _isLoading = ++callNumber == 2 ? false : true;
      List<dynamic> body = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      List<Produit> posts = body
          .map(
            (dynamic item) => Produit.fromJson(item),
          )
          .toList();
      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  // Get Recent Added Products :
  Future<List<Beanarticledetail>> recentProduitLoading() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getmobilerecentarticles');
    final response = await client.get(url);
    if(response.statusCode == 200){
      _isLoading = ++callNumber == 2 ? false : true;
      List<dynamic> body = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      List<Beanarticledetail> posts = body
          .map(
            (dynamic item) => Beanarticledetail.fromJson(item),
      )
          .toList();
      return posts;
      //return Beanarticledetail.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          )
        ),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber[300],
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_basket),
            label: 'Commande',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.school),
            icon: Icon(Icons.account_box),
            label: 'Compte',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Gouabo", textAlign: TextAlign.start, ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )
        ),
        actions: [
          badges.Badge(
              position: badges.BadgePosition.topEnd(top: 0, end: 3),
              badgeAnimation: const badges.BadgeAnimation.slide(
              ),
              showBadge: true,
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Colors.red,
              ),
              badgeContent: GetBuilder<AchatGetController>(
                builder: (_) {
                  return Text(
                    '${_achatController.taskData.length}',
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
              child: IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Paniercran(client: client);
                    }
                    )
                );
              })
          ),
          IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return SearchEcran();
                    }
                    )
                );
              },
              icon: const Icon(Icons.search, color: Colors.black)
          )
        ],
      ),
      body: <Widget>[
        SingleChildScrollView(
          child: FutureBuilder(
            future: Future.wait([produitLoading(), recentProduitLoading()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                List<Produit> pt =  snapshot.data[0];
                List<Beanarticledetail> bl =  snapshot.data[1];
                return Column(
                  children: [
                    CarouselInterface(liste: pt, client: client),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: const Text("Produit",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 170,
                      child: ProduitInterface(liste: pt, client: client),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: const Text("Derniers produits ajoutés",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 770,//810,
                      //color: Colors.amber,
                      width: MediaQuery.of(context).size.width,
                      child: GridViewLastProduct(liste: bl, client: client),
                    )
                  ],
                );
              } else {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) => const NewsCardSkelton(),
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: defaultPadding),
                );
              }
            },
          ),
        ),
        _userController.userData.isNotEmpty ? CommandeEcran() :
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: Text("Veuillez créer votre compte",
              style: TextStyle(
                fontSize: 17,
                color: Colors.black
              ),
            ),
          ),
        ),
        EcranCompte(client: client),
      ][currentPageIndex]
    );
  }
}

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.grey[500]!,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: const Skeleton(height: 120, width: 120),
          ),
          const SizedBox(width: defaultPadding),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: 80),
                SizedBox(height: defaultPadding / 2),
                Skeleton(),
                SizedBox(height: defaultPadding / 2),
                Skeleton(),
                SizedBox(height: defaultPadding / 2),
                Row(
                  children: [
                    Expanded(
                      child: Skeleton(),
                    ),
                    SizedBox(width: defaultPadding),
                    Expanded(
                      child: Skeleton(),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      )
      );
}
