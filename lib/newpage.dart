import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:newecommerce/beanproduit.dart';
import 'package:newecommerce/getxcontroller/getusercontroller.dart';
import 'package:newecommerce/panier.dart';
import 'package:newecommerce/recherche.dart';
import 'package:newecommerce/skeleton.dart';
import 'package:shimmer/shimmer.dart';
import 'article.dart';
import 'carouselcustom.dart';
import 'constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as https;
import 'package:http/src/response.dart' as mreponse;

import 'detailcommande.dart';
import 'ecrancommande.dart';
import 'ecrancompte.dart';
import 'getxcontroller/getachatcontroller.dart';
import 'httpbeans/beanarticlebooked.dart';
import 'httpbeans/beanarticledetail.dart';
import 'package:badges/badges.dart' as badges;

import 'httpbeans/beanarticlediscounted.dart';
import 'main.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'models/user.dart';

class NewsPage extends StatefulWidget {
  final https.Client client;
  final User? mUser;
  const NewsPage({Key? key, required this.client, required this.mUser})
      : super(key: key);

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
  late User? mUser;
  final customColor = const Color(0xFFDEDDE3);
  // ADMIN
  bool adminAccount = false;
  int adminCompId = 0;

  // M e t h o d  :
  String formatPrice(int price) {
    MoneyFormatter fmf = MoneyFormatter(amount: price.toDouble());
    //
    return fmf.output.withoutFractionDigits;
  }

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
    mUser = widget.mUser;
    Future.delayed(const Duration(milliseconds: 1200), () {
      _achatController.refreshMainInterface();
    });

    //
    //checkData();

    //FirebaseMessaging.onMessage.listen(showFlutterNotification);
    if (defaultTargetPlatform == TargetPlatform.android) {
      initFire();
    }

