import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:money_formatter/money_formatter.dart';

import 'constants.dart';
import 'httpbeans/beanarticledatahistory.dart';
import 'newpage.dart';

class ArticleEcran extends StatefulWidget {

  // Attribute
  int idart = 0;
  int fromadapter = 0;
  int qte = 0;

  ArticleEcran({Key? key}) : super(key: key);
  ArticleEcran.setId(this.idart, this.fromadapter, this.qte);

  @override
  State<ArticleEcran> createState() => _NewArticle();
}

class _NewArticle extends State<ArticleEcran> {

  // A T T R I B U T E S
  late int idart;



  // M E T H O D S
  @override
  void initState() {
    super.initState();

    idart = widget.idart;
  }

  Future<Beanarticledatahistory> getmobilearticleinformationbyidart() async {
    final url = Uri.parse('${dotenv.env['URL']}backendcommerce/getmobilearticleinformationbyidart');

    var response = await post(url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idart": idart,
          "iduser": 0,
        }));

    if(response.statusCode == 200){
      return Beanarticledatahistory.fromJson(jsonDecode(response.body));
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
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black,)
            ),
            IconButton(
                onPressed: (){},
                icon: const Icon(Icons.search, color: Colors.black)
            )
          ],
        ),
        body: FutureBuilder(
            future: Future.wait([getmobilearticleinformationbyidart()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                Beanarticledatahistory article =  snapshot.data[0];
                return Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 60,
                      child: Container(
                        color: bottombararticle,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.call,
                                color: bottombararticlecolor,
                                size: 40,
                              )
                            ),
                            Positioned(
                              right: 5,
                              top: 1,
                              bottom: 1,
                              width: 120,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: butcardviewsousproduit,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(16.0),
                                    textStyle: const TextStyle(fontSize: 20),
                                  ),
                                  onPressed: () {},
                                  child: const Text('Achetez'),
                                ),
                              )
                            ),
                            Positioned(
                                right: 130,
                                top: 1,
                                bottom: 1,
                                width: 50,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: butcardviewsousproduit,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(16.0),
                                      textStyle: const TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () {},
                                    child: const Text('+'),
                                  ),
                                )
                            ),
                            Positioned(
                                right: 185,
                                top: 0,
                                bottom: 0,
                                width: 20,
                                child: Container(
                                  //color: Colors.red,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text("0",
                                      style: TextStyle(
                                          //backgroundColor: Colors.green
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            Positioned(
                                right: 210,
                                top: 1,
                                bottom: 1,
                                width: 50,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: butcardviewsousproduit,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.all(16.0),
                                      textStyle: const TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () {},
                                    child: const Text('-'),
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
                      bottom: 60,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: 250,
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
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),
                                  options: CarouselOptions(
                                    height: 200.0,
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
                              child: Text( '${formatPrice(article.prix)} FCFA',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10,right: 10, top: 10),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text('${article.nombrearticle} article(s) restant(s)',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.green
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
                                height: 60,
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