import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:newecommerce/panier.dart';
import 'package:newecommerce/recherche.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';
import 'getxcontroller/getachatcontroller.dart';
import 'httpbeans/beanarticledatahistory.dart';
import 'newpage.dart';

import 'package:badges/badges.dart' as badges;
import 'package:http/http.dart' as https;


class ArticleEcran extends StatefulWidget {

  // Attribute
  int idart = 0;
  int fromadapter = 0;
  int qte = 0;
  https.Client? client;

  ArticleEcran({Key? key}) : super(key: key);
  ArticleEcran.setId(this.idart, this.fromadapter, this.qte, this.client);

  @override
  State<ArticleEcran> createState() => _NewArticle();
}

class _NewArticle extends State<ArticleEcran> {

  // A T T R I B U T E S
  late int idart;
  final AchatGetController _achatController = Get.put(AchatGetController());
  late https.Client client;



  // M E T H O D S
  @override
  void initState() {
    super.initState();

    idart = widget.idart;
    client = widget.client!;
  }

  Future<Beanarticledatahistory> getmobilearticleinformationbyidart() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getmobilearticleinformationbyidart');

    var response = await client.post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idart": idart,
          "iduser": 0,
        }));

    if(response.statusCode == 200){
      return Beanarticledatahistory.fromJson(jsonDecode(const Utf8Decoder().convert(response.bodyBytes)));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  // Format AMOUNT
  String formatPrice(int price){
    MoneyFormatter fmf = MoneyFormatter(
        amount: price.toDouble()
    );
    //
    return fmf.output.withoutFractionDigits;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  if(_achatController.taskData.isNotEmpty){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Paniercran(client: client);
                        }
                        )
                    );
                  }
                })
            ),
            IconButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SearchEcran(client: client!);
                      }
                      )
                  );
                },
                icon: const Icon(Icons.search, color: Colors.black)
            )
          ],
        ),
        body: FutureBuilder(
            future: Future.wait([getmobilearticleinformationbyidart()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                Beanarticledatahistory article =  snapshot.data[0];
                return GetBuilder<AchatGetController>(
                  builder: (_) {
                    return Stack(
                      children: [
                        Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 70,
                            child: Container(
                              color: bottombararticle,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 0,
                                      left: 0,
                                      bottom: 0,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 7),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                                onTap: () async {
                                                  Uri phoneno = Uri.parse('tel:'+article.contact);
                                                  if (await launchUrl(phoneno)) {
                                                  //dialer opened
                                                  }else{
                                                  //dailer is not opened
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.call,
                                                  color: bottombararticlecolor,
                                                  size: 40,
                                                )
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Visibility(
                                              visible: idart == _achatController.idart ? true : false,
                                              child: const CircularProgressIndicator(
                                                color: Colors.black,
                                              )
                                            )
                                          ],
                                        ),
                                      )
                                  ),
                                  Positioned(
                                      right: 5,
                                      top: 1,
                                      bottom: 1,
                                      width: 120,
                                      child: Visibility(
                                        visible: _achatController.taskData.indexWhere((element) => element.idart == idart)
                                            > -1 ? false : true,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: butcardviewsousproduit,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.all(16.0),
                                              textStyle: const TextStyle(fontSize: 20),
                                            ),
                                            onPressed: () {
                                              if(article.nombrearticle > 0) {
                                                _achatController.addData(idart);
                                              }
                                            },
                                            child: Text(article.nombrearticle > 0 ? 'Acheter' : 'Epuisé'),
                                          ),
                                        ),
                                      )
                                  ),
                                  Positioned(
                                      right: ((_achatController.taskData.indexWhere((element) => element.idart == idart)
                                          > -1) &&
                                          (article.nombrearticle - _achatController.taskData.map((element) => element.idart == idart ? 1 : 0).reduce((value, element) => value + element) > 0)) ? 5 : 130,
                                      top: 1,
                                      bottom: 1,
                                      width: 50,
                                      child: Visibility(
                                        visible: ((_achatController.taskData.indexWhere((element) => element.idart == idart)
                                            > -1) &&
                                            ((article.nombrearticle - (_achatController.taskData.isNotEmpty ? _achatController.taskData.map((element) => element.idart == idart ? 1 : 0).reduce((value, element) => value + element) : 0)) > 0)) ? true : false,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: butcardviewsousproduit,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.all(16.0),
                                              textStyle: const TextStyle(fontSize: 20),
                                            ),
                                            onPressed: () {
                                              _achatController.addData(idart);
                                            },
                                            child: const Text('+'),
                                          ),
                                        ),
                                      )
                                  ),
                                  Positioned(
                                      right: _achatController.taskData.indexWhere((element) => element.idart == idart) > -1 ? 60 : 185,
                                      top: 0,
                                      bottom: 0,
                                      width: 20,
                                      child: Visibility(
                                        visible: _achatController.taskData.indexWhere((element) => element.idart == idart) > -1 ? true : false,
                                        child: Container(
                                          //color: Colors.red,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text('${ _achatController.taskData.isNotEmpty ?
                                              _achatController.taskData.map((element) => element.idart == idart ? 1 : 0)
                                                .reduce((value, element) => value + element) : 0}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  Positioned(
                                      right: _achatController.taskData.indexWhere((element) => element.idart == idart) > -1 ? 85 : 210,
                                      top: 1,
                                      bottom: 1,
                                      width: 50,
                                      child: Visibility(
                                        visible: _achatController.taskData.indexWhere((element) => element.idart == idart) > -1 ? true : false,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: butcardviewsousproduit,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.all(16.0),
                                              textStyle: const TextStyle(fontSize: 20),
                                            ),
                                            onPressed: () {
                                              _achatController.addData(idart, operation: 1);
                                            },
                                            child: const Text('-'),
                                          ),
                                        ),
                                      )
                                  )
                                ],
                              ),
                            )
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            bottom: 70,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width, // 250
                                      height: ((article.trackVetement == 4) || (article.taille == 1)) ? 440 : 250,
                                      child: CarouselSlider.builder(
                                        itemCount: article.images.length,
                                        itemBuilder: (BuildContext context, int itemIndex, int t) => Container(
                                          margin: const EdgeInsets.all(6.0),
                                          child: CachedNetworkImage(
                                            imageUrl: "https://firebasestorage.googleapis.com/v0/b/gestionpanneaux.appspot.com/o/${article.images[itemIndex].lienweb}?alt=media",
                                            imageBuilder: (context, imageProvider) => Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.0),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) => const CircularProgressIndicator(
                                              color: Colors.amber,
                                            ),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                        ),
                                        options: CarouselOptions(
                                          height: ((article.trackVetement == 4) || (article.taille == 1)) ? 435.0 : 200.0,
                                          enlargeCenterPage: true,
                                          autoPlay: true,
                                          aspectRatio: 16 / 9,
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enableInfiniteScroll: true,
                                          autoPlayAnimationDuration: const Duration(milliseconds: 1200),
                                          viewportFraction: 0.8,
                                        ),
                                      )
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10,right: 10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(article.article,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10,right: 10, top: 10),
                                    child: Row(
                                      children: [
                                        const Text("Entreprise : ",
                                          style: TextStyle(
                                              fontSize: 15
                                          ),
                                        ),
                                        Text(article.entreprise.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: entreprisename
                                          ),
                                        )
                                      ],
                                    ),
                                  ),



                                  Container(
                                    margin: const EdgeInsets.only(left: 10,right: 10, top: 15),
                                    width: MediaQuery.of(context).size.width,
                                    child: Text( '${ formatPrice(article.reduction > 0 ?
                                    (article.modepourcentage == 1 ? (article.prix-
                                        ((article.prix * article.reduction)/100)).toInt() :
                                      article.prix) : article.prix)} FCFA',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),
                                    ),
                                  ),
                                  Container(
                                    //color: Colors.red[100],
                                    height: 25,
                                    alignment: Alignment.topLeft,
                                    margin: const EdgeInsets.only(top: 5, left: 10,right: 10),
                                    child: ((article.reduction > 0) && (article.modepourcentage == 1)) ? Row(
                                      children: [
                                        Text('${formatPrice(article.prix)} FCFA',
                                            style: const TextStyle(
                                                decoration: TextDecoration.lineThrough
                                            )
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text('-${article.reduction}%',
                                            style: const TextStyle(
                                                color: promotioncolor,
                                                fontWeight: FontWeight.bold
                                            )
                                        )
                                      ],
                                    ) :
                                    ((article.reduction > 0) && (article.modepourcentage == 0)) ?
                                    Text('${article.reduction} article(s) à partir de ${formatPrice(article.prixpromo)} FCFA',
                                        style: const TextStyle(
                                            color: promotioncolor,
                                            fontWeight: FontWeight.bold
                                        )
                                    ) :
                                    Container(height: 25,),
                                  ),



                                  Container(
                                    margin: const EdgeInsets.only(left: 10,right: 10, top: 10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        Icon(
                                          (article.nombrearticle - (_achatController.taskData.isNotEmpty ? _achatController.taskData.map((element) => element.idart == idart ? 1 : 0).reduce((value, element) => value + element) : 0)) > 0 ? Icons.check_circle_outline : Icons.error,
                                          color: (article.nombrearticle - (_achatController.taskData.isNotEmpty ? _achatController.taskData.map((element) => element.idart == idart ? 1 : 0).reduce((value, element) => value + element) : 0)) > 0 ? Colors.green : Colors.red ,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text('${article.nombrearticle -
                                            (_achatController.taskData.isNotEmpty ? _achatController.taskData.map((element) => element.idart == idart ? 1 : 0)
                                                .reduce((value, element) => value + element) : 0)} article(s) restant(s)',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: (article.nombrearticle - (_achatController.taskData.isNotEmpty ? _achatController.taskData.map((element) => element.idart == idart ? 1 : 0).reduce((value, element) => value + element) : 0)) > 0 ? Colors.green : Colors.red ,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10,right: 10, top: 5),
                                    width: MediaQuery.of(context).size.width,
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
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    color: Colors.grey,
                                    child: const Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text('INFORMATIONS DE RETOUR',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      height: 70,
                                      child: Row(
                                          children: [
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                    child: const Icon(
                                                      Icons.timer_outlined,
                                                      color: Colors.black,
                                                      size: 30,
                                                    )
                                                )
                                            ),
                                            Expanded(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        child: const Text("Modalités de retour",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width,
                                                        child: const Text("---",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                            )
                                          ]
                                      )
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    color: Colors.grey,
                                    child: const Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text('DETAIL DU PRODUIT',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.topLeft,
                                          child: Text("Description",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                          height: 5,
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(article.descriptionproduit,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    color: Colors.grey,
                                    child: const Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text('EVALUATION DU PRODUIT',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                                      width: MediaQuery.of(context).size.width,
                                      child: const Text('Note',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        ),
                                      )
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.red
                                              )
                                          ),
                                          child: Text('--/--'),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 7),
                                          child: Text('(0 Avis client)'),
                                        ),
                                        const Expanded(
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Icon(
                                                Icons.arrow_forward_ios
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: const Divider(
                                      color: Colors.black,
                                      height: 5,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Icon(
                                          Icons.message
                                      ),
                                    ),
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