    // Init FireBase :
    super.initState();
  }

  // Process :
  Future<User?> _checkData() async {
    return await _userController.getData();
    /*if(u1 != null){
      adminCompId = u1.idcli;
      adminAccount = true;
    }*/
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

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
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
    final url =
        Uri.parse('${dotenv.env['URL']}backendcommerce/getmobileAllProduits');
    mreponse.Response response = await client.get(url);
    if (response.statusCode == 200) {
      _isLoading = ++callNumber == 2 ? false : true;
      List<dynamic> body =
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
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

  // Get DISCOUNTED Products :
  Future<List<BeanArticleDiscounted>> discountedProduit() async {
    final url =
        Uri.parse('${dotenv.env['URL']}backendcommerce/getarticlesdiscounted');
    mreponse.Response response = await client.get(url);
    if (response.statusCode == 200) {
      _isLoading = ++callNumber == 2 ? false : true;
      List<dynamic> body =
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      List<BeanArticleDiscounted> posts = body
          .map(
            (dynamic item) => BeanArticleDiscounted.fromJson(item),
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
    final url = Uri.parse(
        '${dotenv.env['URL']}backendcommerce/getmobilerecentarticles');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      _isLoading = ++callNumber == 2 ? false : true;
      List<dynamic> body =
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
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

  Future<List<BeanArticleBooked>> getmobilearticlebookedbycompany(
      int idCompany) async {
    final url = Uri.parse(
        '${dotenv.env['URL']}backendcommerce/getmobilearticlebookedbycompany');
    var response = await client.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idprd": idCompany}));
    if (response.statusCode == 200) {
      List<dynamic> body =
          jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      List<BeanArticleBooked> posts = body
          .map(
            (dynamic item) => BeanArticleBooked.fromJson(item),
          )
          .toList();
      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ((mUser != null) && (mUser!.idcli > 0) && (mUser!.nom.isEmpty))
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                "Gouabo",
                textAlign: TextAlign.start,
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )),
              actions: [
                IconButton(
                    onPressed: () {
                      /*if(_achatController.taskData.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context)
                        {
                          return SearchEcran(client: client);
                        }
                        )
                    );
                  }*/
                    },
                    icon: const Icon(Icons.search, color: Colors.black))
              ],
            ),
            body: FutureBuilder(
                future:
                    Future.wait([getmobilearticlebookedbycompany(mUser!.idcli)]),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    List<BeanArticleBooked> liste = snapshot.data[0];
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: liste.length,
                        itemBuilder: (BuildContext contextList, int index) {
                          return GetBuilder<AchatGetController>(builder: (_) {
                            return GestureDetector(
                                onTap: () {
                                  // Display
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return DetailCommandeEcran.setAllNew(
                                        liste[index].dates,
                                        liste[index].heure,
                                        client,
                                        liste[index].iduser);
                                  }));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  padding:
                                      const EdgeInsets.only(left: 7, top: 5),
                                  alignment: Alignment.topLeft,
                                  width: MediaQuery.of(context).size.width,
                                  height: 90,
                                  color: Colors.brown[50],
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "${liste[index].nom} ${liste[index].prenom}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "${liste[index].dates}  -  ${liste[index].heure}",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Total article : ${liste[index].totaux}",
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ))
                                    ],
                                  ),
                                ));
                          });
                        });
                  } else {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: 7,
                      itemBuilder: (context, index) => const NewsCardSkelton(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: defaultPadding),
                    );
                  }
                }))
        : Scaffold(
            bottomNavigationBar: NavigationBar(
              indicatorShape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              )),
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
              title: const Text(
                "Gouabo",
                textAlign: TextAlign.start,
              ),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )),
              actions: [
                badges.Badge(
                    position: badges.BadgePosition.topEnd(top: 0, end: 3),
                    badgeAnimation: const badges.BadgeAnimation.slide(),
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
                    child: IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Paniercran(client: client);
                          }));
                        })),
                IconButton(
                    onPressed: () {
                      if (_achatController.taskData.isNotEmpty) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SearchEcran(client: client);
                        }));
                      }
                    },
                    icon: const Icon(Icons.search, color: Colors.black))
              ],
            ),
            body: <Widget>[
              SingleChildScrollView(
                child: FutureBuilder(
                  future: Future.wait([
                    produitLoading(),
                    recentProduitLoading(),
                    discountedProduit()
                  ]),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      // Get LIST of OBJECTs
                      List<Produit> pt = snapshot.data[0];
                      List<Beanarticledetail> bl = snapshot.data[1];
                      List<BeanArticleDiscounted> disA = snapshot.data[2];

                      return Column(
                        children: [
                          CarouselInterface(liste: pt, client: client),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: const Text(
                              "Produit",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 170,
                            child: ProduitInterface(liste: pt, client: client),
                          ),
                          disA.isEmpty
                              ? const SizedBox(
                                  height: 1,
                                )
                              : Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 0),
                                      child: Text(
                                        "Promotion",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red[400]),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 180,
                                      child: DiscountedProduitInterface(
                                          liste: disA, client: client),
                                    )
                                  ],
                                ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: const Text(
                              "Derniers produits ajoutés",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            height: 240, //810,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Display
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ArticleEcran.setId(
                                          bl[0].idart, 0, 0, client);
                                    }));
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        10,
                                    color: customColor,
                                    margin: const EdgeInsets.all(5),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(5),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 160,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${bl[0].lienweb}?alt=media",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(
                                                  color: Colors.amber,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )),
                                          Container(
                                            height: 18,
                                            //color: Colors.amber[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                bl[0].libelle.length > 23
                                                    ? "${bl[0].libelle.substring(0, 17)} ..."
                                                    : bl[0].libelle,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            height: 18,
                                            //color: Colors.red[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${formatPrice(bl[0].prix)} FCFA",
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Container(
                                            //color: Colors.blue[100],
                                            height: 18,
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${bl[0].articlerestant} élément(s) restant(s)",
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Display
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ArticleEcran.setId(
                                          bl[1].idart, 0, 0, client);
                                    }));
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        10,
                                    color: customColor,
                                    margin: const EdgeInsets.all(5),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(5),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 160,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${bl[1].lienweb}?alt=media",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(
                                                  color: Colors.amber,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )),
                                          Container(
                                            height: 18,
                                            //color: Colors.amber[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                bl[1].libelle.length > 23
                                                    ? "${bl[1].libelle.substring(0, 17)} ..."
                                                    : bl[1].libelle,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            height: 18,
                                            //color: Colors.red[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${formatPrice(bl[1].prix)} FCFA",
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Container(
                                            //color: Colors.blue[100],
                                            height: 18,
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${bl[1].articlerestant} élément(s) restant(s)",
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 240, //810,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Display
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ArticleEcran.setId(
                                          bl[2].idart, 0, 0, client);
                                    }));
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        10,
                                    color: customColor,
                                    margin: const EdgeInsets.all(5),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(5),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 160,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${bl[2].lienweb}?alt=media",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(
                                                  color: Colors.amber,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )),
                                          Container(
                                            height: 18,
                                            //color: Colors.amber[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                bl[2].libelle.length > 23
                                                    ? "${bl[2].libelle.substring(0, 17)} ..."
                                                    : bl[2].libelle,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            height: 18,
                                            //color: Colors.red[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${formatPrice(bl[2].prix)} FCFA",
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Container(
                                            //color: Colors.blue[100],
                                            height: 18,
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${bl[2].articlerestant} élément(s) restant(s)",
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Display
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ArticleEcran.setId(
                                          bl[3].idart, 0, 0, client);
                                    }));
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        10,
                                    color: customColor,
                                    margin: const EdgeInsets.all(5),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(5),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 160,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${bl[3].lienweb}?alt=media",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(
                                                  color: Colors.amber,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )),
                                          Container(
                                            height: 18,
                                            //color: Colors.amber[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                bl[3].libelle.length > 23
                                                    ? "${bl[3].libelle.substring(0, 17)} ..."
                                                    : bl[3].libelle,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            height: 18,
                                            //color: Colors.red[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${formatPrice(bl[3].prix)} FCFA",
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Container(
                                            //color: Colors.blue[100],
                                            height: 18,
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${bl[3].articlerestant} élément(s) restant(s)",
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 240, //810,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Display
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ArticleEcran.setId(
                                          bl[4].idart, 0, 0, client);
                                    }));
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        10,
                                    color: customColor,
                                    margin: const EdgeInsets.all(5),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(5),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 160,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${bl[4].lienweb}?alt=media",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(
                                                  color: Colors.amber,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )),
                                          Container(
                                            height: 18,
                                            //color: Colors.amber[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                bl[4].libelle.length > 23
                                                    ? "${bl[4].libelle.substring(0, 17)} ..."
                                                    : bl[4].libelle,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            height: 18,
                                            //color: Colors.red[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${formatPrice(bl[4].prix)} FCFA",
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Container(
                                            //color: Colors.blue[100],
                                            height: 18,
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${bl[4].articlerestant} élément(s) restant(s)",
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Display
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ArticleEcran.setId(
                                          bl[5].idart, 0, 0, client);
                                    }));
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        10,
                                    color: customColor,
                                    margin: const EdgeInsets.all(5),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(5),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 160,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${bl[5].lienweb}?alt=media",
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(
                                                  color: Colors.amber,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )),
                                          Container(
                                            height: 18,
                                            //color: Colors.amber[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                                bl[5].libelle.length > 23
                                                    ? "${bl[5].libelle.substring(0, 17)} ..."
                                                    : bl[5].libelle,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            height: 18,
                                            //color: Colors.red[100],
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "${formatPrice(bl[5].prix)} FCFA",
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                          Container(
                                            //color: Colors.blue[100],
                                            height: 18,
                                            margin:
                                                const EdgeInsets.only(top: 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "${bl[5].articlerestant} élément(s) restant(s)",
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )

                          /*SizedBox(
                      height: 770,//810,
                      //color: Colors.amber,
                      width: MediaQuery.of(context).size.width,
                      child: GridViewLastProduct(liste: bl, client: client),
                    )*/
                        ],
                      );
                    } else {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: 5,
                        itemBuilder: (context, index) =>
                            const NewsCardSkelton(),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: defaultPadding),
                      );
                    }
                  },
                ),
              ),
              _userController.userData.isNotEmpty
                  ? CommandeEcran.setcli(client)
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: Text(
                          "Veuillez créer votre compte",
                          style: TextStyle(fontSize: 17, color: Colors.black),
                        ),
                      ),
                    ),
              EcranCompte(client: client),
            ][currentPageIndex]);
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
      ));
}
