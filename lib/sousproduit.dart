import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:newecommerce/panier.dart';
import 'package:newecommerce/repositories/achat_repository.dart';
import 'package:newecommerce/repositories/article_repository.dart';
import 'package:newecommerce/repositories/user_repository.dart';

import 'article.dart';
import 'constants.dart';
import 'getxcontroller/getachatcontroller.dart';
import 'httpbeans/beancustomercreation.dart';
import 'httpbeans/beanresumearticledetail.dart';
import 'httpbeans/commune.dart';
import 'models/user.dart';
import 'newpage.dart';
import 'package:badges/badges.dart' as badges;
import 'package:http/http.dart' as https;


class Sousproduitecran extends StatefulWidget {

  // Attribute
  int mode = 0;
  int iddet = 0;
  String lib = "";
  https.Client? client;

  Sousproduitecran({Key? key}) : super(key: key);
  Sousproduitecran.setId(this.mode, this.iddet, this.lib);
  Sousproduitecran.setParams(this.mode, this.iddet, this.lib, this.client);

  @override
  State<Sousproduitecran> createState() => _NewSousproduit();
}

class _NewSousproduit extends State<Sousproduitecran> {

  // LINK :
  // https://api.flutter.dev/flutter/material/AlertDialog-class.html

  // A t t r i b u t e s  :
  final AchatGetController _achatController = Get.put(AchatGetController());

  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  late bool _isLoading;
  // Initial value :
  var dropdownvalue = "Koumassi";
  String defaultGenre = "M";
  final lesGenres = ["M", "F"];
  final _userRepository = UserRepository();
  final _achatRepository = AchatRepository();
  final _articleRepository = ArticleRepository();
  late BuildContext dialogContext;
  bool flagSendData = false;
  bool flagReady = false;
  late https.Client client;

  //
  late int mode;
  late int iddet;
  late  String lib;
  late List<BeanResumeArticleDetail> liste;



  // M e t h o d  :
  String formatPrice(int price){
    MoneyFormatter fmf = MoneyFormatter(
        amount: price.toDouble()
    );
    //
    return fmf.output.withoutFractionDigits;
  }


  @override
  void initState() {
    super.initState();

    mode = widget.mode;
    iddet = widget.iddet;
    lib = widget.lib;
    client = widget.client!;

    _achatRepository.findAllAchatByActif("0");
  }


  // Get VILLE :
  Future<List<BeanResumeArticleDetail>> processus() async {

    switch(mode){
      case 2:
        // SOUS-PRODUIT :
        //viewmodel.setLibSousProduit( extras.getString("lib"));
        //getarticlesBasedonLib();
        break;

      case 3:
      // DETAIL
        return await getarticlesbasedoniddet();
        break;

      case 4:
        // Display All PROMOTED ARTICLE
        //getpromotedarticles();
        break;

      case 5:
        // Display Porduct whose name is familiar to the one requested by user :
        return await lookforwhatuserrequested();
        break;

      default:
        // DETAIL
        //iddet = extras.getInt("id", 0);
        //getarticlesbasedoniddet(iddet);
        break;
    }

    return [];
  }

  Future<List<BeanResumeArticleDetail>> getarticlesbasedoniddet() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getarticlesbasedoniddet');

    var response = await client.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idprd": iddet
        }));

    if(response.statusCode == 200){
      _isLoading = true;
      List<dynamic> body = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      List<BeanResumeArticleDetail> posts = body
          .map(
            (dynamic item) => BeanResumeArticleDetail.fromJson(item),
      )
          .toList();
      return posts;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  //
  Future<List<BeanResumeArticleDetail>> lookforwhatuserrequested() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/lookforwhatuserrequested');

    var response = await client.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": 0,
          "lib": lib
        }));

    if(response.statusCode == 200){
      _isLoading = true;
      List<dynamic> body = jsonDecode(const Utf8Decoder().convert(response.bodyBytes));
      List<BeanResumeArticleDetail> posts = body
          .map(
            (dynamic item) => BeanResumeArticleDetail.fromJson(item),
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(lib, textAlign: TextAlign.start, ),
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
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Paniercran(client: client);
                            }
                            )
                        );
                      },
                      child: Text(
                        '${_achatController.taskData.length}',
                        style: const TextStyle(color: Colors.white),
                      )
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
                onPressed: (){},
                icon: const Icon(Icons.search, color: Colors.black)
            )
          ],
        ),
        body: !flagReady ? FutureBuilder(
            future: Future.wait([processus()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                liste =  snapshot.data[0];
                flagReady = true;
                return refreshInterface();
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
        ) : refreshInterface()
    );
  }

  // Try to externalize this :
  Widget refreshInterface(){
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: liste.length,
        itemBuilder: (BuildContext context, int index) {
          return GetBuilder<AchatGetController>(
              builder: (_) {
                return GestureDetector(
                  onTap: () {
                    // Display
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ArticleEcran.setId(liste[index].beanarticle.idart, 0, 0, client);
                        }
                        )
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    height: 215,
                    color: cardviewsousproduit,  // Colors.blueGrey
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 110,
                            height: 110,
                            //color: Colors.green,
                            margin: const EdgeInsets.only(left: 5, top: 5),
                            child: CachedNetworkImage(
                              /*width: 50,
                              height: 50,*/
                              fit: BoxFit.cover,
                              imageUrl: "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${liste[index].beanarticle.lienweb}?alt=media",
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
                                    height: 28,
                                    //color: Colors.amber[100],
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        liste[index].beanarticle.libelle.toLowerCase().length > 25 ?
                                        "${liste[index].beanarticle.libelle.substring(0,20)} ..." :
                                        liste[index].beanarticle.libelle,
                                        style: const TextStyle(
                                          fontSize: 18
                                        )
                                    ),
                                  ),
                                  Container(
                                    height: 28,
                                    //color: Colors.blueGrey[100],
                                    alignment: Alignment.topLeft,
                                    child: Text('${ formatPrice(liste[index].beanarticle.reduction > 0 ?
                                    (liste[index].beanarticle.prix-
                                        ((liste[index].beanarticle.prix * liste[index].beanarticle.reduction)/100)).toInt() :
                                    liste[index].beanarticle.prix)} FCFA',
                                        style: const TextStyle(
                                            fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        )
                                    ),
                                  ),
                                  Container(
                                    height: 26,
                                    //color: Colors.deepOrange[100],
                                    margin: const EdgeInsets.only(top: 10),
                                    child: liste[index].beanarticle.reduction > 0 ? Row(
                                      children: [
                                        Text('${formatPrice(liste[index].beanarticle.prix)} FCFA',
                                            style: const TextStyle(
                                                decoration: TextDecoration.lineThrough
                                            )
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text('-${liste[index].beanarticle.reduction}%',
                                            style: const TextStyle(
                                                color: promotioncolor,
                                              fontWeight: FontWeight.bold
                                            )
                                        )
                                      ],
                                    ) :
                                    Container(height: 10,),
                                  ),
                                  Container(
                                    height: 26,
                                    //color: Colors.red[100],
                                    alignment: Alignment.topLeft,
                                    child: Text('${liste[index].beanarticle.articlerestant -
                                        (_achatController.taskData.isNotEmpty ? _achatController.taskData.map((element) => element.idart == liste[index].beanarticle.idart ? 1 : 0)
                                            .reduce((value, element) => value + element) : 0)} article(s) restant(s)',
                                        style: const TextStyle(
                                            color: Colors.grey
                                        )
                                    ),
                                  ),
                                  Container(
                                    height: 26,
                                    //color: Colors.yellow[100],
                                    alignment: Alignment.topLeft,
                                    child: Row(
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
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      width: MediaQuery.of(context).size.width,
                                      //color: Colors.lightBlue[100],
                                      height: 70,
                                      child: Row(
                                        children: [
                                          Visibility(
                                            visible: liste[index].beanarticle.idart == _achatController.idart ? true : false,
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 7),
                                              child: const CircularProgressIndicator(),
                                            ),
                                          ),
                                          Visibility(
                                            visible: ((_achatController.taskData.indexWhere((element) => element.idart == liste[index].beanarticle.idart)
                                                > -1) && !(liste[index].beanarticle.idart==_achatController.idart)) ? true : false,
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 10),
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: butcardviewsousproduit,
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.all(16.0),
                                                  textStyle: const TextStyle(fontSize: 20),
                                                ),
                                                onPressed: () {
                                                  _achatController.addData(liste[index].beanarticle.idart, operation: 1);
                                                },
                                                child: const Text('-'),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: ((_achatController.taskData.indexWhere((element) => element.idart == liste[index].beanarticle.idart)
                                                > -1) && !(liste[index].beanarticle.idart==_achatController.idart)) ? true : false,
                                            child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                                child: Text('${ _achatController.taskData.isNotEmpty ? _achatController.taskData.map((element) => element.idart ==
                                                    liste[index].beanarticle.idart ? 1 : 0).reduce((value, element) => value + element) : 0}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20
                                                  ),
                                                )
                                            ),
                                          ),
                                          Visibility(
                                              visible: (((_achatController.taskData.indexWhere((element) => element.idart == liste[index].beanarticle.idart)
                                                  > -1) && !(liste[index].beanarticle.idart==_achatController.idart)) &&
                                                  ((liste[index].beanarticle.articlerestant - _achatController.taskData.map((element) => element.idart == liste[index].beanarticle.idart ? 1 : 0).reduce((value, element) => value + element)) > 0)) ? true : false,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 10),
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: butcardviewsousproduit,
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.all(16.0),
                                                    textStyle: const TextStyle(fontSize: 20),
                                                  ),
                                                  onPressed: () {
                                                    /*Fluttertoast.showToast(
                                                        msg: "valeur : ${(liste[index].beanarticle.articlerestant - _achatController.taskData.map((element) => element.idart == liste[index].beanarticle.idart ? 1 : 0).reduce((value, element) => value + element))}",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0
                                                    );*/
                                                    _achatController.addData(liste[index].beanarticle.idart);
                                                  },
                                                  child: const Text('+'),
                                                ),
                                              )
                                          ),
                                          Visibility(
                                            visible: _achatController.taskData.indexWhere((element) => element.idart == liste[index].beanarticle.idart)
                                                > -1 ? false : true,
                                            child: Expanded(
                                                child: Align(
                                                    alignment: Alignment.topRight,
                                                    child: TextButton(
                                                      style: TextButton.styleFrom(
                                                        backgroundColor: butcardviewsousproduit,
                                                        foregroundColor: Colors.white,
                                                        padding: const EdgeInsets.all(16.0),
                                                        textStyle: const TextStyle(fontSize: 20),
                                                      ),
                                                      onPressed: () {
                                                        if(liste[index].beanarticle.articlerestant > 0){
                                                          _achatController.addData(liste[index].beanarticle.idart);
                                                        }
                                                      },
                                                      child: Text(liste[index].beanarticle.articlerestant > 0 ? 'Acheter' : 'Epuisé'),
                                                    )
                                                )
                                            ),
                                          )
                                        ],
                                      )
                                    /*
                                      ,*/
                                  )
                                ],
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                );
              });
        }
    );
  }
}